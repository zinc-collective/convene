@unstarted
Feature: Membership and Ownership
  In order to build a cohesive, multi-occupant Space
  I want to grant People Membership in my Space

  [Issue](https://github.com/zinc-collective/convene/issues/117)
  [Wireframe](https://xd.adobe.com/view/fd425dbe-5384-44c9-997a-eeee6e886a86-a811/screen/a2be8c5e-926e-4fa6-a9aa-bbb74430f74d/)

  Membership in a Space grants Rights to People within the Space.

  For instance, [Internal Rooms](https://github.com/zinc-collective/convene/issues/41) are only
  Enterable by Space Members.

  Other Furniture (Message Boards, Chat, Announcements, Group Video, etc) may be
  Interactive, Visible, or Hidden based upon Membership.

  Furniture may also expose different Features based upon Membership. For example,
  Members may be able to include Images in Chat, while Guests may not.

  Scenario: Inviting a Member
    When a Owner invites someone else to be a Member
    Then the Invited Person is Emailed an Invitation to the Space

  Scenario: Accepting Membership
    Given a Owner Invited someone to be a Member
    When the Invited Person accepts their Invitation
    Then the Invited Person is a Member

  Scenario: Removing a Member
    Given a Space with additional Members
    When the Owner removes an additional Member
    Then the Person is no longer a Member of the Space
    And the Person receives an email informing them of their removal from the Space

  Scenario: Inviting an Owner
    When an Owner invites someone else to be an Owner
    Then the Invited Person is Emailed an Invitation to the Space

  Scenario: Accepting Ownership
    Given an Owner Invited someone to be an Owner
    When the Invited Person accepts their Invitation
    Then the Invited Person is an Owner

  Scenario: Email Invitation Code Times out
    Given a Owner Invited someone to be a Member
    When the Invited Person waits for 30 days
    Then the Invited Person can not accept invitation

  # We need to think this through.
  # Allowing Owners to remove other Owners may result in Peril
  # Scenario: Removing an Owner