# LookML Test Runner

An experimental test runner for LookML models. Designed to be used with continuous integration services like [Travis CI](https://travis-ci.org/) or [Circle CI](https://circleci.com/) (or anything else).

> :warning: This is an experimental project, provided as-is without support. It is in an early phase and breaking changes may occur without warning.
> 
> See the [LICENSE](LICENSE) for more details.

## How to Set Up

1. Create a Test Runner user in Looker

    Create a new user in Looker that will serve as a "machine user" to run tests. That user should have an administrator role.

    > :warning: Currently this user needs to be an administrator. Future APIs from Looker will enable the use of a less-permissioned user for running tests.

    You'll also need to get API credentials for this user.

2. Enable your chosen CI service on the Git repository associated with your LookML project.

3. Add environment variables to the CI service:

    - `LOOKER_TEST_RUNNER_CLIENT_ID`

       client ID for test user
    - `LOOKER_TEST_RUNNER_CLIENT_SECRET`

      client secret for the test user
    - `LOOKER_TEST_RUNNER_ENDPOINT`
    
      the API endpoint to use for tests

4. Add configuration files to your Git repository to configure the test runner:


    - Create a new file at the root of your repository called `Gemfile`. Add the following contents:

        ```gemfile
        source "https://rubygems.org"

        gem "lookml-test-runner", git: "https://github.com/looker/lookml-test-runner.git"
        ```

    - Configure your CI service to use the test runner:

       - For Travis CI:

          In a file called `.travis.yml`

          ```yaml
          script: bundle exec lookml_tests
          ```

    - Create test files

      The test runner will find any file ending with `.test.yml` in your repository. For example: `tests.test.yml`.

      Here's an example file for a fictional model:

      ```yaml
      - test: does anything work
        query:
          model: mymodel
          view: myexplore
          fields: ["myexplore.id"]
          sorts: ["myexplore.id asc"]
          limit: 1
        assert:
          - success
          
      - test: what about a bad field
        query:
          model: mymodel
          view: myexplore
          fields: ["myexplore.average_age"]
          limit: 1
        assert:
          - success
      ```
## Test Options

```yaml
- test: ID still exists
  query:
    model: mymodel
    view: myexplore
    fields: ["myexplore.id"]
    sorts: ["myexplore.id asc"]
    limit: 1
  assert: success
```

- `test` – The test name
- `query` – A definition of a query to run for your test. This accepts the same parameters as the [run query API](https://docs.looker.com/reference/api-and-integration/api-reference/query#run_inline_query)
- `assert` a single assertion type, or an array of assertions

### Assertion types

- `success` – The query runs and returns no errors.

## Custom Tests

The YAML-based tests are meant to be a simple and easy-to-use way to get started testing and are editable from within the Looker IDE. If you have more complex tests you can still use this project to run them. Here's how:

You can use any Ruby test runner to run your custom tests. In our example, we'll use Test::Unit.

Create a Ruby file and add it to your project. In this example we've created a file called `advanced_tests.rb`:

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

You can then use `@runner.sdk` to run any operations you want. The SDK will automatically be placed into the correct developer mode environment for your tests to run.

Then just modify the `script` in your CI configuration to `bundle exec lookml_tests && bundle exec ruby advanced_tests.rb`.
