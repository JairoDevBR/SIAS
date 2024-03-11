import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    apiKey: String}
  static targets = ["cidade", "bairro", "rua", "categoria", "latitude", "longitude", "button"]


  connect() {
    mapboxgl.accessToken = this.apiKeyValue
    const cidadeHidden = this.cidadeTarget
    const bairroHidden = this.bairroTarget
    const ruaHidden = this.ruaTarget
    const categoriaHidden = this.categoriaTarget
    const latitudeHidden = this.latitudeTarget
    const longitudeHidden = this.longitudeTarget

    this.map = new mapboxgl.Map({
      container: this.element,
      style: "mapbox://styles/mapbox/satellite-streets-v12",
      center: [-46.68898, -23.55185 ],
      zoom: 12
    })

    var geocoder = new MapboxGeocoder({
      accessToken: mapboxgl.accessToken,
      mapboxgl: mapboxgl});


    this.map.addControl(geocoder)

    const mapa = this.map

    geocoder.on('result', function (e) {
      // Access the result object which contains detailed information about the selected location
      let result = e.result;
      console.log(result);

      // Access neighborhood information if available
      const neighborhood = result.context[1].text;
      if (neighborhood) {
          console.log('Neighborhood:', neighborhood);
          bairroHidden.value = neighborhood
          document.getElementById("emergency_neighborhood").value = neighborhood;
      } else {
          console.log('Neighborhood information not available for this location.');
      }

      // Access city information if available
      const city = result.context[2].text;
      if (city) {
          console.log('City:', city);
          cidadeHidden.value = city
          document.getElementById("emergency_city").value = city;
      } else {
          console.log('City information not available for this location.');
      }

      // Access street information if available
      const street = result.place_name;
      if (street) {
          console.log('Street:', street);
          ruaHidden.value = street
          document.getElementById("emergency_street").value = street;
      } else {
          console.log('Street information not available for this location.');
      }

      // Access latitude information if available
      const lat = result.center[1];

      if (lat) {
          console.log('Latitude:', lat);
          latitudeHidden.value = lat
          document.getElementById("emergency_emergency_lat").value = lat;
      } else {
          console.log('Latitude information not available for this location.');
      }

      // Access longitude information if available
      const lon = result.center[0];

      if (lon) {
          console.log('Longitude:', lon);
          longitudeHidden.value = lon
          document.getElementById("emergency_emergency_lon").value = lon;
      } else {
          console.log('Longitude information not available for this location.');
      }

      // Access category information if available
      const category = result.properties.category;

      if (category) {
          console.log('Category:', category);
          categoriaHidden.value = category
          document.getElementById("emergency_local_type").value = category;
      } else {
          console.log('Category information not available for this location.');
          categoriaHidden.value = "Sem categoria";
          document.getElementById("emergency_local_type").value = "Sem categoria";
      }
    });
  }
}
