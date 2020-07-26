@wip
Feature: Locking Rooms
  In order to maintain control over who may participate in a conversation
  As a Workspace Member
  I would like to be able to lock Rooms


  Rooms have three different security levels:

  1. Unlocked, which grants access to anyone.
  2. Internal, which grants access to any Workspace Member.
  3. Locked, which grants access only to people who know the Room's Access Key.

  Design and discussion of the room access model may be found on GitHub at
  https://github.com/zinc-collective/convene/issues/12


  The following scenarios illustrate how these permissions play out
  based upon who is accessing rooms with which access level.

  Scenario: Workspace Admin who knows Room Key enters Locked Room
    Given a Workspace with a Locked Room
    When a Workspace Admin provides the correct Room Key
    Then the Workspace Admin is placed in the Room

  Scenario: Workspace Admin who does not know Room Key cannot enter Locked Room
    Given a Workspace with a Locked Room
    When a Workspace Admin provides the wrong Room Key
    Then the Workspace Admin is not placed in the Room

  Scenario: Workspace Member who knows the Room Key enters Locked Room
    Given a Workspace with a Locked Room
    When a Workspace Member provides the correct Room Key
    Then the Workspace Member is placed in the Room

  Scenario: Workspace Member who does not know the Room Key cannot enter Locked Room
    Given a Workspace with a Locked Room
    When a Workspace Member provides the wrong Room Key
    Then the Workspace Member is placed in the Room

  Scenario: Guest who knows Room Key enters Locked Room
    Given a Workspace with a Locked Room
    When a Guest provides the correct Room Key
    Then the Guest is placed in the Room

  Scenario: Guest who does not know Room Key cannot enter Locked Room
    Given a Workspace with a Locked Room
    When a Guest provides the wrong Room Key
    Then the Guest is not placed in the Room