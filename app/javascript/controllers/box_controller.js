import { Controller } from "@hotwired/stimulus"
import mapboxgl from "mapbox-gl"
const token = "pk.eyJ1Ijoiam9sYXp6IiwiYSI6ImNrejhpZmQ5aDFqajUyd3J4OG15bnh6Y3AifQ.BF_g1YetHVCKTbtg3PUpyA"
export default class extends Controller {
  static targets = ['mapContainer']
  static values = {
    priceQuery: Number,
    address: String,
    distance: Number,
  }

  fetchGeoJson() {
    fetch(`https://api.mapbox.com/geocoding/v5/mapbox.places/${this.addressValue}.json?access_token=${token}`)
    .then(response => response.json())
    .then((data) => {
      const long = data.features[0].center[0];
      const lat = data.features[0].center[1];

      // creating the map in the dom
      mapboxgl.accessToken = token
      this.map = new mapboxgl.Map({
        container: this.mapContainerTarget,
        style: 'mapbox://styles/mapbox/light-v10',
        zoom: 11,
        center: [long, lat], // center based on typed address
      })

      // adding the markers on the map
      new mapboxgl.Marker()
        .setLngLat([long, lat])
        .addTo(this.map);

        // Fetch the coordonnes with the conditions and display them on the index
      fetch(`/results/geojson?price_query=${this.priceQueryValue}&address=${this.addressValue}&long=${long}&lat=${lat}&distance=${this.distanceValue}`)
        .then(response => response.json())
        .then(data => {
          console.log(data);
          this.geojson = data
          this.addData()
        })
    });
  }

  connect() {
    console.log(this.addressValue);
    this.fetchGeoJson()
  }

  addData() {
    console.log(this.geojson)
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
              'fill-color': ['get', 'color'],
              'fill-opacity': 0.8
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
              'line-width': 1
          }
      });

      this.map.on('click', 'maine', (e) => {
        console.log(e.features[0])
        new mapboxgl.Popup()
        .setLngLat(e.lngLat)
        .setHTML(e.features[0].properties.com_name, e.features[0].properties.price)
        .addTo(this.map);
      });

        this.map.on('mouseenter', 'maine', () => {
          this.map.getCanvas().style.cursor = 'pointer';
        });

        this.map.on('mouseleave', 'maine', () => {
          this.map.getCanvas().style.cursor = '';
        });
    });
  }
}
