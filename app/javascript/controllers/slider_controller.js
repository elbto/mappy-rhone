import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ["cursor", "range"];

  connect() {
    console.log("Hello");
  }

  slide() {
    this.rangeTarget.textContent = this.cursorTarget.value;
  }
}
