Feature: Identification
  In order to assert myself within a Space
  I want to Identify who I am.

  # ## Technical Details
  #
  # Identification is the process of _asserting_, _verifying_ and _acting with_
  # an Identity.
  #
  # Someones Identity is either:
  #
  # 1. Unverified (I.e. we have not proven the Identity they claim is theirs,
  #    for example someone asserts they are named _Zee Spencer_.)
  # 2. Verified (I.e. we have proven the Identity they claim is theirs, for
  #    example they assert that zee@example.com is their email, and prove it
  #    by clicking a link or providing a secret sent to that email.)
  #
  #  Note: Techniques for Verifying Identities are called _Factors_.
  #
  # Someone who Verifies their Identity in a Session is _Authenticated_.
  # Identification is orthogonal to _Authorization_, the rules that determine
  # what somoene may or may not see or do within Convene or a Space.
  #
  # To Recap:
  #
  # 1. People have an _Identity_, which is a way of asserting who they are.
  # 2. Some Identities can be Verified, which helps confirm a person is who they
  #    say they are.
  # 3. Once we have Verified someone's Identity they are Authenticated for the
  #    duration of that Session.
  # 4. Deciding what someone may or may not do is Authorization.
  #
  # [Identity]: https://en.wikipedia.org/wiki/Identity_(philosophy)
  # [Authentication]: https://en.wikipedia.org/wiki/Authentication
  # [Verification Factors]: https://en.wikipedia.org/wiki/Multi-factor_authentication#Factors
  # [Authorization]: https://en.wikipedia.org/wiki/Authorization
  # [Session]: https://en.wikipedia.org/wiki/Session_(computer_science)
  # [Identification, Authentication and Authorization]: https://usa.kaspersky.com/blog/identification-authentication-authorization-difference/23338/

  # Wireframe: https://xd.adobe.com/view/fd425dbe-5384-44c9-997a-eeee6e886a86-a811/
  # An Emailed Link is a _Possession_ Verification Factor that demonstrates the
  # person can at least _read_ the email address they are using to identiy
  # themselves.
  @built
  Scenario: Identity Verification Via Emailed Link
    Given a Guest has Identified themselves using an Email Address
    When the Guest opens the Identification Verification Link emailed to them
    Then the Guest is Verified as the Owner of that Email Address
    And the Guest has become Authenticated


  @built
  Scenario: Authentication is lost on Sign-out
    Given an Authenticated Session
    When the Authenticated Person Signs Out
    Then the Authenticated Person becomes a Guest

  # We're not quite sure how to do time-travel in our test suite just yet.
  @built @unimplemented-steps
  Scenario: Requests for Identification Verification via Email Times Out
    Given a Guest requests to Identify themselves via Email
    When the Guest waits for an hour
    Then the Guest can not Identify themselves by following the link sent to their Email
  # @unstarted
  # And the Guest can not Identify themselves by entering the code sent to their Email

  @built @unimplemented-steps
  Scenario: Authentication times out
    Given an Authenticated Person who has not signed in for 7 days
    When the Authenticated Person visits Convene
    Then the Authenticated Person is treated as a Guest

  @unimplemented-steps
  Scenario: Authentication times out due to inactivity
    Given an Authenticated Person who has been Inactive for 7 days
    When the Authenticated Person visits Convene
    Then the Authenticated Person is treated as a Guest

  # An Emailed Code is a _Possession_ Verification Factor that demonstrates the
  # person can at least _read_ the email address they are using to identiy
  # themselves.
  @unstarted
  Scenario: Identity Verification via Emailed Code
    Given a Guest has requested to Identify themselves via Email
    When the Guest provides the Identification Code emailed to them
    Then the Guest is Identified as themselves

  @unstarted
  Scenario: People with Multiple Email Addresses
    Given an Identified User adds an additional Email Address
    When the Identified User verifies that Email Address
    Then the Identified User may Identify themselves using that Email Address
