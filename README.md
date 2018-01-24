# Setup

### 1. Create new user on Looker instance

Make sure this user has:

- API credentials
- the admin role

### 2. Add environmental variables to your CI tool

`LOOKER_TEST_RUNNER_CLIENT_ID` = client ID for test user
`LOOKER_TEST_RUNNER_CLIENT_SECRET` = client secret for the test user
`LOOKER_TEST_RUNNER_ENDPOINT` = the API endpoint to use for tests

#### Test Branch

`lookml-test-runner` automatically looks for either `TRAVIS_BRANCH` or `CIRCLE_BRANCH` (in that order) to determine the branch to use for tests, so make sure one of these is set

### 3. Add test code and Gemfile to your repository

#### Example

`Gemfile`

```
source "https://rubygems.org"

gem "lookml-test-runner", git: "https://github.com/looker/lookml-test-runner.git"
gem "minitest"

# other Gems you need for testing
```

`.travis.yml`

```
script: ruby test.rb
```

`test.rb`

```
require "bundler/setup"
require "minitest/autorun"
require 'lookml/test'

class TestLookML < Minitest::Test
  def setup
    @runner = LookML::Test::Runner.runner
  end

  def test_basic
    result = @runner.sdk.run_inline_query("json_detail", {
      model: "lookml_test_test_fun",
      view: "users",
      fields: ["users.id"],
      sorts: ["users.id asc"],
      limit: 1,
    })
    assert_equal(result.data[0]["users.id"].value, 1)
  end
end
```

### 4. Make sure Looker repository has pull requests enabled/required

### 5. Success!
:boom:
