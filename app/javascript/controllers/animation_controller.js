import { Controller } from "stimulus";

export default class extends Controller {
  static targets = [ "animated" ]

  connect() {
    this.disparition()
  }

  disparition() {
    setTimeout(() => {
      (this.animatedTarget.classList.value = "center_hidden")
    }, 4400);
  }


}
