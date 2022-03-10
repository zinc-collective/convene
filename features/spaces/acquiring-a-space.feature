Feature: Spaces: Acquiring a Space
  See: https://github.com/zinc-collective/convene/issues/8

  Acquire a slice of the community owned Internet. Own your online presence.

  @unimplemented @unimplemented-steps
  Scenario: Joining the Waitlist
    When a Guest submits the Space Onboarding Form with the following values:
      | space name         | Zee's Space         |
      | slug               | zee-at-home         |
      | domain             | home.zeespencer.com |
      | use                | personal            |
      | prepurchase amount | $5                  |
      | owner email        | zee@example.com     |
      | owner name         | Zee Spencer         |
    Then a Pending "Zee's Space" Space is created
    And the Operators are sent a new Space Email
    And a Space Pending email is sent to the Space Owner "zee@example.com"

  @unimplemented @unimplemented-steps
  Scenario: Visiting Spaces on the Waitlist
    Given "Zee's Space" is on the Waitlist
    And the "Zee's Space" Space has a Space Owner "zee@example.com"
    Then Guests visiting the "Zee's Space" Space are told it is coming soon
    And Neighbors visiting the "Zee's Space" Space are told it is coming soon
    And the Space Owner "zee@example.com" visiting the "Zee's Space" Space are given the full experience

  @unimplemented @unimplemented-steps
  Scenario: Approving a Space
    Given "Zee's Space" Space is on the Waitlist
    And the "Zee's Space" Space has a Space Owner "zee@example.com"
    And the Operators approve the Space
    Then Guests visiting the "Zee's Space" Space are given the full experience
    Then Neighbors visiting the "Zee's Space" Space are given the full experience
    And the Space Owner "zee@example.com" visiting the "Zee's Space" Space are given the full experience

