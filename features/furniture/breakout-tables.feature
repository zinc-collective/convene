Feature: Breakout Tables
  Breakout Tables allow Space Members to section off a Room so folks can gather
  in small(er) groups. Breakout Tables are more fluid than Rooms, in that they
  can _expire_ after a period of time, be put up, or be taken down by Space
  Members.

  @built @unimplemented-steps
  Scenario: Taking a Seat at a Breakout Table
    Given a Room with the Breakout Tables Furniture
    When a Room Occupant joins a Breakout Table
    Then the Room Occupant is no longer in the Room
    And the Room Occupant is at the Breakout Table


  @milestone-b @unstarted
  Scenario: Adding Breakout Tables to a Room
    Given a Room without the Breakout Tables furniture
    When a Space Member adds the Breakout Tables furniture to a Room
    Then Room Occupants can see the current set of Breakout Tables
    And Space Members can configure Breakout Tables from within the Room

  @milestone-b @unstarted
  Scenario: Removing Breakout Tables from a Room
    Given a Room with the Breakout Tables Furniture
    When a Space Member removes a Breakout Table
    Then Room Occupants can not see and join that Breakout Table
    And Room Occupants at the Breakout Table are returned to the Room


  @milestone-b @unstarted
  Scenario: Adding a Table to a Room's Breakout Tables
    Given a Room with the Breakout Tables Furniture
    When a Space Member adds a Breakout Table
    Then Room Occupants can see and join that Breakout Table
