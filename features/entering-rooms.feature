Feature: Entering Rooms
  In order to interact with other People
  I want to enter a Room

  Rooms are where People gather, and can be entered in a number of ways.

  Most frequently, we expect people to enter a Room from their Workspace
  dashboard or by leaving one Room to enter another.

  However, we also want to support Reople entering a Room via
  the Room's full URI or from a short URI when a Space has a Branded Domain.

  @built
  Scenario: Entering Room via Room Picker from Workspace Dashboard
    Given the Workspace Member is on the "System Test" Workspace Dashboard
    When the Workspace Member taps the "Listed Room 1" Room in the Room Picker
    Then the Workspace Member is placed in the "Listed Room 1" Room

  @built
  Scenario: Entering Room via Room Picker from another Room
    Given the Workspace Member is in the "System Test" Workspace and in the "Listed Room 1" Room
    When the Workspace Member taps the "Listed Room 2" Room in the Room Picker
    Then the Workspace Member is placed in the "Listed Room 2" Room

  @built @unimplemented-steps
  Scenario: Entering Room via Slug on a Branded Domain
    Given a Workspace with a Branded Domain
    When I visit a Room's using a slug on their Branded Domain
    Then I am in the Room

  @built
  Scenario: Entering Room via Room full URL
    When the Workspace Member visit the "System Test" Workspace, "Listed Room 1" Room full URL
    Then the Workspace Member is placed in the "Listed Room 1" Room

  @built @unimplemented-steps
  Scenario: Entering Room via back button
    Given the Workspace Member is in the "System Test" Workspace and in the "Listed Room 1" Room
    When the Workspace Member taps the "Listed Room 2" Room in the Room Picker
    And the Workspace Member is placed in the "Listed Room 2" Room
    And the Workspace Member hit the back button
    Then the Workspace Member is placed in the "Listed Room 1" Room
