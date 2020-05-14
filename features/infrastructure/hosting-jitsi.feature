Feature: Jitsi Hosting
  In order to provide video chat to my organization
  As an Operator
  I want to host a JITSI Meet server

  Scenario: Operator Provisions a single-server JITSI instance on AWS
    Given an existing convene-jitsi AMI for {{subdomain}}.{{domain}} within the us-west-1 region
    When an Operator runs the `jitsi/provision` command with:
      | arguments          |
      | --region=us-west-1 |
      | --provider=aws     |
      | --size=t3.micro    |
      | --at-domain   https://{{subdomain}}.{{domain}} |
    Then a JITSI meet instance is provisioned on AWS with the following attributes:
      | attribute      | value                            |
      | size           | t3.micro                         |
      | region         | us-west-1                        |
      | accessible-via | https://{{subdomain}}.{{domain}} |
