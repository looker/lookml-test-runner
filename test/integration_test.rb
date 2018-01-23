require_relative './test_helper'

sdk = LookerSDK::Client.new(
  client_id: ENV['INTEGRATION_TEST_CLIENT_ID'],
  client_secret: ENV['INTEGRATION_TEST_CLIENT_SECRET'],
  api_endpoint: ENV['INTEGRATION_TEST_API_ENDPOINT'],
)

runner = LookMLTest::Runner.new(sdk: sdk, branch: ENV['INTEGRATION_TEST_BRANCH'])
