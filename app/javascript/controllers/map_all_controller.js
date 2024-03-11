import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    apiKey: String,
    emergenciesMarkers: Array,
    schedulesMarkers: Array
  }

  connect() {
    // console.log(this.markersValue);
    mapboxgl.accessToken = this.apiKeyValue

    this.map = new mapboxgl.Map({
      container: this.element,
      style: "mapbox://styles/mapbox/streets-v9",
      center: [-46.68898, -23.55185 ],
      zoom: 12
    })

    this.#addMarkersToMap()
    this.#addScheduleMarkersToMap()
    this.#fitMapToMarkers()
  }

  #addMarkersToMap() {
    this.emergenciesMarkersValue.forEach((marker) => {

      const customMarker = document.createElement("div")
      customMarker.innerHTML = marker.marker_html

      new mapboxgl.Marker(customMarker)
        .setLngLat([ marker.lng, marker.lat ])
        .addTo(this.map)
    })
  }

  #addScheduleMarkersToMap() {
    this.schedulesMarkersValue.forEach((marker) => {

      const customMarker = document.createElement("div")
      customMarker.innerHTML = marker.marker_html

      new mapboxgl.Marker(customMarker)
        .setLngLat([ marker.lng, marker.lat ])
        .addTo(this.map)
    })
  }

  #fitMapToMarkers() {
    const bounds = new mapboxgl.LngLatBounds()
    this.emergenciesMarkersValue.forEach(marker => bounds.extend([ marker.lng, marker.lat ]))
    this.schedulesMarkersValue.forEach(marker => bounds.extend([ marker.lng, marker.lat ]))
    this.map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 0 })
  }
}
