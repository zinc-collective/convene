import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "roomName" ]

  enterRoom() {
    document.jitsiApi && document.jitsiApi.dispose();
    const domain = this.data.get('jitsiInstanceDomain');
    const roomName = this.data.get('roomName');

    const options = {
      roomName: roomName,
      parentNode: document.querySelector('#meet'),
      interfaceConfigOverwrite: {
        TOOLBAR_BUTTONS: ['microphone', 'camera', 'desktop', 'tileview'],
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

    document.jitsiApi = new JitsiMeetExternalAPI(domain, options);
    window.addEventListener('beforeunload', function() {
      document.jitsiApi.dispose();
    })

    document.jitsiApi.on('videoConferenceLeft', function() {
      document.jitsiApi.dispose();
    })
  }
}
