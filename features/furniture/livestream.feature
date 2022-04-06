Feature: Furniture: Livestream
  In order to host streaming events on my own web space
  I want to embed a Livestream

  @andromeda @unimplemented-steps
  Scenario: Livestreaming from Twitch
    Given a Public Room with the Livestream Furniture installed and configured with:
      | setting  | value      |
      | channel  | zeespencer |
      | provider | twitch     |
      | layout   | video      |
    When a Guest visits the Room
    Then the Livestream is playing the "zeespencer" Twitch Channel


