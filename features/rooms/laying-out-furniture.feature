Feature: Rooms: Laying Out Furniture
  For Rooms to be tailored to their particular purpose, we allow people to add,
  remove, reorder, and otherwise change the Rooms Furniture.

  @unbuilt @andromeda
  Scenario: Adding Furniture
    Given a Space with an Empty Room
    When a Space Member adds a Text Block Furniture to that Room
    Then that Room has a Text Block in it

  @unbuilt @andromeda
  Scenario: Re-Ordering Furniture
    Given a Space with a Room with the following Furniture:
      | text block |
      | tip jar    |
      | text block |
    When a Space Member moves the Tip Jar Furniture to the Top of the Room
    Then that Room has the following Furniture:
      | tip jar    |
      | text block |
      | text block |

  @unbuilt @andromeda
  Scenario: Removing Furniture
    Given a Space with a Room with the Following Furniture:
      | text block |
      | tip jar    |
    When a Space Member removes the Text Block furniture
    Then that Room has the following Furniture:
      | tip jar |