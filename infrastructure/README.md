# Convene::Infrastructure

Tools to manage the infrastructure for Convene clients.

## Usage

See documentation in the `features` directory to learn how to run the commands
that provision client infrastructure.

Convene::Infrastructure uses the following tools to ensure broad
interoperability between infrastructure providers.

- [Packer](https://www.packer.io/intro/getting-started/)
- [Terraform](https://learn.hashicorp.com/terraform/getting-started/install.html)
- [Ansible](https://www.ansible.com/resources/get-started)

Please ensure all three are installed and run from your command line.

### Creating Your Own Convene Space

There are two steps to creating a Convene Video Space:

1. [Building a Space's Blueprint](#building-a-spaces-blueprint)
1. [Provisioning a Space from the Blueprint](#provisioning-a-space-from-the-blueprint)

Every Convene Video Space has a _Blueprint_. Blueprints define:

1. The Infrastructure provider(s) your Space will run on.
2. The Space's security, reliability, and performance configuration
   specification.
3. The [golden image(s)] that will be placed within the Infrastructure provider
   when provisioned.

Each Blueprint includes the following files:

- `infrastructure.tf`: Terraform file configuring the infrastructure.
- `public.tfvars`: Variables that are safe to share with the world.
- `secrets.tfvars`: API credentials or other variables that are not safe to save
  to the repository. `.gitignore`d by default.

There are example Blueprints for:

- [Amazon Web Services], [in `clients/convene-test-aws.zinc.coop`]
- [Vultr], [in `clients/convene-test-vultr.zinc.coop`]

[in `clients/convene-test-aws.zinc.coop`]: ./clients/convene-test-aws.zinc.coop
[in `clients/convene-test-vultr.zinc.coop`]:
  ./clients/convene-test-vultr.zinc.coop
[amazon web services]: https://aws.amazon.com/
[vultr]: https://www.vultr.com/
[golden image(s)]: https://www.quora.com/What-is-golden-image

#### Building a Space's Blueprint

For step-by-step instructions for building a Space, see the "Operator
builds..." scenarios in [`features/video-spaces.feature`].

A visual overview of what happens when an Operator builds a Blueprint is as
follows:

![Operator Builds a Convene Space](./docs/operator-builds-a-convene-space.png)

[`features/video-spaces.feature`]: ./features/video-spaces.feature

#### Provisioning a Space from the Blueprint

For step-by-step instructions for building a Space, see the "Operator
Provisions..." scenarios in [`features/video-spaces.feature`].
