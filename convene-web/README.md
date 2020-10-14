# Convene Web <!-- omit in toc -->

- [Contributing](#contributing)
- [System Overview](#system-overview)
- [Configuring Your Development Machine](#configuring-your-development-machine)
- [Testing Convene Web](#testing-convene-web)
- [Running Jitsi Meet Locally](#running-jitsi-meet-locally)

The Convene Web project provides a human and computer interface for managing of
Workspaces, Rooms, and Team Members.

The User Interface is written in [Stimulus](https://stimulusjs.org/).

## Contributing

See [Convene's Contributing Guide](../CONTRIBUTING.md) for an overview of
contributing to Zinc projects.

## System Overview

The central piece to Convene is `convene-web`, a Ruby on Rails server that is responsible for:
* serving the Convene UI
* managing users, workspaces, rooms, permissions, etc

The Convene UI is based on Rails standard templating system, with heavy use of:
* [Stimulus JS](https://stimulusjs.org/)
   * the entry point for our JavaScript is in `app/javascript/controllers/index.js`,
     which loads all `app/javascript/*_controllers.js` files
* [Tailwind CSS](https://tailwindcss.com/) to help speed up making good-looking UIs

Jitsi is Convene's video call infrastructure. The
[video_room_controller.js](./app/javascript/controllers/video_room_controller.js) is the entry point
where we load a Jisti video call iframe into Convene's UI.

## Configuring Your Development Machine

First, ensure your development environment has:

1. Ruby (See [.ruby-version](./.ruby-version) for version)
1. Node (See [.nvmrc](./.nvmrc) for version)
1. [PostgreSQL 12]. (Note: For people using [Docker], a [docker-compose.yml]
   file has been included for convenience.)
1. Copy `convene-web/.env.example` to `convene-web/.env` and make any changes: `cp convene-web/.env.example
   convene-web/.env`.

Then, run `bin/setup` to install Ruby and Node dependencies and set up the
database.

Once you have completed setup; run `bin/run`. You now should be able to open
http://localhost:3000/workspaces/system-test and see Convene.

Finally, with the server still running (perhaps in a different terminal), run
`bin/test` to ensure that your development environment is configured correctly.

[PostgreSQL 12]: https://www.postgresql.org/download/
[Docker]: https://www.docker.com
[docker-compose.yml]: ../docker-compose.yml
[.env.example]: ./.env.example

## Testing Convene Web

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

## Running Jitsi Meet Locally

Typically we develop Convene against a test Jitsi instance in the cloud. For the
situations when you'd rather run Jitsi locally (e.g to work on Jitsi configuration
or debugging), we provide a Dockerized setup for running Jitsi on your dev machine.

You will need a running Docker engine. See the official Docker documentation
for instructions for your specific platform: https://docs.docker.com/engine/install/

To build and run a local container with Jitsi, run:
```
$ bin/jitsi-local-run
```

This setup uses a self-signed certificate, so when accessing your local
https://jitsi you will need to bypass your browser's security warnings.

For more details on how this local Jitsi setup works, see `infrastructure/dev`.
