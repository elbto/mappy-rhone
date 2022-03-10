import { Controller } from "stimulus";

export default class extends Controller {
  static targets = [ "animated" ]

  connect() {
    console.log('hello from animation');
    //setTimeout(this.disparition(),4000);
    this.disparition()
  }

  disparition() {
    setTimeout(() => {
      (this.animatedTarget.classList.value = "center_hidden")
    }, 4400);
  }


}
