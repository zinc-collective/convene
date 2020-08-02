Feature: Entering Workspaces
  In order to interact with other folks
  I want to be able to enter a Workspaces

  @unimplemented-steps
  Scenario: Entering a Workspace via Branded Domain
    Given a Workspace with a Branded Domain
    When I visit the Branded Domain
    Then I am in the Workspace


  @unimplemented-steps
  Scenario: Entering a Workspace via Workspace Path
    Given a Workspace with a Slug
    When I visit "/workspaces/:slug"
    Then I am in the Workspace