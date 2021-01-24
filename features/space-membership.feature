Feature: Space membership

  In order to build a more coherent community
  As a Space owner
  I want to name people who can participate in the space

  @unstarted @andromeda
  Scenario: Inviting Guests
    When a Workspace Admin invites a Guest to be a Workspace Member via Email
    Then the Guest receives a Workspace Invitation Email

  @unstarted @andromeda
  Scenario: Guest Accepts Workspace Invitation Email
    Given a Guest has received a Workspace Invitation Email
    When the Guest accepts the invitation
    Then the Guest becomes a Workspace Member
    And the Workspace Member is logged in

  @unstarted @andromeda
  Scenario: Removing Space Members
    Given a Workspace with multiple Workspace Members
    When the Workspace Admin removes a Workspace Member
    Then that Workspace Member receives a Workspace Membership Revoked Email
    And the Workspace Member can still log in
    And the Workspace Member is not a member of that Workspace

  # Add noun for a person who has a convene account but is not a Members this particular space
  @unstarted @andromeda
  Scenario: Inviting Space Members who already have a convene account

  @unstarted
  Scenario: Workspace Admin Knows When A Workspace Invitation Email Bounces

  @unstarted
  Scenario: Guest Accepts The Same Workspace Invitation Email Multiple Times

  @unstarted
  Scenario: Workspace Invitation Expires
