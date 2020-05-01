Feature: Jitsi Hosting
  In order to provide video chat to my organization
  As an Operator
  I want to host a JITSI Meet server

  Scenario: Operator Provisions a single-server JITSI instance on AWS
    Given AWS Access Key and Secret with the rights to provision instances
    And an empty hosts inventory
    And a public domain with a wildcard SSL certificate
    When an Operator runs the `jitsi/provision` command with:
      | arguments                                    |
      | --instance-size=t3.micro                     |
      | --include-nginx                              |
      | --ssl-certificate={{ path_to_wildcard_ssl }} |
      | --public-domain={{ subdomain }}.{{domain}}   |
    Then a JITSI meet instance is provisioned with the following attributes:
      | attribute      | value                            |
      | instance-size  | t3.micro                         |
      | accessible-via | https://{{subdomain}}.{{domain}} |
    And the IP address is added to the hosts' inventory definition within the "[jitsi_hosts]" group