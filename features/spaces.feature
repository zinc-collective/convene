Feature: Spaces
  In order to interact with the world digitally
  I want to Register a Space

  @unstarted
  Scenario: Registering a Space
    When a Space "New Space" is registered by Neighbor "new-space-owner@example.com" with the following attributes
      | payment details | valid credit card   |
      | name            | New Space {{ uid }} |
      | slug            | new-space-{{ uid }} |
    Then the Space "New Space" has a Space Owner "new-space-owner@example.com"
    And the Space "New Space" is visitable at the Slug "new-space-{{ uid }}"
    And the Space Owner "new-space-owner@example.com" receives a new Space Onboarding Email



  # Spaces can have an "Entrance" room that serves as the primary landing page
  # for that space.
  @built @unimplemented-steps
  Scenario: Space Entrances
    Given a Space with a Room specified as its Entrance
    When Anyone visits the Space
    Then they see the Furniture in the Entrance Room

  # When Spaces don't have an entrance, Visitors see the set of Rooms
  @built @unimplemented-steps
  Scenario: Space without Entrances
    Given a Space with no Entrance
    When Anyone visits the Space
    Then they only see the Rooms
