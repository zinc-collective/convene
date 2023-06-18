# Note: `Room/Rooms` has been renamed to `Section/Sections`.
# Note: `Furniture` has been renamed to `Gizmo/Gizmos`.

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

  Note: `Furniture` has been renamed to `Gizmo/Gizmos`.

  @unstarted
  Scenario: Removing a Member
    Given a Space with additional Members
    When the Owner removes an additional Member
    Then the Person is no longer a Member of the Space
    And the Person receives an email informing them of their removal from the Space

  # We need to think this through.
  # Allowing Owners to remove other Owners may result in Peril
  # Scenario: Removing an Owner
