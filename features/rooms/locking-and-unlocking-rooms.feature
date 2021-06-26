Feature: Locked Rooms
  In order to maintain control over who may participate in a conversation
  As a Space Member
  I would like to be able to lock Rooms


  Rooms have three different security levels:

  1. Unlocked, which grants access to anyone.
  2. Internal, which grants access to any Space Member.
  3. Locked, which grants access only to people who know the Room's Key.

  Design and discussion of the room access model may be found on GitHub at
  https://github.com/zinc-collective/convene/issues/12


  The following scenarios illustrate how these permissions play out
  based upon who is accessing rooms with which access level.

  # Wireframe:
  # https://xd.adobe.com/view/fd425dbe-5384-44c9-997a-eeee6e886a86-a811/screen/04ee266e-931b-4bde-bcf9-af94c7ac444e
  @built
  Scenario: Entering a Locked Room
    Given a Space with a Locked Room
    Then a Space Member may enter the Locked Room after providing the correct Access Code
    And a Space Member may not enter the Locked Room after providing the wrong Access Code
    And a Guest may enter the Locked Room after providing the correct Access Code
    And a Guest may not enter the Locked Room after providing the wrong Access Code

  # Wireframe:
  # https://xd.adobe.com/view/fd425dbe-5384-44c9-997a-eeee6e886a86-a811/screen/847810bf-5d62-4131-a70d-d9efdfadb334
  @built
  Scenario: Locking an Unlocked Room
    Given a Space with an Unlocked Room
    When a Space Member locks the Unlocked Room with a valid Access Code
    Then the Room is Locked

  # This is a "sad path" scenario, that we expect to delete once we
  # have proven it out; since it's unlikely to be necessary to continuously check
  # at the user-level; when we can rely on ActiveRecord validations and consistent
  # usage of form builders that expose error information.
  @built
  Scenario: Locking an Unlocked Room without setting a Access Code
    Given a Space with an Unlocked Room
    When a Space Member locks the Unlocked Room with an empty Access Code
    Then the Space Member is informed they need to set a Access Code when they are locking a Room
    And the Room is Unlocked


  # Wireframe:
  # https://xd.adobe.com/view/fd425dbe-5384-44c9-997a-eeee6e886a86-a811/screen/847810bf-5d62-4131-a70d-d9efdfadb334
  @built
  Scenario: Unlocking a Locked Room
  Given a Space with a Locked Room
  When a Space Member unlocks the Locked Room with the correct Access Code
  Then the Room is Unlocked
