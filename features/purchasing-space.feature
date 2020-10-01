Feature: Purchasing Space
  In order to have a place on the Internet for _Me_
  I want to buy a Space

  See: https://github.com/zinc-collective/convene/issues/8


  Buying a Space grants People the right to configure the Space by adding Rooms,
  connecting Utilities, and laying out Furniture.

  @unimplemented @unimplemented-steps
  Scenario: Buying a Space
    Given we are accepting pre-orders for Convene
    When a Guest buys a Space
    Then a Space is created with them as the Space Owner
    And the new Space's status is Pending Approval
    And they are sent an onboarding email

