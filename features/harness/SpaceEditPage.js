import { ThenableWebDriver } from "selenium-webdriver";
import Page from "./Page.js";
import Room from "../lib/Room.js";
import RoomCardComponent from "./RoomCardComponent.js";
import Component from "./Component.js";
class SpaceEditPage extends Page {
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
        return `/spaces/${this.space.slug}/edit`;
    }
    /**
     * @param {Room} room
     * @returns {RoomCardComponent}
     */
    roomCard(room) {
        return new RoomCardComponent(this.driver, room);
    }
    createRoom({ room }) {
        return new RoomFormComponent(this.driver)
            .fillIn(room)
            .then((c) => c.submit());
    }
    /**
     * @param {string} slug
     * @returns {Promise<this>}
     */
    addUtilityHookup(slug) {
        return this.newUtilityHookupSelect()
            .select(name)
            .then(() => this.newHookupForm().submit())
            .then(() => this);
    }
    /**
     * @returns {Component}
     */
    newUtilityHookupSelect() {
        return this.newUtilityHookupForm().component("select");
    }
    /**
     * @returns {Component}
     */
    newUtilityHookupForm() {
        return this.component(".new-hookup-form");
    }
    /**
     * @returns {Promise<this>}
     */
    invite({ name, email }) {
        return this.visit()
            .then(() => this.newInvitationForm()
            .component('input[name="invitation[name]"]')
            .fillIn(name))
            .then(() => this.newInvitationForm()
            .component('input[name="invitation[email]"]')
            .fillIn(email))
            .then(() => this.newInvitationForm().component('input[type="submit"]').click())
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
        return Promise.all(invitations.map((invitation) => this.invite(invitation))).finally(() => this);
    }
    /**
     * @returns {Component}
     */
    newInvitationForm() {
        return this.component(".new-invitation-form");
    }
}
export default SpaceEditPage;
