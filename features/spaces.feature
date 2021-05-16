Feature: Spaces
  In order to have an online presence
  I want to have a Space

  Scenario: Creating a Space


  # Spaces by default show the list of Rooms as their furniture. Spaces can
  # also have an _Entrance_ which allows Furniture to be visible as well.

  @built @unimplemented-steps
  Scenario: Space Entrances
    Given a Space with a Room specified as its Entrance
    When Anyone visits the Space
    Then they see the Furniture in the Entrance Room

  @built @unimplemented-steps
  Scenario: Space without Entrances
    Given a Space with no Entrance
    When Anyone visits the Space
    Then they only see the Rooms
