Feature: Rooms
  # Rooms organize the information and functionality of a Space.

  # Note: `Room/Rooms` has been renamed to `Section/Sections`.

  # Adding a Room is done through the Space Edit page
  @built @unimplemented-steps @andromeda
  Scenario: Adding a Room
    Given a Space
    When a Space Member adds a Room
    Then the Room is listed in the Room Picker
    And the Room may be entered by Space Members

  # Removing a Room is done through the Space Edit page
  @unstarted @andromeda
  Scenario: Removing a Room
    Given a Space with a Room
    When a Space Member deletes the Room
    Then the Room is not listed in the Room Picker
    And the Room may not be entered by Space Members
