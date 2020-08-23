# Convene Web

The Convene Web project provides a human and computer interface for managing of
Workspaces, Rooms, and Team Members.

The User Interface is written in [Stimulus](https://stimulusjs.org/).

## Contributing

See [Convene's Contributing Guide](../CONTRIBUTING.md) for an overview of
contributing to Zinc projects.

### Configuring your Development Machine

First, ensure your development environment has:

1. Ruby (See [.ruby-version](./.ruby-version) for version)
1. Node (See [.nvmrc](./.nvmrc) for version)
1. [PostgreSQL 12](https://www.postgresql.org/download/)

Then, run `bin/setup` to install Ruby and Node dependencies and set up the
database.

Once you have completed setup; run `bin/run`. You now should be able to open
http://localhost:3000/workspaces/system-test and see Convene.

Finally, run `bin/test` to ensure that your development environment is
configured correctly.

### Testing Convene Web

The Convene Web interface is tested in two ways:

1. Open-box unit and integration tests, which are defined in the
   [`convene-web/spec` folder](./spec)
2. Closed-box story tests, which are defined in the top level
   [`features` folder](../features)

Many enhancements and fixes can be made without updating the story tests, while
almost all changes will want updated unit or integration tests.

For story tests, we use [Cucumber] to encourage us to write tests as
human-friendly documentation.

For unit and integration tests, we use [RSpec]. RSpec is a nice complement to
Cucumber, in that it allows us to directly integrate with the underlying Ruby
and Rails code without writing human or computer interfaces that require
inter-process communication.

This helps us write small, focused tests that deal with 1~3 Ruby classes instead
of having to spin up a working instance of the entire application.

Tests that need database access should `require "rails_helper"`, and tests that
can be executed without a database should `require "spec_helper"`.

[rspec]: https://rspec.info/
[cucumber]: https://cucumber.io/
