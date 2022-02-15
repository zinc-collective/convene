@utility-jitsi @milestone-andromeda
Feature: Furniture: VideoBridge
  # Chat with Friends! Face to Face! Over the Internet!

  Background:
    Given a "VideoBridge Demo" Space
    And the "VideoBridge Demo" Space has a fully configured "Jitsi" Utility
    And the "VideoBridge Demo" Space has a "VideoBridge Demo" Room
    And the "VideoBridge Demo" Room has a VideoBridge

  @unimplemented-steps
  Scenario: Opening a VideoBridge
    Given a Guest "Joe Schmoe" is in the "VideoBridge Demo" Room
    When the Guest "Joe Schmoe" Opens the VideoBridge
    Then the Guest "Joe Schmoe" can see and hear everyone in the VideoBridge

  @unimplemented-steps
  Scenario: Closing a VideoBridge
    Given a Guest "Joe Schmoe" is in the "VideoBridge Demo" Room
    And the Guest "Joe Schmoe" has Opened the VideoBridge
    When the Guest "Joe Schmoe" Closes the VideoBridge
    Then the Guest "Joe Schmoe" is in the "VideoBridge Demo" Room
    And the Guest "Joe Schmoe" cannot see or hear anyone in the VideoBridge

