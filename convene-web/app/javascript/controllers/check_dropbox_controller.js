import { Controller } from "stimulus"

export default class extends Controller {
  createLink() {
    const handler = Plaid.create({
      token: this.data.get('linkToken'),
      onSuccess: (public_token, metadata) => {
        // TODO: Store the account metadata
        alert(`success! token: ${public_token} \n metadata: ${JSON.stringify(metadata)} `)
      },
      onLoad: () => {},
      onExit: (err, metadata) => {alert('womp womp')},
      onEvent: (eventName, metadata) => {},
      receivedRedirectUri: null,
    });
    handler.open();
  }
}
