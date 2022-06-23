const { When, Then } = require("@cucumber/cucumber");
const assert = require("assert").strict;

const Invitation = require("../lib/Invitation");
const Space = require("../lib/Space");
const Actor = require("../lib/Actor");
const { SpaceEditPage, SignInPage } = require("../harness/Pages");
const Component = require("../harness/Component");

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
      .then(() => new SpaceEditPage(this.driver, space))
      .then((page) => page.inviteAll(toSend));
  }
);

When(
  "{a} {invitation} for {a} {space} is accepted by {a} {actor}",
  /**
   * @param {Invitation} invitation
   * @param {Space} space
   * @param {Actor} actor
   */
  function (_, invitation, _2, space, _3, actor) {
    return actor.signOut(this.driver)
      .then(() => invitation.accept(this.driver))
      .then(() => actor.authenticationCode())
      .then((code) => new SignInPage(this.driver, space).submitCode(code))
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
    const page = new SpaceEditPage(this.driver, space);
    assert(await page.hasInvitation({ invitation, status }));
  }
);

Then(
  "{a} {actor} becomes {a} {actor} of {a} {space}",
  /**
   * @param {Actor} actor
   * @param {Actor} role
   * @param {Space} space
   */
  function (_, actor, _2, role, _3, space) {
    return (
      actor
        .signIn(this.driver, space)
        // @todo Refactor to live in the harness
        .then(() =>
          new Component(
            this.driver,
            '*[aria-label="Configure Space"]'
          ).isDisplayed()
        )
        .then((displayed) => assert(displayed))
    );
  }
);

Then(
  "all other Invitations to {actor} for {a} {space} no longer have {a} status of {string}",
  /**
   * @param {Actor} actor
   * @param {Space} space
   * @param {string} status
   */
  function (actor, _a, space, _a2, status) {
    return actor
      .signIn(this.driver, space)
      .then(() => new SpaceEditPage(this.driver, space).visit())
      .then((page) => page.invitations({ to: actor }))
      .then((invitations) =>
        assert(invitations.every((i) => i.status !== status))
      );
  }
);
