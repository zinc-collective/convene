const Component = require("./Component");
class PersonNavigationComponent extends Component {
  /**
   * @returns {Promise<PersonNavigationComponent>}
   */
  signOut() {
    return this.signOutLink().click().then(() => this )
  }

  /**
   * @returns {Promise<Component>}
   */
  signOutLink() {
    return this.component(".sign-out");
  }
}

module.exports = PersonNavigationComponent;
