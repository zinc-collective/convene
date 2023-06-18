# Note: `Room/Rooms` has been renamed to `Section/Sections`.

Feature: Navigate Between Convene and other Systems
  In order to build confidence that Convene plays well with others
  We want to hold the affordances people use to switch between Convene and other systems with a degree of care and intentionality.

  @built @unimplemented-steps
  Scenario: Navigate Between Other Tabs in the Browser and Convene
    Given an Attendee is in a Room
    When the Attendee switches to a different tab
    Then the Attendee can tell which of the other Browser tabs is the Convene Room