import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["payFrom", "dropOffButton"];

  createLink() {
    const handler = Plaid.create({
      token: this.data.get('linkToken'),
      onSuccess: (public_token, metadata) => {
        // TODO: Store the account metadata
        console.log({ public_token, metadata })

        this.payFromTarget.innerHTML=`${metadata.institution.name} - ${metadata.account.name}: XXXX${metadata.account.mask}`
        this.dropOffButtonTarget.disabled = false;
      },
      onLoad: () => {},
      onExit: (err, metadata) => {alert('womp womp')},
      onEvent: (eventName, metadata) => {},
      receivedRedirectUri: null,
    });
    handler.open();
  }
}
