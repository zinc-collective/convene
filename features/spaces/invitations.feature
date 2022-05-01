Feature: Spaces: Invitations
  Invitations allow Space Owners to bring additional people into the Space

  Background:
    Given a "System Test" Space
    And the "System Test" Space has a Space Owner "space-owner@example.com"

  @built @andromeda
  Scenario: Inviting new Members via Email
    When an Invitation to the "System Test" Space is sent by Space Owner "space-owner@example.com"
      | name | email                       |
      | Aang | aang-the-avatar@example.com |
    Then an Invitation to "aang-the-avatar@example.com" for the "System Test" Space is delivered
    And the Invitation to "aang-the-avatar@example.com" for the "System Test" Space has a status of "pending"


  # We create new Invitation(s) when inviting someone again, so that we have a record of how many times someone was
  # invited. We allow people to accept any of the un-expired invitations that they have been sent.
  @built @unimplemented-steps @andromeda
  Scenario: Re-inviting before an Invitation Expires
    Given an Invitation to the "System Test" Space was sent by Space Owner "space-owner@example.com"
      | name | email                       | created_at  |
      | Aang | aang-the-avatar@example.com | 13 days ago |
    When an Invitation to the "System Test" Space is sent by Space Owner "space-owner@example.com"
      | name | email                       |
      | Aang | aang-the-avatar@example.com |
    Then an Invitations to "aang-the-avatar@example.com" for the "System Test" Space is delivered
    And two Invitations to "aang-the-avatar@example.com" for the "System Test" Space have a status of "pending"

  @built @unimplemented-steps @andromeda
  Scenario: Re-inviting a Member after their Invitation Expires
    Given an Invitation to the "System Test" Space was sent by Space Owner "space-owner@example.com"
      | name | email                       | created_at  |
      | Aang | aang-the-avatar@example.com | 15 days ago |
    When an Invitation to the "System Test" Space is sent by Space Owner "space-owner@example.com"
      | name | email                       |
      | Aang | aang-the-avatar@example.com |
    Then an Invitations to "aang-the-avatar@example.com" for the "System Test" Space is delivered
    And an Invitation to "aang-the-avatar@example.com" for the "System Test" Space has a status of "pending"
    And an Invitation to "aang-the-avatar@example.com" for the "System Test" Space has a status of "expired"


  @unstarted @andromeda
  Scenario: Invitations remain even if the Invitor was Removed from the Space
    Given the "System Test" Space has a Space Owner "soon-to-leave@example.com"
    And an Invitation to the "System Test" Space is sent by Space Owner "soon-to-leave@example.com"
      | name | email                       |
      | Aang | aang-the-avatar@example.com |
    And the "System Test" Space removes the Space Owner "soon-to-leave@example.com"
    When the Invitation to "aang-the-avatar@example.com" is Accepted
    Then the "System Test" Space has a Space Member "aang-the-avatar@example.com"


  @unstarted @unscheduled
  Scenario: Inviting new Members via SMS
    When a Space Owner invites a new Space Member via SMS
    Then an Invitation is sent to that SMS