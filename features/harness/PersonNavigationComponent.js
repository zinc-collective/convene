import Component from "./Component.js";
class PersonNavigationComponent extends Component {
    /**
     * @returns {Promise<PersonNavigationComponent>}
     */
    signOut() {
        return this.signOutLink().click().then(() => this);
    }
    signedInEmail() {
        return this.el().then((el) => el.getAttribute('data-person-email'));
    }
    /**
     * @returns {Promise<Component>}
     */
    signOutLink() {
        return this.component(".sign-out");
    }
}
export default PersonNavigationComponent;
