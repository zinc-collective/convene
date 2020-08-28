# Convene

Space to (play || work || grow || be).

## Purpose

Convene is the _Means of Connection_. It's space to co-conspire, to relax, or
to push your limits. The premise behind Convene is simple:

1. Define a _Space_, with _Rooms_.
2. Gather _People_ in those _Rooms_.
3. _Do things_ together.

We provide the infrastructure.

You provide the purpose.

Convene is _Community Owned_. Passport Holders vote on _Resident
Representatives_.  _Maintainers and Contributors_ vote on _Worker
Representatives_. Representatives sit in the [Circle of Stewards], and guide the
[Budget] and set [Objectives].


[Circle of Stewards]: #the-circle-of-stewards
[Budget]: #budget
[Objectives]: #objectives
### The Circle of Stewards

The Circle of Stewards is balanced 1 to 1 between Community Representatives and
Worker Representatives. This ensures that consensus must be reached between the
people using and the people building Convene.

### Budget

At present, Convene allocates 33% of revenue towards infrastructure, 33%
towards operations, and 33% towards paying contributors and maintainers through
[Patronage Payouts].

### Objectives

Convene is driving towards:

1. Face-to-face connection
2. For small groups
3. Co-creating a better future.

We're still figuring out how to make that happen, but that's our guiding light.

## Developing Convene

Once you have installed the appropriate `ruby` and `node` and `postgresql` versions run `bin/setup`. See [Convene::Web/README.md "Configuring your Development Machine"] for more information.

[Convene::Web/README.md "Configuring your Development Machine"]:./convene-web/README.md#configuring-your-development-machine

## Using Convene

Convene is [pre-alpha software], so while we intend to provide interfaces that
do not require a high degree of technical skill to operate, our current phase
expects operators to be comfortable with infrastructure management techniques
and tooling such as [Ansible], [Hashicorp's product line][hashicorp-products],
or similar.

[ansible]: https://www.ansible.com/
[hashicorp-products]: https://learn.hashicorp.com/
[pre-alpha software]:
  https://en.wikipedia.org/wiki/Software_release_life_cycle#Pre-alpha

### Purchasing Convene

Convene is licensed under the [Prosperity Public License]. This provides
generous usage rights to individuals and non-commercial organizations to use
Convene however they see fit.

If your organization engages in commerce, defined as taking currency in exchange
for goods or services, then the organization must purchase a license to use
Convene.

Pricing is determined on a case-by-case basis, with an emphasis on mutually
beneficial socioeconomic transactions.

### Help and Support

Organizations and individuals who are comfortable relying on free Community
Support are encouraged to [create issues in our public issue
tracker][issue-tracker]. A maintainer will respond as they are available.

Paid support is available for \$135 USD per hour<sup>[1][footnote-1]</sup>.

[prosperity public license]: https://prosperitylicense.com/
[issue-tracker]: https://github.com/zinc-collective/convene/issues

## Architecture

At present, Convene is split into three modules:

- `infrastructure`, which contains infrastructure management code for Packer,
  Terraform and Ansible.
- `web` which provides the human interface for Convene.
- `api` which stores data long-term and provides a programmatic interface.

## Design

We have a set of [Personas](https://drive.google.com/open?id=1JwTh2uFTc6pxsXu3njEVKQrv-J5HWExhd1rgT-ravt4) that we use to guide our design and development. Designers who have agreed to protect the privacy of our clients may access our [Customer Research Interviews](https://drive.google.com/drive/u/2/folders/1gncYSkVIAj4CnlUZM9KPQlFdj_aqulDl)

## Footnotes

### Paid Support

Our paid support rate is pegged to 3x [the San Francisco Living Wage for a
couple with a single worker raising three children][san-francisco-living-wage].

This rate is negotiable for organizations that offer Zinc a [patronage
account][what-is-patronage] or corresponding equity stake.

Paid support clients may also request a deferred payment program, with terms to
be determined on a case-by-case basis.

[footnote-1]: #paid-support
[san-francisco-living-wage]: https://livingwage.mit.edu/metros/41860
[what-is-patronage]:
  https://www.co-oplaw.org/finances-tax/patronage/#How_Patronage_Works
