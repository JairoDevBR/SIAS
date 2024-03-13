import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    apiKey: String,
    emergenciesMarkers: Array,
    schedulesMarkers: Array,
  };

  connect() {
    mapboxgl.accessToken = this.apiKeyValue

    this.map = new mapboxgl.Map({
      container: this.element,
      style: "mapbox://styles/mapbox/streets-v9",
      center: [-46.68898, -23.55185 ],
      zoom: 12
    })

    this.#addMarkersToMap()
    this.#addScheduleMarkersToMap()
    this.#drawRoutes()
    this.#fitMapToMarkers()
  }

  #addMarkersToMap() {
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

  #addScheduleMarkersToMap() {
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

  #drawRoutes() {
    fetch('/emergencies/get_routes')
    .then(response => response.json())
    .then(data => {
      const routes = data.routes;
      // Iterar sobre cada rota e adicionar ao mapa
      routes.forEach((routeCoordinates, index) => {
        // Verificar se a camada já existe no mapa
        const layerId = `route-layer-${index}`;
        if (!this.map.getLayer(layerId)) {
          // Criar uma nova camada de rota no mapa
          this.map.addLayer({
            'id': layerId,
            'type': 'line',
            'source': {
              'type': 'geojson',
              'data': {
                'type': 'Feature',
                'properties': {},
                'geometry': {
                  'type': 'LineString',
                  'coordinates': routeCoordinates
                }
              }
            },
            'layout': {
              'line-join': 'round',
              'line-cap': 'round'
            },
            'paint': {
              'line-color': '#888',
              'line-width': 4
            }
          });
        }
      });
    })
    };



  #fitMapToMarkers() {
    const bounds = new mapboxgl.LngLatBounds()
    this.emergenciesMarkersValue.forEach(marker => bounds.extend([ marker.lng, marker.lat ]))
    this.schedulesMarkersValue.forEach(marker => bounds.extend([ marker.lng, marker.lat ]))
    this.map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 0 })
  }
}
