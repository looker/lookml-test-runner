require 'lookml/test'

describe "integration test" do

  before do
    sdk = LookerSDK::Client.new(
      client_id: ENV['INTEGRATION_TEST_CLIENT_ID'],
      client_secret: ENV['INTEGRATION_TEST_CLIENT_SECRET'],
      api_endpoint: ENV['INTEGRATION_TEST_API_ENDPOINT'],
      connection_options: {ssl: {verify: false}}
    )

    @runner = LookMLTest::Runner.new(
      sdk: sdk,
      branch: ENV['INTEGRATION_TEST_BRANCH'],
      email: ENV['INTEGRATION_TEST_AUTHOR_EMAIL'],
      remote_url: ENV['INTEGRATION_TEST_GIT_REMOTE'],
    )
  end

  it "runs a basic assertion" do
    result = @runner.sdk.run_inline_query("json_detail", {
      model: "wil_development",
      view: "users",
      fields: ["users.id"],
      sorts: ["users.id asc"],
      limit: 1,
    })
    expect(result.data[0]["users.id"].value).to eq(1)
  end

end
