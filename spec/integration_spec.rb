require 'lookml/test'

describe "integration test" do

  before do
    @sdk = LookerSDK::Client.new(
      client_id: ENV['INTEGRATION_TEST_CLIENT_ID'],
      client_secret: ENV['INTEGRATION_TEST_CLIENT_SECRET'],
      api_endpoint: ENV['INTEGRATION_TEST_API_ENDPOINT'],
      connection_options: {ssl: {verify: false}}
    )

    @runner = LookMLTest::Runner.new(
      sdk: @sdk,
      branch: ENV['INTEGRATION_TEST_BRANCH'],
      email: ENV['INTEGRATION_TEST_AUTHOR_EMAIL'],
      remote_url: ENV['INTEGRATION_TEST_GIT_REMOTE'],
    )
  end

  it "works" do

  end

end
