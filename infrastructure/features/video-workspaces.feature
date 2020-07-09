Feature: Video Workspaces
  In order discuss things face-to-face within my organization
  As Colin Collaborator and Felicia Faciliator
  I want a Video Workspace

  Scenario: Operator Provisions an 8 person Video Workspace on AWS
    Given an Operator has ran `jitsi/build` for {{clientDomain}}
    When an Operator runs the `jitsi/provision` command with:
      | arguments                        |
      | --client-domain={{clientDomain}} |
    Then a JITSI meet instance is available at https://{{clientDomain}}

  Scenario: Operator Builds an 8 person Video Workspace on AWS
    When an Operator runs the `jitsi/build` command with:
      | arguments                        |
      | --region=us-west-1               |
      | --provider=aws                   |
      | --client-domain={{clientDomain}} |
    Then a convene-jitsi-{{clientDomain}} is available within the us-west-1 region

  Scenario: Operator Builds an 8 person Video Workspace on Vultr
    When an Operator runs the `jitsi/build` command with:
      | arguments                        |
      | --region=12                      |
      | --provider=vultr                 |
      | --client-domain={{clientDomain}} |
    Then a convene-jitsi-{{clientDomain}} is available within region 12 (Silcon Valley)
