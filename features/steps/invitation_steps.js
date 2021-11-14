const { When, Then } = require("@cucumber/cucumber");
const assert = require("assert").strict;

const Invitation = require("../lib/Invitation");
const Space = require("../lib/Space");
const Actor = require("../lib/Actor");
const { SpaceEditPage } = require("../harness/Pages");
const Component = require("../harness/Component");

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

When('{a} {invitation} for {a} {space} is accepted by {a} {actor}',
  /**
   * @param {Invitation} invitation
   * @param {Space} space
   * @param {Actor} actor
   */
  function (_, invitation, _2, space, _3, actor) {
    return invitation.rsvpLink()
      .then((rsvpLink) => this.driver.get(rsvpLink))
      .then(() => new Component(this.driver, 'input[type="submit"]').click())
});

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
    const page = new SpaceEditPage(this.driver, space);
    assert(await page.hasInvitation({ invitation, status }));
  }
);
