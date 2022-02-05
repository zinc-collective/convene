Feature: Furniture - MediaBox (🌰)
  # - Find Media to Consume!
  # - Maintain a History of your media consumption!
  # - Share your Reccommendations and AntiRecommendations!
  # - Generate Revenue for the Neighborhood through Affiliate Programs!
  #
  # Data Prototype: https://airtable.com/shrUIIkF5Gnm6R5ff
  #


  Background:
    Given a Space with the "MediaBox Demo" Room
    And the "MediaBox" Furniture is in the "MediaBox Demo" Room
    And the Neighborhood's MediaBoxes have the following Reviews:
      | media                     | recommendation | format    | themes                                                                            | content warnings                                |
      | A Song for the Wild Built | yes            | audiobook | fiction,speculative fiction,solarpunk, artificial sentience, tea                  |                                                 |
      | Ancillary Justice         | yes            | ebook     | fiction,speculative fiction,tea,chosen family,genderfuckery, artificial sentience | military violence, violence                     |
      | An Unkindness of Ghosts   | yes            | ebook     | gritty, fiction,speculative fiction,genderfuckery,personal liberation             | familial trauma, sexual violence, racial trauma |


  # A MediaBox may provide Recommendations based upon the Users in-the-moment curiosity, prior consumption, and
  # future intentions. The basic interaction flow uses a search box which can be expanded into weighted tag filter
  # groups for format, thematic content, content warnings, or creator identity.
  #
  # A MediaBox's Recommendation Engine may be tuned by a Resident, giving Neighbors and Visitors further curated
  # results.
  #
  # Note: There is clearly a fractal of interesting nuance to explore here; which may be best defined in
  # `features/furniture/mediabox/search.feature`
  @unstarted
  Scenario: Finding Media
    When the MediaBox is asked for Recommendations with the following Filters:
      | query              | *                                              |
      | formats[]          | audiobook,ebook                                |
      | themes[]           | gritty--,liberation+,fiction                   |
      | identities[]       | white--,masculine-,cooperative+,human+,b corp+ |
      | content warnings[] | !sexual violence                               |
    Then the Recommendations are:
      | media                     |
      | Ancillary Justice         |
      | A Song for the Wild Built |


  @unstarted
  Scenario: Reviewing Media

  @unstarted
  Scenario: Reading Media Reviews



