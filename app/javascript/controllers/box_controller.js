import { Controller } from "@hotwired/stimulus"
import mapboxgl from "mapbox-gl"
const token = "pk.eyJ1Ijoiam9sYXp6IiwiYSI6ImNsMGdneTk4dTA5dHMzY3F0amMwZzZkNTcifQ.m4ON2zTQBuLgH4v2oiJSAw"

export default class extends Controller {
  static targets = ["mapContainer"];
  static values = {
    priceQuery: Number,
    address: String,
    distance: Number,
    gareMarker: Array,
    gareActive: Boolean
  };

  fetchGeoJson() {
    console.log(this.addressValue)
    fetch(
      `https://api.mapbox.com/geocoding/v5/mapbox.places/${this.addressValue}.json?access_token=${token}`
      )
      .then((response) => response.json())
      .then((data) => {
        const long = data.features[0].center[0];
        const lat = data.features[0].center[1];

        // creating the map in the dom
        mapboxgl.accessToken = token;
        this.map = new mapboxgl.Map({
          container: this.mapContainerTarget,
          style: "mapbox://styles/mapbox/streets-v10",
          zoom: 10,
          center: [long, lat], // center based on typed address
        });

        // adding the center on the map
        new mapboxgl.Marker().setLngLat([long, lat]).addTo(this.map);

        this.fetchPolygons(long, lat)
      });
    }


    fetchPolygons(long, lat) {
    // Fetch the coordonnes with the conditions and display them on the index
    fetch(
      `/results/geojson?price_query=${this.priceQueryValue}&address=${this.addressValue}&long=${long}&lat=${lat}&distance=${this.distanceValue}`
    )
      .then((response) => response.json())
      .then((data) => {
        this.geojson = data;
        this.addData();
      });
  }

  connect() {
    this.fetchGeoJson();
  }

  toggleGares() {
    this.gareActiveValue = !this.gareActiveValue
    if (this.gareActiveValue) {
      this.addGares()
    } else {
      this.currentMarkers.forEach(marker => {
        marker.remove()
      });
    }
  }

  addGares() {
    this.currentMarkers = []

    this.gareMarkerValue.forEach(gare => {
      let gareMarker = new mapboxgl.Marker()
      .setLngLat([ gare.lng, gare.lat ])
      .addTo(this.map)
      this.currentMarkers.push(gareMarker)
    });
  }

  addData() {
    this.map.on("load", () => {
      this.map.addSource("maine", {
        type: "geojson",
        data: this.geojson,
      });

      this.map.addLayer({
        id: "maine",
        type: "fill",
        source: "maine",
        layout: {},
        paint: {
          "fill-color": ["get", "color"],
          "fill-opacity": 0.8,
        },
      });

      this.map.addLayer({
        id: "outline",
        type: "line",
        source: "maine",
        layout: {},
        paint: {
          "line-color": "#000",
          "line-width": 0.5,
        },
      });

      const popup = new mapboxgl.Popup({
        closeButton: false,
        closeOnClick: false,
      });

      this.map.on("mousemove", "maine", (e) => {
        this.map.getCanvas().style.cursor = "pointer";

        const coordinates = e.features[0].geometry.coordinates;

        while (Math.abs(e.lngLat.lng - coordinates) > 180) {
          coordinates += e.lngLat.lng > coordinates ? 360 : -360;
        }

        popup
          .setLngLat(e.lngLat)
          .setHTML(e.features[0].properties.description)
          .addTo(this.map);
      });

      this.map.on("mouseleave", "maine", () => {
        this.map.getCanvas().style.cursor = "";
        popup.remove();
      });
    });
  }
}
