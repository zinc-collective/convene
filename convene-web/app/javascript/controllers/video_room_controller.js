import { Controller } from "stimulus"
import VideoRoom from "../src/video_room";

export default class extends Controller {
  static targets = [ "wrapper" ]

  connectVideoRoom(event) {
    const { domain, roomName } = event.detail;
    const videoRoomWrapper = this.wrapperTarget;
    videoRoomWrapper.classList.add('active-room');

    const videoRoom = new VideoRoom(domain, roomName, videoRoomWrapper);
    videoRoom.connectJitsiApi();
  }

  collapseVideoRoom() {
    this.wrapperTarget.classList.remove('active-room');
  }
}
