Feature: Video Workspaces
  In order discuss things face-to-face within my organization
  As Colin Collaborator and Felicia Faciliator
  I want a Video Workspace

  Scenario: Operator Builds an 8 person Video Workspace on AWS
    When an Operator runs the `videobridge/build` command with:
      | arguments           |
      | --region=us-west-1  |
      | --provider=aws      |
      | --client={{client}} |
    Then a convene-videobridge-{{client}} AMI is available within the us-west-1 region

  Scenario: Operator Provisions an 8 person Video Workspace on AWS
    Given an Operator has ran `videobridge/build` for {{client}}
    When an Operator runs the `videobridge/provision` command with:
      | arguments           |
      | --client={{client}} |
    Then a JITSI meet instance is available at https://convene-videobridge-{{client}}.zinc.coop

  Scenario: Operator Builds an 8 person Video Workspace on Vultr
    When an Operator runs the `videobridge/build` command with:
      | arguments           |
      | --region=12         |
      | --provider=vultr    |
      | --client={{client}} |
    Then a convene-videobridge-{{client}} is available within region 12 (Silcon Valley)

  Scenario: Operator Provisions an 8 person Video Workspace on Vultr and specifiy ssh username
    Given an Operator has ran `videobridge/build` for {{client}}
    When an Operator runs the `videobridge/provision` command with:
      | arguments           |
      | --client={{client}} |
      | --ssh-username=root |
    Then a JITSI meet instance is available at https://convene-videobridge-{{client}}.zinc.coop
