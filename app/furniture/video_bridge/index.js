
import { Controller } from "@hotwired/stimulus"
import VideoBridge from "./video_bridge";
import { application } from "../../javascript/controllers/application"

class VideoBridgeController extends Controller {
  static targets = [ "wrapper" ]

  connect() {
    this.videoBridge = new VideoBridge(this.data.get('videoHost'), this.wrapperTarget);
    this.videoBridge.addEventListener('enteredRoom', () => {
      this.wrapperTarget.classList.add('--open');
    });
    this.videoBridge.addEventListener('exitedRoom', () => {
      this.wrapperTarget.classList.remove('--open');
    });

    this.videoBridge.enterRoom(this.data.get('name'));
  }

  disconnect() {
    this.videoBridge.exitRoom();
  }
}

application.register("video-bridge", VideoBridgeController)