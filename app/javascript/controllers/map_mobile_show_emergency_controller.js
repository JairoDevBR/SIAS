import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = {
    apiKey: String,
    lat: Number,
    long: Number,
    slon: Number,
    slat: Number,
    emergenciesMarkers: Array,
    schedulesMarkers: Array,
    emergencyMarker: Array
  };

  connect() {
    mapboxgl.accessToken = this.apiKeyValue;

    this.map = new mapboxgl.Map({
      container: this.element,
      style: "mapbox://styles/mapbox/streets-v9",
      center: [this.longValue, this.latValue],
      zoom: 14,
    });

    this.addMarker();
    this.addAmbulance();
    this.addEmergency();
    this.fitMapToMarkers();
  }

  addMarker() {
    this.emergenciesMarkersValue.forEach((marker) => {

      const popup = new mapboxgl.Popup().setHTML(marker.info_window_html)

      const customMarker = document.createElement("div")
      customMarker.innerHTML = marker.marker_html

      new mapboxgl.Marker(customMarker)
        .setLngLat([ marker.lng, marker.lat ])
        .setPopup(popup)
        .addTo(this.map)
    })
  }

  addAmbulance() {
    this.schedulesMarkersValue.forEach((marker) => {

      const popup = new mapboxgl.Popup().setHTML(marker.info_window_html)

      const customMarker = document.createElement("div")
      customMarker.innerHTML = marker.marker_html

      new mapboxgl.Marker(customMarker)
        .setLngLat([ marker.lng, marker.lat ])
        .setPopup(popup)
        .addTo(this.map)
    })
  }

  addEmergency() {
    this.emergencyMarkerValue.forEach((marker) => {

      const popup = new mapboxgl.Popup().setHTML(marker.info_window_html)

      const customMarker = document.createElement("div")
      customMarker.innerHTML = marker.marker_html

      new mapboxgl.Marker(customMarker)
        .setLngLat([ marker.lng, marker.lat ])
        .setPopup(popup)
        .addTo(this.map)
    })
  }

  fitMapToMarkers() {
    const bounds = new mapboxgl.LngLatBounds()
    bounds.extend([this.longValue, this.latValue ])
    bounds.extend([ this.slatValue, this.slonValue ])
    this.map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 0 })
  }
}
