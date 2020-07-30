import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "roomName" ]

  enterRoom(event) {
    event.preventDefault();
    const domain = this.data.get('instanceDomain');
    const roomName = this.data.get('roomName');

    const connectVideoEvent = new CustomEvent('connectVideo', { detail: { domain, roomName } });
    document.dispatchEvent(connectVideoEvent);
  }
}
