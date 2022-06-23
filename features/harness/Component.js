import { By, until } from "selenium-webdriver";
/**
 * Provides a test-harness for a particular part of the UI.
 */
class Component {
    /**
     * @param {ThenableWebDriver} driver
     * @param {string} selector
     */
    constructor(driver, selector) {
        this.driver = driver;
        this.selector = By.css(selector);
    }
    /**
     * @returns {Promise<this>}
     */
    click() {
        return this.el()
            .then((el) => el.click())
            .then(() => this);
    }
    /**
     * @param {string} value
     * @returns {Promise<this>}
     */
    fillIn(value) {
        return this.el()
            .then((el) => { el.clear(); return el; })
            .then((el) => el.sendKeys(value))
            .then(() => this);
    }
    /**
     *
     * @param {string} value
     * @returns {Promise<this>}
     */
    select(value) {
        return this.click()
            .then(() => this.component(`[value=${value}]`).click())
            .then(() => this);
    }
    /**
     * @returns {Promise<string>}
     */
    text() {
        return this.el().then((el) => el.getText());
    }
    /**
     * @returns {Promise<this>}
     */
    submit() {
        return this.el()
            .then((el) => el.submit())
            .then(() => this);
    }
    /**
     * @returns {Promise<Boolean>}
     */
    isDisplayed() {
        return this.el()
            .then((el) => el.isDisplayed())
            .catch(() => false);
    }
    /**
     * Factory for building child component(s)
     * @param {string} selector
     * @param {class} componentClass
     * @returns {Component}
     */
    component(selector, componentClass = Component) {
        return new componentClass(this.driver, `${this.selector.value} ${selector}`);
    }
    /**
     * Exposes an underlying Selenium::WebElement, try not to use this outside of
     * sub-classes!
     * @returns {Promise<WebElement>}
     */
    el() {
        return this.driver
            .wait(until.elementLocated(this.selector), 50)
            .then(() => this.driver.findElement(this.selector));
    }
}
export default Component;
