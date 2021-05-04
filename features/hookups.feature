Feature: Hookups
  In order to leverage the other services I already pay for
  I want to hook them up to my Space

  # Hookups are how we connect a Space to the broader Internet. Once a Space
  # has a Hookup, that Hookup can be used by Furniture or general Convene
  # features.
  # Examples:
  #  - A Stripe Hookup, so Furniture that focuses on accepting payments or
  #    managing billing or responding to payment events can take those actions
  #  - A Jitsi Meet Hookup, for Furniture that leverages JitsiMeet's APIs for
  #    real-time video
  #  - A Quickbooks Hookup, so Furniture that wants to interact with the
  #    Space Owners financials or send invoices can do that
  #  - An AirTable Hookup, for Furniture that wants to store data in AirTable


  # While Hookups can be added to a Space without constraint, they may have
  # different requirements before being usable; such as requiring a payment,
  # requiring the space owner to accept terms of service, authenticating with an
  # upstream service provider, having API keys or other data entered, etc.
  #
  # The particular requirements for each Hookup will be defined in that Hookups # feature file.
  @unstarted @andromeda
  Scenario: Adding a Hookup to a Space
    When a Space Owner adds a Hookup to their Space
    Then the Space Owner can configure that Hookup for their Space
    And that Hookup can not be used by Furniture in the Space

  # If a Hookup is not used by any Furniture, it can be safely removed from a
  # Space.
  @unstarted @andromeda
  Scenario: Removing an unused Hookup
    Given a Hookup in a Space without Furniture using it
    When the Space Owner removes that Hookup
    Then the Hookup can not be used by Furniture in the Space

  # A Hookup that is being used by Furniture probably needs a bit more thought
  # put into it for removal. So we're going to... not let people do that that
  # for Andromeda. Unless someone is eager to take it!
  #
  # See "Scenario: Removing an in-use Hookup" for future plans.
  @unstarted @andromeda
  Scenario: Cannot remove an in-use Hookup
    Given a Hookup in a Space without Furniture using it
    When the Space Owner removes that Hookup
    Then the Hookup can not be used by Furniture in the Space

  # Hookups
  @unstarted @andromeda
  Scenario: Configuring a Hookup
    Given a Hookup in a Space with missing configuration
    When the Space Owner configures the Hookup
    Then Furniture using that Hookup is enabled

  # Hookups themselves are defined as Ruby objects, so they're not really
  # "editable" at runtime, only build and deploy time.
  #
  # At some point, Operators may want to be able to mark particular Hookups as
  # unavailable or what not without doing a re-deploy; but let's hold off on
  # that for now.
  @unstarted @andromeda
  Scenario: Hookup Permissions
    Then Hookup models have the following permissions:
      | group        | permissions |
      | Operator     | show, list  |
      | Space Owner  | show, list  |
      | Space Member | show, list  |
      | Guest        | show, list  |

  # SpaceHookups are the model that connects a Space to a Hookup; and _are_
  # editable at runtime.
  @unstarted @andromeda
  Scenario: SpaceHookup Permissions
    Then SpaceHookup models have the following permissions:
      | group        | permissions                               |
      | Operator     | create, show, list, edit, update, destroy |
      | Space Owner  | create, show, list, edit, update, destroy |
      # I'm actually not sure we have to allow Guests or even Space Members to
      # know what Hookups are available for a Space...
      | Space Member | show, list                                |
      | Guest        | show, list                                |

  # A Hookup that is being used by Furniture probably needs a bit more thought
  # put into it for removal. As such, we're going to prevent that for Andromeda
  @unstarted  @milestone-b
  Scenario: Removing an in-use Hookup
    Given a Hookup in a Space without Furniture using it
    When the Space Owner removes that Hookup
    Then that Hookup can not be used by Furniture in the Space
    And the Furniture that was using that Hookup is disabled

  @unstarted @milestone-b
  Scenario: Noticing a Hookup with Missing Configuration
    Given a Space with a Hookup that has missing configuration
    When a Space Owner visits the Space
    Then the Space Owner is prompted to complete the Hookups Configuration