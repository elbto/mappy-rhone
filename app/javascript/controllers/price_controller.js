import { Controller } from "stimulus";

export default class extends Controller {
  static targets = [ "metre", "budget", "price" ]

  connect() {
  }

   calcul() {

    if (this.priceTarget.value === "NaN" || this.priceTarget.value === "Infinity" ){
      this.priceTarget.value = 0
    } else {
      (this.priceTarget.value) = ((this.budgetTarget.value)/(this.metreTarget.value)).toFixed(2)
    }

    const event = new Event('input');
    this.priceTarget.dispatchEvent(event);
  }
}
