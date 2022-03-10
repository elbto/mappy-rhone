import { Controller } from "@hotwired/stimulus"
import mapboxgl from "mapbox-gl"
import debounce from 'lodash.debounce'

const token = "pk.eyJ1Ijoiam9sYXp6IiwiYSI6ImNsMGdneTk4dTA5dHMzY3F0amMwZzZkNTcifQ.m4ON2zTQBuLgH4v2oiJSAw"

export default class extends Controller {
  static targets = ["mapContainer", "priceInput", "distanceInput"];
  static values = {
    lat: Number,
    long: Number,
    gareMarker: Array,
    gareActive: Boolean
  };

  emptyGeojson = {
    "type": "FeatureCollection",
    "features": []
  }

  createMapAddSource() {
    this.map.addSource("maine", {
      type: "geojson",
      data: this.emptyGeojson
    });
  }

  createMapAddLayers() {
    this.map.addLayer({
      id: "maine",
      type: "fill",
      source: "maine",
      layout: {},
      paint: {
        "fill-color": ["get", "color"],
        "fill-opacity": 0.9,
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
  }

  createMapAddPopup() {
    this.popupArea = new mapboxgl.Popup({
      closeButton: false,
      closeOnClick: false,
    });

    this.map.on("mousemove", "maine", (e) => {
      this.map.getCanvas().style.cursor = "pointer";

      const coordinates = e.features[0].geometry.coordinates;

      while (Math.abs(e.lngLat.lng - coordinates) > 180) {
        coordinates += e.lngLat.lng > coordinates ? 360 : -360;
      }

      this.popupArea.setLngLat(e.lngLat)
        .setHTML(e.features[0].properties.description)
        .addTo(this.map);
    });

    this.map.on("mouseleave", "maine", () => {
      this.map.getCanvas().style.cursor = "";
      this.popupArea.remove();
    });
  }

  createMap() {
    mapboxgl.accessToken = token
    this.map = new mapboxgl.Map({
      container: this.mapContainerTarget,
      style: "mapbox://styles/mapbox/streets-v10",
      zoom: 10,
      maxZoom: 15,
      minZoom: 9,
      center: [this.longValue, this.latValue], // center based on typed address
    });

    this.map.on("load", () => {
      this.mapLoaded = true
      this.createMapAddSource()
      this.createMapAddLayers()
      this.createMapAddPopup()
      this.addData()
    })
  }

  addHomeMarker() {
    this.homeMarker = new mapboxgl.Marker({ "color": "#f95738" }).setLngLat([this.longValue, this.latValue]).addTo(this.map);
  }

  moveHomeMarker() {
    this.homeMarker.setLngLat([this.longValue, this.latValue])
    // this.map.setCenter([this.longValue, this.latValue])

    this.map.flyTo({
      center: [this.longValue, this.latValue],
      speed: 0.2
    })
  }

  removeData() {
    this.geojson = this.emptyGeojson;
    this.addData();
  }

  updateAddress(e) { // event from algolia
    this.longValue = e.detail.long
    this.latValue = e.detail.lat
    this.removeData()
    this.moveHomeMarker()
    this.fetchGeoJson()
  }

  fetchGeoJson() {
    // Fetch the coordonnes with the conditions and display them on the index
    fetch(
      `/results/geojson?price_query=${this.priceInputTarget.value}&long=${this.longValue}&lat=${this.latValue}&distance=${this.distanceInputTarget.value}`
    )
      .then((response) => response.json())
      .then((data) => {
        this.geojson = data;
        this.addData();
      });
  }

  initialize() {
    this.fetchGeoJson = debounce(this.fetchGeoJson, 400)
  }

  connect() {
    this.createMap()
    this.addHomeMarker()
    this.fetchGeoJson()
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

    const customMarker = document.createElement("div")
    customMarker.className = "marker"
    customMarker.style.backgroundImage = `url('${gare.image_url}')`
    customMarker.style.backgroundSize = "contain"
    customMarker.style.width = "20px"
    customMarker.style.height = "20px"

      let gareMarker = new mapboxgl.Marker(customMarker)
        .setLngLat([ gare.lng, gare.lat ])
        .addTo(this.map)
        this.currentMarkers.push(gareMarker)
    });
  }

  addData() {
    if (this.geojson && this.mapLoaded)
      this.map.getSource('maine').setData(this.geojson)
  }
}
