# Convene::Infrastructure

Tools to manage the infrastructure for Convene clients.

## Usage

See documentation in the `features` directory to learn how to run the commands
that provision client infrastructure.

Convene::Infrastructure uses the following tools to ensure broad
interoperability between infrastructure providers.

- [Packer](https://www.packer.io/intro/getting-started/)
- [Terraform](https://learn.hashicorp.com/terraform/getting-started/install.html)

Please ensure both packages have been installed and are available to run from
your command line.

### Adding Clients

Each client has a folder under `clients` named for the domain we will be
installing infrastructure to. By default, the folder will include their `public.tfvars` file, with
a `secrets.tfvars` file with any API credentials. **Only Zinc staff may access `secrets.tfvars`.**

See [`./clients/meet.zinc.coop`](./clients/meet.zinc.coop) for an example.
