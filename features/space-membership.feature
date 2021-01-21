Feature: Space membership

  In order to build a more coherent community
  As a Space owner
  I want to name people who can participate in the space

  @unstarted @andromeda
  Scenario: Inviting Guests
    When a Space Admin invites a Guest to be a Space Member via Email
    Then the Guest receives a Space Invitation Email

  @unstarted @andromeda
  Scenario: Guest Accepts Space Invitation Email
    Given a Guest has received a Space Invitation Email
    When the Guest accepts the invitation
    Then the Guest becomes a Space Member
    And the Space Member is logged in

  @unstarted @andromeda
  Scenario: Removing Space Members
    Given a Space with multiple Space Members
    When the Space Admin removes a Space Member
    Then that Space Member receives a Space Membership Revoked Email
    And the Space Member can still log in
    And the Space Member is not a member of that Space

  # Add noun for a person who has a convene account but is not a Members this particular space
  @unstarted @andromeda
  Scenario: Inviting Space Members who already have a convene account

  @unstarted
  Scenario: Space Admin Knows When A Space Invitation Email Bounces

  @unstarted
  Scenario: Guest Accepts The Same Space Invitation Email Multiple Times

  @unstarted
  Scenario: Space Invitation Expires
