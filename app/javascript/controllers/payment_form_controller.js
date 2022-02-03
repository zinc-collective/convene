import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [
    "payFrom",
    "publicToken",
    "plaidAccountId",
    "accountDescription",
    "dropOffButton",
  ];

  createLink(e) {
    e.preventDefault();
    const handler = Plaid.create({
      token: this.data.get("linkToken"),
      onSuccess: (publicToken, metadata) => {
        console.log({ publicToken, metadata });
        const accountDescription = `${metadata.institution.name} - ${metadata.account.name}: XXXX${metadata.account.mask}`;
        this.payFromTarget.innerHTML = accountDescription;
        this.dropOffButtonTarget.disabled = false;
        this.accountDescriptionTarget.value = accountDescription;
        this.publicTokenTarget.value = publicToken;
        this.plaidAccountIdTarget.value = metadata.account_id;
      },
      onLoad: () => {},
      onExit: (err, metadata) => {
        alert("womp womp");
      },
      onEvent: (eventName, metadata) => {},
      receivedRedirectUri: null,
    });
    handler.open();
  }
}
