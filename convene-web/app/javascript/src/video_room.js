import { EventTarget } from 'event-target-shim';

const jitsiApiByDomain = {}
let wrapper = null;
const eventBus = new EventTarget()
export default class VideoRoom {
  constructor(domain, parentNode) {
    this.domain = domain;
    if (!wrapper) {
      wrapper = parentNode;
      wrapper.addEventListener('beforeunload', () => this.cleanup() )
    }
    this.connectJitsiApi();
  }

  enterRoom(roomName) {
    this.roomName = roomName;
    this.connectJitsiApi();
    const enteredRoomEvent = new CustomEvent("enteredRoom", { details: { roomName } });
    this.dispatchEvent(enteredRoomEvent);
  }

  exitRoom() {
    const exitedRoomEvent = new CustomEvent("exitedRoom");
    this.dispatchEvent(exitedRoomEvent);
  }

  cleanup() {
    this.jitsi.dispose();
  }

  set jitsi(api) {
    jitsiApiByDomain[this.domain] = api
  }

  get jitsi() {
    return jitsiApiByDomain[this.domain]
  }

  addEventListener(type, listener, option) {
    eventBus.addEventListener(type, listener, option);
  }

  dispatchEvent(event) {
    eventBus.dispatchEvent(event);
  }

  removeEventListener(type, listener, option) {
    eventBus.removeEventListener(type, listener, option);
  }

  connectJitsiApi() {
    if (!this.roomName) return;
    this.jitsi && this.jitsi.dispose();
    this.jitsi = new JitsiMeetExternalAPI(this.domain, this.jitsiApiOption());

    this.jitsi.on('videoConferenceLeft', () => this.exitRoom() )
  }

  jitsiApiOption() {
    return {
      roomName: this.roomName,
      parentNode: wrapper,
      interfaceConfigOverwrite: {
        TOOLBAR_BUTTONS: ['microphone', 'camera', 'desktop', 'tileview', 'hangup'],
        DISABLE_JOIN_LEAVE_NOTIFICATIONS: true,
        DISABLE_PRESENCE_STATUS: true,
        MOBILE_APP_PROMO: false,
        APP_NAME: 'Convene',
        DISABLE_RINGING: true,
        SETTINGS_SECTIONS: [],
      },
      configOverwrite: {
        disableDeepLinking: true,
      },
    };
  }
}
