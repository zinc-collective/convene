import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "roomName" ]

  enterRoom() {
    document.jitsiApi && document.jitsiApi.dispose();
    const domain = this.data.get('jitsiInstanceDomain');
    const roomName = this.data.get('roomName');

    const jitsiEvent = new CustomEvent("connectJitsi", { detail: { domain, roomName } });
    document.dispatchEvent(jitsiEvent);
  }
}
