Feature: Locking Rooms
  In order to maintain control over who may participate in a conversation
  As a Workspace Member
  I would like to be able to lock Rooms


  Rooms have three different security levels:

  1. Unlocked, which grants access to anyone.
  2. Internal, which grants access to any Workspace Member.
  3. Locked, which grants access only to people who know the Room's Key.

  Design and discussion of the room access model may be found on GitHub at
  https://github.com/zinc-collective/convene/issues/12


  The following scenarios illustrate how these permissions play out
  based upon who is accessing rooms with which access level.

  # Wireframe:
  # https://xd.adobe.com/view/fd425dbe-5384-44c9-997a-eeee6e886a86-a811/screen/04ee266e-931b-4bde-bcf9-af94c7ac444e
  @built
  Scenario: Entering a Locked Room
    Given a Workspace with a Locked Room
    Then a Workspace Member may enter the Locked Room after providing the correct Room Key
    And a Workspace Member may not enter the Locked Room after providing the wrong Room Key
    And a Guest may enter the Locked Room after providing the correct Room Key
    And a Guest may not enter the Locked Room after providing the wrong Room Key

  # TODO: We should check with Colombene and Vivek re: "Is there `Invitation` feature?"
  @unstarted
  Scenario: Locking an Unlocked Room when Inviting People
    Given a Workspace with an Unlocked Room
    When a Workspace Member locks the Room with a Room Key while Inviting People
    Then the Room is Locked


  # Wireframe:
  # https://xd.adobe.com/view/fd425dbe-5384-44c9-997a-eeee6e886a86-a811/screen/847810bf-5d62-4131-a70d-d9efdfadb334
  @wip
  Scenario: Locking an Unlocked Room
    Given a Workspace with an Unlocked Room
    When a Workspace Member locks the Room with a Room Key
    Then the Room is Locked

  # This is a "sad path" scenario, that we expect to delete once we
  # have proven it out; since it's unlikely to be necessary to continuously check
  # at the user-level; when we can rely on ActiveRecord validations and consistent
  # usage of form builders that expose error information.
  @wip
  Scenario: Locking an Unlocked Room without setting a Room Key
    Given a Workspace with an Unlocked Room
    When a Workspace Member locks the Room without a Room Key
    Then the Workspace Member is informed they need to set a Room Key when they are locking a Room
    And the Room is Unlocked


  # Wireframe:
  # https://xd.adobe.com/view/fd425dbe-5384-44c9-997a-eeee6e886a86-a811/screen/847810bf-5d62-4131-a70d-d9efdfadb334
  @wip
  Scenario: Unlocking a Locked Room
  Given a Workspace with a Locked Room
  When a Workspace Member unlocks the Room with the correct Room Key
  Then the Room is Unlocked