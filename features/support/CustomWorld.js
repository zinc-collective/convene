import crypto from "crypto";
import { Api } from "../lib/Api.js";
import appUrl from "../lib/appUrl.js";
import { driver } from "./driver.js";
class CustomWorld {
    constructor() {
        this.driver = driver;
    }
    /**
     * @returns {Api}
     */
    api() {
        return this._api = this._api || new Api(appUrl(), process.env.OPERATOR_API_KEY);
    }
    /**
     * @returns {String}
     */
    testId() {
        return this._testId = this._testId || crypto.randomUUID();
    }
    /**
     * Ensures email addresses are all traceable back to the same test
     * This isolates our tests, eliminates race conditions, and makes things easier to diagnose
     * @param {string} email
     * @returns string
     */
    upsertTestId(email) {
        if (!email) {
            return email;
        }
        return email.replace("@", `-${this.testId()}@`);
    }
}
export { CustomWorld };
