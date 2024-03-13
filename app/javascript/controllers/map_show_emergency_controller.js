import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = {
    apiKey: String,
    lat: Number,
    long: Number,
    slon: Number,
    slat: Number
  };

  connect() {
    // console.log(this.slatValue);
    // console.log(this.slonValue);
    mapboxgl.accessToken = this.apiKeyValue;

    this.map = new mapboxgl.Map({
      container: this.element,
      style: "mapbox://styles/mapbox/streets-v9",
      center: [this.longValue, this.latValue],
      zoom: 14,
    });

    this.addMarker();
    this.addAmbulance();
    this.fitMapToMarkers();
  }

  addMarker() {
    // const popup = new mapboxgl.Popup().setHTML(marker.info_window_html)

    new mapboxgl.Marker()
      .setLngLat([this.longValue, this.latValue])
      // .setPopup(popup)
      .addTo(this.map);
  }

  addAmbulance(){
    new mapboxgl.Marker()


    .setLngLat([ this.slatValue, this.slonValue])
    .addTo(this.map);
  }

  fitMapToMarkers() {
    const bounds = new mapboxgl.LngLatBounds()
    bounds.extend([this.longValue, this.latValue ])
    bounds.extend([ this.slatValue, this.slonValue ])
    this.map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 0 })
  }
}
