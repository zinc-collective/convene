Feature: Spaces: Invitations
  Invitations allow Space Owners to bring additional people into the Space

  @built @andromeda
  Scenario: Inviting new Members via Email
    Given a "System Test" Space
    And the "System Test" Space has a Space Owner "space-owner@example.com"
    When an Invitation to the "System Test" Space is sent by Space Owner "space-owner@example.com"
      | name | email                       |
      | Aang | aang-the-avatar@example.com |
    Then an Invitation to "aang-the-avatar@example.com" for the "System Test" Space is delivered
    And the Invitation to "aang-the-avatar@example.com" for the "System Test" Space has a status of "pending"


  # We create new Invitation(s) when inviting someone again,
  # so that we have a record of how many times someone was
  # invited.
  @built @unimplemented-steps @andromeda
  Scenario: Re-inviting before an Invitation Expires
    Given an Invitation was sent less than 14 days ago
    When a Space Owner re-invites that Invitation's contact info
    Then a new Invitation is sent
    # We decided allowing people to accept any of the un-Expired invitations
    # that they have been sent was better for the UX than invalidating
    # duplicate Invitations.
    And the old Invitation can still be accepted

  @built @unimplemented-steps @andromeda
  Scenario: Re-inviting a Member after their Invitation Expires
    Given an Invitation was sent 15 days ago
    When a new Invitation is sent to that Invitation's contact info
    And the old Invitation can not still be accepted

  @unstarted @andromeda
  Scenario: Accepting an Invitation as a Neighbor
    Given an Invitation was sent to a Neighbor
    When the Neighbor accepts that Invitation
    Then that Neighbor becomes a Space Member
    And that Invitation is Accepted
    And all other Invitations to that Invitation's contact info are Resolved

  @unstarted @andromeda
  Scenario: Accepting an Invitation as a Guest
    Given an Invitation was sent less than 14 days ago
    When a Guest accepts that Invitation
    Then the Guest becomes a Space Member
    And that Invitation is Accepted
    And all other Invitations to that Invitation's contact info are Resolved

  # We want to make sure that people who were invited but
  # didn't take action can't suddenly appear and disorient
  # or potentially disrupt the people who are in the Space.
  @unstarted @andromeda
  Scenario: Invitation Code Times out after 14 days
    Given an Invitation was sent 15 days ago
    Then that Invitation is Expired
    And that Invitation cannot be Accepted

  # We want to demonstrate that we care about folks having the
  # affordances to prevent harassment or spam; so we want to provide
  # an explicit option to block further invitations from the Space
  @unstarted @andromeda
  Scenario: Blocking Further Invitations


  @unstarted @unscheduled
  Scenario: Inviting new Members via SMS
    When a Space Owner invites a new Space Member via SMS
    Then an Invitation is sent to that SMS