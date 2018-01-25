require 'lookml/test'

describe "yaml test runner" do

  before do
    @yaml_tests = LookML::Test::YAMLTestCollection.new(
      dir: File.join(File.dirname(__FILE__), 'yaml_tests')
    )
  end

  it "tests the contents" do
    expect(@yaml_tests.contents[0].title).to eq("does anything work")
  end

end
