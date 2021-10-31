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
  "an {invitation} for {a} {space} is delivered",
  /**
   * @param {Invitation} invitation
   */
  async function (invitation, _a, space) {
    assert(await invitation.wasDelivered());
    assert(await invitation.rsvpLink());
  }
);

Then(
  "{a} {invitation} for {a} {space} has {a} status of {string}",
  /**
   * @param {Invitation} invitation
   */
  async function (_a, invitation, _a2, space, _a3, status) {
    assert(await invitation.hasStatus({ status, space, driver: this.driver }));
  }
);
