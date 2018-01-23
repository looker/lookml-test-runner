module LookMLTest
  class Runner

    class LookMLTestError < StandardError; end

    def initialize(sdk:, remote_url:, branch:)
      @sdk = sdk
      @branch = branch
      @remote_url = remote_url

      enter_dev_mode!
      checkout_branch!
    end

    private def enter_dev_mode!
      @sdk.update_session workspace_id: 'dev'
    end

    private def project
      @project ||= begin
        @sdk.all_projects.find{|p| p.git_remote_url == @remote_url }
      end
    end

    private def checkout_branch!
      @sdk.project_checkout_branch project_id: project.id, branch_name: @branch
    end

    private def pull_branch!
      @sdk.project_pull_branch project_id: project.id
    end

    private def workspace
      @sdk.project_workspace project_id: project.id
    end

  end
end
