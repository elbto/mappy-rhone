import { Controller } from "@hotwired/stimulus"
import mapboxgl from "mapbox-gl"

const token = "pk.eyJ1Ijoiam9sYXp6IiwiYSI6ImNrejhpZmQ5aDFqajUyd3J4OG15bnh6Y3AifQ.BF_g1YetHVCKTbtg3PUpyA"

export default class extends Controller {
  static values = {
    coordinates: Array,
    latitude: Number,
    longitude: Number
  }

  connect() {
    console.log(this.coordinatesValue)
    console.log(this)
    console.log(this.latitudeValue)
    console.log(this.longitudeValue)
    window.aaa = this
    mapboxgl.accessToken = token

    this.map = new mapboxgl.Map({
      container: 'map',
      style: 'mapbox://styles/mapbox/light-v10',
      zoom: 9,
      center: [4.835659, 45.764043]
    })

    new mapboxgl.Marker()
      .setLngLat([this.longitudeValue, this.latitudeValue])
      .addTo(this.map);
  }
}
