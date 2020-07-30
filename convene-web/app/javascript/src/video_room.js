export default class VideoRoom {
  constructor(domain, roomName, parentNode) {
    this.domain = domain;
    this.roomName = roomName;
    this.parentNode = parentNode;
  }

  connectJitsiApi() {
    document.jitsiApi && document.jitsiApi.dispose();

    document.jitsiApi = new JitsiMeetExternalAPI(this.domain, this.jitsiApiOption());

    window.addEventListener('beforeunload', function() {
      document.jitsiApi.dispose();
    })

    document.jitsiApi.on('videoConferenceLeft', function() {
      document.jitsiApi.dispose();
      const closeVideoRoomEvent = new CustomEvent("closeVideoRoom");
      document.dispatchEvent(closeVideoRoomEvent);
    })
  }

  jitsiApiOption() {
    return {
      roomName: this.roomName,
      parentNode: this.parentNode,
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
