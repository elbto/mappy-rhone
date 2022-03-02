import { Controller } from "@hotwired/stimulus"
import mapboxgl from "mapbox-gl"

export default class extends Controller {

  connect() {
    console.log("je suis connecté")
    mapboxgl.accessToken = "pk.eyJ1Ijoiam9sYXp6IiwiYSI6ImNrejhpZmQ5aDFqajUyd3J4OG15bnh6Y3AifQ.BF_g1YetHVCKTbtg3PUpyA"

    this.map = new mapboxgl.Map({
      container: 'map',
      style: 'mapbox://styles/mapbox/light-v10',
      zoom: 8,
      center: [4.835659, 45.764043]
    })
  }
}
