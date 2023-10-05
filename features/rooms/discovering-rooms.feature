Feature: Discovering Rooms
  In order to interact with other people in a Space
  I want to be able to explore the Space's rooms

  @built @unimplemented-steps
  Scenario: Space Member may discover Room
    Given a Space with a Room
    When a Space Member is on the Space Dashboard
    Then they see the Room

  @built @unimplemented-steps
  Scenario: Guest may discover Room
    Given a Space with a Room
    When a Guest is on the Space Dashboard
    Then they see the Room

  @unstarted
  Scenario: Guest may not discover Internal Room
    Given a Space with an Internal Room
    When a Guest is on the Space Dashboard
    Then they do not see the Room
