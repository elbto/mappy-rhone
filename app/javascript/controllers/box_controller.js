import { Controller } from "@hotwired/stimulus"
import mapboxgl from "mapbox-gl"
const token = "pk.eyJ1Ijoiam9sYXp6IiwiYSI6ImNrejhpZmQ5aDFqajUyd3J4OG15bnh6Y3AifQ.BF_g1YetHVCKTbtg3PUpyA"


export default class extends Controller {
  static targets = ['mapContainer']
  static values = {
    priceQuery: Number,
    address: String
  }

  addData() {
    this.map.on('load', () => {
      // Add a data source containing GeoJSON data.
      this.map.addSource('maine', {
        'type': 'geojson',
        'data': this.geojson
      });

      this.map.addLayer({
          'id': 'maine',
          'type': 'fill',
          'source': 'maine',
          'layout': {},
          'paint': {
              'fill-color': 'grey',
              'fill-opacity': 0.5
          }
      });
      // Add a black outline around the polygon.
      this.map.addLayer({
          'id': 'outline',
          'type': 'line',
          'source': 'maine',
          'layout': {},
          'paint': {
              'line-color': '#000',
              'line-width': 3
          }
      });
    });
  }

  fetchGeoJson() {
    fetch(`/results/geojson?price_query=${this.priceQueryValue}&address=${this.addressValue}`)
      .then(response => response.json())
      .then(data => {
        this.geojson = data
        this.addData()
      })
  }

  connect() {
    console.log(this.addressValue);
    mapboxgl.accessToken = token

    this.map = new mapboxgl.Map({
      container: this.mapContainerTarget,
      style: 'mapbox://styles/mapbox/light-v10',
      zoom: 9,
      center: [4.835659, 45.764043]
    })

    this.fetchGeoJson()
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
