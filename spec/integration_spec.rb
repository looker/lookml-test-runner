require 'test_helper'

describe "integration test" do

  before do
    @runner = TEST_RUNNER
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
