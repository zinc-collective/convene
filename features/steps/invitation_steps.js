const { When, Then } = require("@cucumber/cucumber");
const assert = require("assert").strict;

const Invitation = require("../lib/Invitation");
const { SpaceEditPage } = require("../harness/Pages");

When(
  "an {invitation} to {a} {space} is sent by {actor}",
  { timeout: 90000 },
  function (invitation, _, space, actor, invitations) {
    return actor
      .signIn(this.driver, space)
      .then(() => new SpaceEditPage(this.driver, space))
      .then((page) => page.inviteAll(invitations.hashes()));
  }
);

Then(
  "an {invitation} is delivered",
  /**
   * @param {Invitation} invitation
   */
  async function (invitation) {
    assert(await invitation.wasDelivered());
  }
);

Then(
  "{a} {invitation} has an RSVP link",
  /**
   * @param {Invitation} invitation
   */
  async function (a, invitation) {
    assert(await invitation.rsvpLink());
  }
);
