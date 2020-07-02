Feature: Workspace Reliability
  In order to feel confident that my Workspace will be available whenever I need it
  I want a robust set of structures to ensure reliability


  Scenario: Nightly restarts
    Given a Client Workspace is provisioned
    When it becomes Midnight in the Client's timezone
    Then the Client Workspace is rebooted