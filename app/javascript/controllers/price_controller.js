import { Controller } from "stimulus";

export default class extends Controller {
  static targets = [ "metre", "budget", "price" ]

  connect() {
    console.log("Hello from Price");
  }

   calcul() {


    (this.priceTarget.value) = ((this.budgetTarget.value)/(this.metreTarget.value)).toFixed(2)
    console.log(this.priceTarget.value)
   }
}
