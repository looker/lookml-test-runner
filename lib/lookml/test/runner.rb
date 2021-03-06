module LookML
  module Test
    class Runner

      class Failure < StandardError; end

      attr_reader :sdk

      def self.runner
        sdk = LookerSDK::Client.new(
          client_id: ENV['LOOKER_TEST_RUNNER_CLIENT_ID'],
          client_secret: ENV['LOOKER_TEST_RUNNER_CLIENT_SECRET'],
          api_endpoint: ENV['LOOKER_TEST_RUNNER_ENDPOINT'],
          connection_options: ENV['LOOKER_TEST_RUNNER_INSECURE'] == 'true' ? {ssl: {verify: false}} : {}
        )
        return new(
          sdk: sdk,
          branch: ENV['TRAVIS_BRANCH'] || ENV['CIRCLE_BRANCH'],
          email: ENV['LOOKER_TEST_RUNNER_EMAIL'] || `git log -1 --pretty=format:'%ae'`.strip,
          remote_url: ENV['LOOKER_TEST_RUNNER_GIT_REMOTE'] || `git config --get remote.origin.url`.strip,
        )
      end

      def initialize(sdk:, remote_url:, branch: nil, email: nil)
        @sdk = sdk
        @branch = branch
        @email = email
        @remote_url = remote_url

        # Ensure SDK is working
        @sdk.alive

        ensure_in_relevant_project!
      end

      private def enter_dev_mode!
        @sdk.update_session workspace_id: 'dev'
      end

      private def project
        @project ||= begin
          @sdk.all_projects.find{|p| p.git_remote_url == @remote_url }
        end
      end

      private def ensure_in_relevant_project!
        if @sdk.respond_to?(:project_checkout_branch)
          puts "Using checkout strategy: normal"
          unless @branch
            raise LookMLTestFailure.new("A branch name is required for normal checkout strategy.")
          end
          enter_dev_mode!
          @sdk.project_checkout_branch project_id: project.id, branch_name: @branch
          @sdk.project_pull_branch project_id: project.id
        else
          puts "Using checkout strategy: jank"
          unless @email
            raise LookMLTestFailure.new("A author email is required for jank checkout strategy.")
          end
          # This is a janky workaround for versions of Looker that don't have
          # branch checkout APIs
          user = @sdk.search_users(email: @email, is_disabled: false).first
          unless user
            raise LookMLTestFailure.new("Could not determine the correct Looker user for email #{@email}")
          end
          # Replace the SDK with the SDK for the sudoed user
          sudo_token = @sdk.login_user(user.id).access_token
          @sdk = LookerSDK::Client.new({
            access_token: sudo_token,
            api_endpoint: @sdk.api_endpoint,
            connection_options: @sdk.connection_options,
          })
          enter_dev_mode!
        end
      end

      private def workspace
        @sdk.project_workspace project_id: project.id
      end

    end
  end
end
