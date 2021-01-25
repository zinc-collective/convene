Feature: Demoing Convene
  In order to decide if Convene is a good fit
  I want a contetualized walk through of it's value proposition

  @unscheduled
  Scenario: Prospective Client Schedules a Demo

  @unimplemented-steps
  Scenario: Customer Team Member May Perform Demo
    Given a fresh Convene deployment
    When I visit the fresh Convene deployment
    Then there is a "Convene Demo" Space
    And the "Convene Demo" Space has a "Vivek's Desk" Room
    And the "Convene Demo" Space has a "Zee's Desk" Room
    And the "Convene Demo" Space has a "Water Cooler" Room
    And the "Convene Demo" Space has a "The Ada Lovelace Room" Room
    And the "Convene Demo" Space is available at the "convene-demo.zinc.coop" domain
