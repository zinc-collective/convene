import { When, Then } from "@cucumber/cucumber";
import assert$0 from "assert";
import Invitation from "../lib/Invitation.js";
import Space from "../lib/Space.js";
import Actor from "../lib/Actor.js";
import {
  SignInPage,
  MembershipsIndexPage,
  InvitationsIndexPage,
} from "../harness/Pages.js";
import Component from "../harness/Component.js";
import {
  assertDisplayed,
  refuteDisplayed,
} from "../support/assertDisplayed.js";
const assert = assert$0.strict;

When("{a} {invitation} is Ignored", function (a, invitation) {
  return invitation.ignore(this.driver);
});

When(
  "an {invitation} to {a} {space} is sent by {actor}",
  { timeout: 90000 },
  function (invitation, _, space, actor, invitations) {
    /**
     * @todo This feels like responsibility for our Invitation class
     *       or the invitation parameter type?
     */
    const toSend = invitations.hashes().map((invitation) => {
      invitation.email = this.upsertTestId(invitation.email);
      return invitation;
    });

    return actor
      .signIn(this.driver, space)
      .then(() => new InvitationsIndexPage(this.driver, space))
      .then((page) => page.inviteAll(toSend));
  },
);
When(
  "{a} {invitation} for {a} {space} is accepted by {a} {actor}",
  /**
   * @param {Invitation} invitation
   * @param {Space} space
   * @param {Actor} actor
   */
  function (_a, invitation, _a2, space, _a3, actor) {
    return actor.isSignedIn(this.driver).then((signedIn) => {
      if (signedIn) {
        return invitation.accept(this.driver);
      } else {
        return actor
          .signOut(this.driver)
          .then(() => invitation.accept(this.driver))
          .then(() => actor.authenticationCode())
          .then((code) => new SignInPage(this.driver, space).submitCode(code))
          .catch((e) => console.error(e));
      }
    });
  },
);

Then(
  "no further Invitations can be sent to {string} for {a} {space}",
  function (string, a, space) {
    // Write code here that turns the phrase above into concrete actions
    return "pending";
  },
);

Then(
  "an {invitation} for {a} {space} is delivered",
  /**
   * @param {Invitation} invitation
   */
  async function (invitation, _a, space) {
    assert(await invitation.wasDelivered());
    assert(await invitation.rsvpLink());
  },
);
Then(
  "{a} {invitation} for {a} {space} has {a} status of {string}",
  /**
   * @param {Invitation} invitation
   */
  function (_a, invitation, _a2, space, _a3, status) {
    const page = new InvitationsIndexPage(this.driver, space);
    return page.visit().then(() => {
      return assertDisplayed(page.invitation({ invitation, status }));
    });
  },
);
Then(
  "{a} {actor} becomes {a} {actor} of {a} {space}",
  /**
   * @param {Actor} actor
   * @param {Space} space
   */
  function (_a, actor, _a2, _role, _a3, space) {
    return (
      actor
        .signIn(this.driver, space)
        // @todo Refactor to live in the harness
        .then(() =>
          assertDisplayed(
            new Component(this.driver, '*[aria-label="Configure Space"]'),
          ),
        )
    );
  },
);
Then(
  "{a} {actor} does not become {a} {actor} of {a} {space}",
  function (_a, actor, _a2, _role, _a3, space) {
    // Write code here that turns the phrase above into concrete actions
    return (
      actor
        .signIn(this.driver, space)
        // @todo Refactor to live in the harness
        .then(() =>
          refuteDisplayed(
            new Component(
              this.driver,
              'header a.--configure[aria_label="Configure Space"]',
            ),
          ),
        )
    );
  },
);
