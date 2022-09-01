import { ThenableWebDriver } from "selenium-webdriver";
import Page from "./Page.js";
import Component from "./Component.js";
class SpaceMembershipsIndexPage extends Page {
  /**
   * @param {ThenableWebDriver} driver
   * @param {Space} space
   */
  constructor(driver, space) {
    super(driver);
    this.space = space;
  }
  /**
   * @returns {string}
   */
  path() {
    return `/spaces/${this.space.slug}/space_memberships`;
  }

  /**
   * @returns {Promise<this>}
   */
  invite({ name, email }) {
    return this.visit()
      .then(() =>
        this.newInvitationForm()
          .component('input[name="invitation[name]"]')
          .fillIn(name)
      )
      .then(() =>
        this.newInvitationForm()
          .component('input[name="invitation[email]"]')
          .fillIn(email)
      )
      .then(() =>
        this.newInvitationForm().component('input[type="submit"]').click()
      )
      .finally(() => this);
  }

  hasInvitation({ invitation, status }) {
    const matcher = new RegExp(`<${invitation.emailAddress}>.*${status}`);
    return this.visit().then((page) => page.hasContent(matcher));
  }

  /**
   * @returns {Promise<this>}
   */
  inviteAll(invitations) {
    return Promise.all(
      invitations.map((invitation) => this.invite(invitation))
    ).finally(() => this);
  }

  /**
   * @returns {Component}
   */
  newInvitationForm() {
    return this.component(".new-invitation-form");
  }
}
export default SpaceMembershipsIndexPage;
