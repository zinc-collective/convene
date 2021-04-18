Feature: Space Reliability
  In order to feel confident that my Space will be available whenever I need it
  I want a robust set of structures to ensure reliability


  Scenario: Nightly restarts
    Given a Client Space is provisioned
    When it becomes Midnight in the Client's timezone
    Then the Client Space is rebooted

  Scenario: Multiple Operators may sign in to Provisioned Convene Instances
    Given a running Convene instance that was launched from a packer image with the following ssh authorized keys:
    | user | key |
    | zee  |  https://github.com/zspencer.keys |
    | tomlee |  https://github.com/user512.keys |
    When zee uses ssh to connects to the running instance using zee's private key
    Then zee is logged into the running instance
