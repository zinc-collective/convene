Feature: Furniture - MediaBox (🌰)
  # - Find Media to Consume!
  # - Maintain a History of your media consumption!
  # - Share your Reccommendations and AntiRecommendations!
  # - Generate Revenue for the Neighborhood through Affiliate Programs!
  #
  # Each Space operates a MediaBox and own their Reviews of the Media; while the
  # Neighborhood holds the information about how to acquire the pieces of Media
  # in they're particular formats, and generates revenue by injecting affiliate
  # marketing links into the Reviews/Recommendation results.
  #
  # Assuming the Neighborhood is operated as a Contributor/Community
  # Co-operative; profits would flow back to Contributors as part of the regular
  # Patronage redemptions, and back to the Community as Patronage Refunds or
  # reduced prices.
  #
  # There are likely three main use cases:
  # - "Reviewing Media" for people who like to keep a record and share what
  #   they've read/listened to/watched
  # - "Finding Media" for people who are like "What do I wanna watch/read/listen
  #   to?"
  # - "Reading Media Reviews" for people who want a more in-depth way of
  #   evaluating potential media choices.
  # - "Acquiring Media" once people have made a "I want this!" decision.
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

  # This illustrates how revenue flows back into the organization operating the Convene instance.
  # @see features/vendor-affiliates.feature
  Scenario: Acquiring Media
    Given the Neighborhood has the following Affiliate Relationships:
      | vendor       |
      | bookshop.org |
    And the "Ancillary Justice" Media may be Acquired At:
      | format    | link                                                       |
      | paperback | https://bookshop.org/books/ancillary-justice/9780316246620 |
      | ebook     | https://www.kobo.com/us/en/ebook/ancillary-justice-1       |
    When Someone buys a copy of "Ancillary Justice" by following the "Bookshop.org" Get This Link
    Then the Neighborhood Operator is granted the affiliate fee


  @unstarted
  Scenario: Reviewing Media

  @unstarted
  Scenario: Reading Media Reviews



