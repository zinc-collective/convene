@unstarted
Feature: Spaces: Blueprints
  # See: https://github.com/zinc-collective/convene/issues/476
  #
  # Lay-out a Space with Rooms, Utilities, and Furniture based upon the Space's particular use case!

  # For example, let's pretend that a Book Club wants to use Convene to host their regular events, including managing
  # their member rolls, nominations for books to read, and the audio/video connection for their online events.
  #
  # They could create a Space from the "Book Club" Blueprint, which would come pre-configured with our recommendations
  # for how to run an effective book club.

  @unstarted @andromeda
  Scenario: Creating a Space from the Bookclub Blueprint
    When a "Ana and Zee's Nerdy Book Club" Space is created from the "Bookclub" Blueprint
    Then the "Ana and Zee's Nerdy Book Club" Space has the following Utilities:
      | utility    |
      # @todo define this as features/utilities/jitsi_saas.feature
      | jitsi_saas |
    Then a "Landing Page" Room is in the "Ana and Zee's Nerdy Book Club" Space with the following Furniture:
      | furniture      | preferences |
      # @todo define this as features/furniture/join_form.feature
      | join_form      |             |
      # @todo define this as features/furniture/gathering_post.feature
      | gathering_post |             |
    And the Entrance Hall for the "Ana and Zee's Nerdy Book Club" Space is the "Landing Page" Room
    And a "Members" Room is in the "Ana and Zee's Nerdy Book Club" Space with the following Furniture:
      | furniture      | preferences                                                                                 |
      | videobridge    |                                                                                             |
      | suggestion_box | { title: "What would you like us to read and discuss together?" }                           |
      | voting_booth   | { candidates: [{ name: "The Dispossesed", statement: "It's good! Anarchist mehtopia!!" }] } |
      | link_garden    | { links: [url: 'https://discord.gg/12345', title: "Join our Discord!"] }                    |