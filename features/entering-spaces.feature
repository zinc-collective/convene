Feature: Entering Spaces
  In order to interact with other folks
  I want to be able to enter a Spaces

  @unimplemented-steps
  Scenario: Entering a Space via Branded Domain
    Given a Space with a Branded Domain
    When I visit the Branded Domain
    Then I am in the Space


  @unimplemented-steps
  Scenario: Entering a Space via Space Path
    Given a Space with a Slug
    When I visit "/spaces/:slug"
    Then I am in the Space
