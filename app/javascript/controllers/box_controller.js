<<<<<<< HEAD
import { Controller } from "@hotwired/stimulus"
import mapboxgl from "mapbox-gl"
const token = "pk.eyJ1Ijoiam9sYXp6IiwiYSI6ImNsMGdneTk4dTA5dHMzY3F0amMwZzZkNTcifQ.m4ON2zTQBuLgH4v2oiJSAw"
=======

import { Controller } from "@hotwired/stimulus";
import mapboxgl from "mapbox-gl";
const token =
  "pk.eyJ1Ijoiam9sYXp6IiwiYSI6ImNsMGdneTk4dTA5dHMzY3F0amMwZzZkNTcifQ.m4ON2zTQBuLgH4v2oiJSAw";


>>>>>>> 157a92784835c2b5f75ff495d03743d827d70cf9
export default class extends Controller {
  static targets = ["mapContainer"];
  static values = {
    priceQuery: Number,
    address: String,
    distance: Number,
  };

  fetchGeoJson() {
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
          style: "mapbox://styles/mapbox/light-v10",
          zoom: 10,
          center: [long, lat], // center based on typed address
        });

        // adding the markers on the map
        new mapboxgl.Marker().setLngLat([long, lat]).addTo(this.map);

        // Fetch the coordonnes with the conditions and display them on the index
        fetch(
          `/results/geojson?price_query=${this.priceQueryValue}&address=${this.addressValue}&long=${long}&lat=${lat}&distance=${this.distanceValue}`
        )
          .then((response) => response.json())
          .then((data) => {
            console.log(data);
            this.geojson = data;
            this.addData();
          });
      });
  }

  connect() {
    // console.log(this.addressValue);
    this.fetchGeoJson();
  }

  addData() {
    // console.log(this.geojson)
    this.map.on("load", () => {
      // Add a data source containing GeoJSON data.
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
      // Add a black outline around the polygon.
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
