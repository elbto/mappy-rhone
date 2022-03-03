import { Controller } from "@hotwired/stimulus"
import MapboxGeocoder from "@mapbox/mapbox-gl-geocoder"

const token = "pk.eyJ1Ijoiam9sYXp6IiwiYSI6ImNrejhpZmQ5aDFqajUyd3J4OG15bnh6Y3AifQ.BF_g1YetHVCKTbtg3PUpyA"

export default class extends Controller {
  static targets = ["input"]

  connect() {
    this.geocoder = new MapboxGeocoder({
      accessToken: token,
      types: "country,region,place,postcode,locality,neighborhood,address"
    });
  }
}
