Feature: Hookups: Jitsi Meet
  In order to support audio/video calls between Space Members
  I want to Hookup Jitsi Meet to my Space

  # @see: https://jaas.8x8.vc

  @unstarted @milestone-a
  Scenario: Configuring the Jitsi Meet Hookup
    Given a Space with a new Jitsi Meet Hookup
    When a Space Owner sets the following Configuration for that Hookup
      | field              | value                              |
      | url                | https://jitsi-meet.example.com     |
      | application_id     | this-is-provided-by-jitsi-meet     |
      | application_secret | secret-key-used-to-generate-tokens |
    Then the Jitsi Meet Hookup is Ready to Use