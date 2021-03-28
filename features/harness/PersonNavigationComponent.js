const Component = require("./Component");
class PersonNavigationComponent extends Component {
  /**
   * @returns {Promise<PersonNavigationComponent>}
   */
  signOut() {
    return this.expand()
      .then((c) => c.signOutLink().click())
      .then(() => this);
  }

  /**
   * @returns {Promise<PersonNavigationComponent>}
   */
  expand() {
    return this.links()
      .isDisplayed()
      .then((visible) => !visible && this.navigationToggleButton().click())
      .then(() => this);
  }

  /**
   * @returns {Promise<Component>}
   */
  links() {
    return this.component("nav");
  }

  /**
   * @returns {Promise<Component>}
   */
  navigationToggleButton() {
    return this.component(".navigation-toggle");
  }

  /**
   * @returns {Promise<Component>}
   */
  signOutLink() {
    return this.component(".logout");
  }
}

module.exports = PersonNavigationComponent;
