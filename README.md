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
