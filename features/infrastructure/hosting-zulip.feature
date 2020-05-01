Feature: Zulip Hosting
  In order to facilitate asynchronous text conversations
  As an Operator
  I would like to be able to host a Zulip instance for my community

  Scenario: Provisioning a single-server Zulip instance on AWS
    Given AWS Access Key and Secret with the rights to provision instances
    And an empty hosts inventory
    And a public domain with a wildcard SSL certificate
    When an Operator runs the `zulip/provision` command with:
    | arguments |
    | --instance-size=t3.micro |
    | --public-domain={{ subdomain }}.{{domain}} |
    Then a JITSI meet instance is provisioned with the following attributes:
    | attribute | value |
    | instance-size | t3.micro |
    | accessible-via | https://{{subdomain}}.{{domain}} |
    And the IP address is added to the hosts' inventory definition within the "[zulip_hosts]" group