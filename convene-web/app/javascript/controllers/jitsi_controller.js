import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "wrapper" ]

  connectJitsiApi(event) {
    const { domain, roomName } = event.detail;
    document.jitsiApi && document.jitsiApi.dispose();

    document.jitsiApi = new JitsiMeetExternalAPI(domain, this.jitsiApiOption(roomName));
    const jitsiWrapper = this.wrapperTarget;
    jitsiWrapper.classList.add('h-screen');

    window.addEventListener('beforeunload', function() {
      document.jitsiApi.dispose();
    })

    document.jitsiApi.on('videoConferenceLeft', function() {
      document.jitsiApi.dispose();
      jitsiWrapper.classList.remove('h-screen');
    })
  }

  jitsiApiOption(roomName) {
    return {
      roomName: roomName,
      parentNode: this.wrapperTarget,
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
