Feature: Utilities
# Utilities connect a Space to the broader Internet, and allow Furniture
# within the Space to leverage other Services or Websites. A Space connects
# to Utilities via a Utility Hookup; which can be used by Furniture or
# general Convene features.

# Examples:
#  - A Stripe Utility, so Furniture that focuses on accepting payments or
#    managing billing or responding to payment events can take those actions
#  - A Jitsi Meet Utility, for Furniture that leverages JitsiMeet's APIs for
#    real-time video
#  - A Quickbooks Utility, so Furniture that wants to interact with the
#    Space Owners financials or send invoices can do that
#  - An AirTable Utility, for Furniture that wants to store data in AirTable


# While Utility Hookups can be added to a Space without constraint, they may
# have different requirements before being usable; such as requiring a
# payment, requiring the Space Owner to accept terms of service,
# authenticating with an upstream service provider, having API keys or other
# data entered, etc.

# The particular requirements for each Utility will be defined in that
# Utilities feature file.

  @unstarted @andromeda
  Scenario: Adding a Utility Hookup to a Space
    When a Space Owner adds an unconfigured Utility Hookup to their Space
    Then the Space Owner can further configure that Utility Hookup
    And that Utility Hookup can not be used by Furniture in the Space

  @unstarted @andromeda
  Scenario: Configuring a Utility Hookup
    Given an unconfigured Utility Hookup for a Space
    When the Space Owner configures that Utility Hookup
    Then that Utility Hookup can be used by Furniture in the Space

  # If a Utility Hookup is not used by any Furniture, it can be safely removed
  # from a Space.
  @unstarted @andromeda
  Scenario: Removing an unused Utility Hookup
    Given an unused Utility Hookup
    When the Space Owner removes that Utility Hookup
    Then the Utility Hookup can not be used by Furniture in the Space

  # A Utility Hookup that is being used by Furniture probably needs a bit more
  # thought put into it for removal. So we're going to... not let people do
  # that for Andromeda. Unless someone is eager to take it!
  #
  # See "Scenario: Removing an in-use Utlity Hookup" for future plans.
  @unstarted @andromeda
  Scenario: In-use Utility Hookups may not be removed
    Given a Utility Hookup with Furniture using it
    Then a Space Owner may not remove that Utility Hookup

  # I'm hopeful we can figure out a tight way to use this for checking
  # permissions end-to-end.
  @unstarted @andromeda
  Scenario: Only Operators and Space Owners may modify Utility Hookups
    Then "UtilityHookup" resources have the following permissions:
      | group        | permissions                                    |
      | Operator     | new, create, show, list, edit, update, destroy |
      | Space Owner  | new, create, show, list, edit, update, destroy |
      | Space Member | show, list                                     |
      | Neighbor     | show, list                                     |
      | Guest        | show, list                                     |


  @unstarted  @milestone-b
  Scenario: Removing an in-use Utility Hookup
    Given an in-use Utility Hookup
    When the Space Owner removes that Utility Hookup
    Then that Utility Hookup can not be used by Furniture in the Space
    And the Furniture that was using that Utility Hookup is disabled

  @unstarted @milestone-b
  Scenario: Noticing a Utility Hookup with Missing Configuration
    Given a Space with a Utility Hookup that has missing configuration
    When a Space Owner visits the Space
    Then the Space Owner is prompted to complete the Utility Hookup's Configuration