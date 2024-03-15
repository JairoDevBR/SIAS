import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    apiKey: String,
    markers: Array,
    schedulesMarkers: Array
  }


  connect() {
    mapboxgl.accessToken = this.apiKeyValue
    this.map = new mapboxgl.Map({
      container: this.element,
      style: "mapbox://styles/mapbox/streets-v9",
      center: [-46.68898, -23.55185 ],
      zoom: 12
    })

    this.#addMarkersToMap()
    this.#addAmbulance()
    this.#fitMapToMarkers()
  }

  #addMarkersToMap() {
    this.markersValue.forEach((marker) => {

      const popup = new mapboxgl.Popup().setHTML(marker.info_window_html)

      const customMarker = document.createElement("div")
      customMarker.innerHTML = marker.marker_html

      new mapboxgl.Marker(customMarker)
        .setLngLat([ marker.lng, marker.lat ])
        .setPopup(popup)
        .addTo(this.map)
    })
  }

  #addAmbulance(){
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

  #fitMapToMarkers() {
    const bounds = new mapboxgl.LngLatBounds()
    this.markersValue.forEach(marker => bounds.extend([ marker.lng, marker.lat ]))
    this.map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 0 })
  }
}
