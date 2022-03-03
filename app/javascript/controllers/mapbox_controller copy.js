import { Controller } from "@hotwired/stimulus"
import mapboxgl from "mapbox-gl"

const token = "pk.eyJ1Ijoiam9sYXp6IiwiYSI6ImNrejhpZmQ5aDFqajUyd3J4OG15bnh6Y3AifQ.BF_g1YetHVCKTbtg3PUpyA"

export default class extends Controller {
  static values = {
    address: String
  }

  connect() {
    // console.log(this.addressValue)

    // mapboxgl.accessToken = token

    // this.map = new mapboxgl.Map({
    //   container: 'map',
    //   style: 'mapbox://styles/mapbox/light-v10',
    //   zoom: 9,
    //   center: [4.835659, 45.764043]
    // })

    fetch(`https://api.mapbox.com/geocoding/v5/mapbox.places/${this.addressValue}.json?access_token=${token}`)
      .then(response => response.json())
      .then((data) => {
        const long = data.features[0].center[0];
        const lat = data.features[0].center[1];
        console.log(long)
        console.log(lat)

        new mapboxgl.Marker()
          .setLngLat([long, lat])
          .addTo(this.map);
      });

  }
}
