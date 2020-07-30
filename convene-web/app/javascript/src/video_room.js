export default class VideoRoom {
  constructor(domain, roomName, parentNode) {
    this.domain = domain;
    this.roomName = roomName;
    this.parentNode = parentNode;
  }

  connectJitsiApi() {
    const parentNode = this.parentNode;
    parentNode.jitsiApi && parentNode.jitsiApi.dispose();

    parentNode.jitsiApi = new JitsiMeetExternalAPI(this.domain, this.jitsiApiOption());

    parentNode.addEventListener('beforeunload', function() {
      parentNode.jitsiApi.dispose();
    })

    parentNode.jitsiApi.on('videoConferenceLeft', function() {
      parentNode.jitsiApi.dispose();
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
