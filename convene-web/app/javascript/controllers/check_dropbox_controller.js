import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["payFrom", "publicToken", "dropOffButton"];

  createLink(e) {
    e.preventDefault();
    const handler = Plaid.create({
      token: this.data.get('linkToken'),
      onSuccess: (publicToken, metadata) => {
        console.log({ publicToken, metadata })
        this.payFromTarget.innerHTML=`${metadata.institution.name} - ${metadata.account.name}: XXXX${metadata.account.mask}`
        this.dropOffButtonTarget.disabled = false;
        this.publicTokenTarget.value = publicToken
      },
      onLoad: () => {},
      onExit: (err, metadata) => {alert('womp womp')},
      onEvent: (eventName, metadata) => {},
      receivedRedirectUri: null,
    });
    handler.open();
  }
}
