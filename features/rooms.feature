Feature: Rooms
  # Rooms organize the information and functionality of a Space. Rooms can be
  # Locked (see: features/rooms/locking-rooms.feature) or only visible to Space # Members.


  # Adding a Room is done through the Space Edit page
  @unstarted @andromeda
  Scenario: Adding a Room
    Given a Space
    When a Space Member adds a Room
    Then the Room is listed in the Room Directory
    And the Room may be entered by Space Members

  # Removing a Room is done through the Space Edit page
  @unstarted @andromeda
  Scenario: Removing a Room
    Given a Space with a Room
    When a Space Member deletes the Room
    Then the Room is not listed in the Room Directory
    And the Room may not be entered by Space Members