import { Controller } from "stimulus";

export default class extends Controller {
  static targets = [ "min", 'mid', 'max', 'range' ]

  updateRange() {
    const price = parseInt(this.rangeTarget.value)

    const min = (price * 0.088).toFixed() * 10
    const mid = (price * 0.098).toFixed() * 10
    const max = (price * 0.11).toFixed() * 10

    this.minTargets.forEach(element => element.innerText = min);
    this.midTargets.forEach(element => element.innerText = mid);
    this.maxTargets.forEach(element => element.innerText = max);
  }

  connect() {
    console.log('hello from legend');
    console.log(this.rangeTarget.value)
  }
}
