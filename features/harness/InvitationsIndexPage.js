import { ThenableWebDriver } from "selenium-webdriver";
import Page from "./Page.js";
import Component from "./Component.js";

class InvitationsIndexPage extends Page {
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
    return `/spaces/${this.space.slug}/invitations`;
  }

  /**
   * @returns {Promise<this>}
   */
  invite({ name, email }) {
    return this.visit()
      .then(() => {
        return this.newInvitationForm()
          .component('input[name="invitation[name]"]')
          .fillIn(name);
      })
      .then(() => {
        return this.newInvitationForm()
          .component('input[name="invitation[email]"]')
          .fillIn(email);
      })
      .then(() => {
        return this.newInvitationForm()
          .component('input[type="submit"]')
          .click();
      })
      .finally(() => {
        return this;
      });
  }

  invitation({ invitation, status }) {
    return this.component(
      `*[data-invitation-status="${status}"][data-invitation-email="${invitation.emailAddress}"]`,
    );
  }

  /**
   * @returns {Promise<this>}
   */
  inviteAll(invitations) {
    return Promise.all(
      invitations.map((invitation) => this.invite(invitation)),
    ).finally(() => this);
  }

  /**
   * @returns {Component}
   */
  newInvitationForm() {
    return this.component(".new-invitation-form");
  }
}
export default InvitationsIndexPage;
