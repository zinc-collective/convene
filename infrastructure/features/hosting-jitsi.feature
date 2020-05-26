Feature: Jitsi Hosting
  In order to provide video chat to my organization
  As an Operator
  I want to host a JITSI Meet server

  @0.1-alpha
  Scenario: Operator Provisions a Clients single-server JITSI instance on AWS
    Given an Operator has ran `jitsi/build` for {{clientDomain}}
    When an Operator runs the `jitsi/provision` command with:
      | arguments                        |
      | --client-domain={{clientDomain}} |
    Then a JITSI meet instance is available at https://{{clientDomain}}

  @0.1-alpha
  Scenario: Operator Builds a Clients single-server JITSI AMI on AWS
    When an Operator runs the `jitsi/build` command with:
      | arguments                        |
      | --region=us-west-1               |
      | --provider=aws                   |
      | --client-domain={{clientDomain}} |
    Then a convene-jitsi-{{clientDomain}} is available within the us-west-1 region