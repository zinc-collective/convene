Feature: Entering Rooms
  In order to interact with other People
  I want to enter a Room

  Rooms are where People gather, and can be entered in a number of ways.

  Most frequently, we expect people to enter a Room from their Space
  dashboard or by leaving one Room to enter another.

  However, we also want to support Reople entering a Room via
  the Room's full URI or from a short URI when a Space has a Branded Domain.

  Background:
    Given a "System Test" Space

  @built
  Scenario: Entering Room via Room Picker from Space Dashboard
    Given the Space Member is on the "System Test" Space Dashboard
    When the Space Member taps the "Room 1" Room in the Room Picker
    Then the Space Member is placed in the "Room 1" Room

  @built
  Scenario: Entering Room via Room Picker from another Room
    Given the Space Member is in the "System Test" Space and in the "Room 1" Room
    When the Space Member taps the "Room 2" Room in the Room Picker
    Then the Space Member is placed in the "Room 2" Room

  @built @unimplemented-steps
  Scenario: Entering Room via Slug on a Branded Domain
    Given a Space with a Branded Domain
    When I visit a Room's using a slug on their Branded Domain
    Then I am in the Room

  @built
  Scenario: Entering Room via Room full URL
    When the Space Member visit the "System Test" Space, "Room 1" Room full URL
    Then the Space Member is placed in the "Room 1" Room

  @built @unimplemented-steps
  Scenario: Entering Room via back button
    Given the Space Member is in the "System Test" Space and in the "Room 1" Room
    When the Space Member taps the "Room 2" Room in the Room Picker
    And the Space Member is placed in the "Room 2" Room
    And the Space Member hit the back button
    Then the Space Member is placed in the "Room 1" Room
