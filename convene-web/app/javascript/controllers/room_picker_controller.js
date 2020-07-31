import { Controller } from "stimulus"
import VideoRoom from "../src/video_room";

export default class extends Controller {
  connect() {
    this.videoRoom = new VideoRoom(this.videoHost);
  }

  enterRoom(event) {
    event.preventDefault();
    this.videoRoom.enterRoom(this.roomName);
  }

  get videoHost() {
    return this.data.get('videoHost');
  }

  get roomName() {
    return this.data.get('roomName');
  }
}
