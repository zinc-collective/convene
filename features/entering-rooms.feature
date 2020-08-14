Feature: Entering Rooms
  In order to interact with other People
  I want to enter a Room

  Rooms are where People gather, and can be entered in a number of ways.

  Most frequently, we expect people to enter a Room from their Workspace
  dashboard or by leaving one Room to enter another.

  @built
  Scenario: Entering Room via Room Picker from Workspace Dashboard
    Given I am on a Workspace Dashboard
    When I tap the Room in the Room Picker
    Then I am in the Room

  @built @unimplemented-steps
  Scenario: Entering Room via Room Picker from another Room
    Given I am in a Room
    When I tap a different Room in the Room Picker
    Then I am in the Room

  # However, we also want to support Reople entering a Room via
  # the Room's full URI or from a short URI when a Space has a Branded Domain.

  @built @unimplemented-steps
  Scenario: Entering Room via Slug on a Branded Domain
    Given a Workspace with a Branded Domain
    When I visit a Room's using a slug on their Branded Domain
    Then I am in the Room

  @built @unimplemented-steps
  Scenario: Entering Room via Room full URL
    When I visit a Room's full URL
    Then I am in the Room