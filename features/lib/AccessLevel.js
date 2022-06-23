import { By } from "selenium-webdriver";
class AccessLevel {
    constructor(level) {
        this.level = level;
    }
    /**
     * @returns {By}
     */
    get locator() {
        return By.css(`*${this.attributeSelector}`);
    }
    /**
     *
     * @returns {string}
     */
    get attributeSelector() {
        return `[data-access-level="${this.level.toLowerCase()}"]`;
    }
    isLocked() {
        return this.level.toLowerCase() === "locked";
    }
}
export default AccessLevel;
