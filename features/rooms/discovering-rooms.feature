Feature: Discovering Rooms
  In order to interact with other people in a Space
  I want to be able to explore the Space's rooms

  @built @unimplemented-steps
  Scenario: Space Member may discover Listed Room
    Given a Space with a Listed Room
    When a Space Member is on the Space Dashboard
    Then they see the Room

  @built @unimplemented-steps
  Scenario: Guest may discover Listed Room
    Given a Space with a Listed Room
    When a Guest is on the Space Dashboard
    Then they see the Room

  @unstarted
  Scenario: Guest may not discover Listed Internal Room
    Given a Space with an Listed Internal Room
    When a Guest is on the Space Dashboard
    Then they do not see the Room

  # Unlisted Rooms
  @built
  Scenario: Guest may not discover Unlisted Rooms
    Given a "System Test" Space
    When the Guest is on the "System Test" Space Dashboard
    Then the Guest does not see the "Unlisted Room 1" Room's Door

  @built
  Scenario: Space Member may not discover Unlisted Room
    Given a "System Test" Space
    When the Space Member is on the "System Test" Space Dashboard
    Then the Space Member does not see the "Unlisted Room 1" Room's Door

  @unstarted @unimplemented-steps
  Scenario: Room Creator may discover Unlisted Room
    Given a Space with an Unlisted Room
    When the Room Creator is on the Space Dashboard
    Then they see the Room


  @unstarted
  Scenario: Room Previous Attendee may discover previously visited Unlisted Room
    Given a Space with an Unlisted Room
    When a Previous Attendee of that Room is on the Space Dashboard
    Then they see the Room
