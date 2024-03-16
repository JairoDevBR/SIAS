import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    apiKey: String,
  };

  connect() {
    mapboxgl.accessToken = this.apiKeyValue
    this.markers = []

    this.map = new mapboxgl.Map({
      container: this.element,
      style: "mapbox://styles/mapbox/streets-v9",
      center: [-46.68898, -23.55185 ],
      zoom: 12
    })

    this.#removeMarkers()
    this.#addMarkersToMap()
    this.#addRoutes()
    this.#fitMapToMarkers()

    // Atualizacao dos markers e rotas a cada 5 segundos
    setInterval(() => {
      this.#removeMarkers()
      this.#addMarkersToMap();
      this.#addRoutes();
    }, 5000);
  }

  // Adicao de novos markers
  #addMarkersToMap() {
    fetch('/emergencies_obtain_markers')
    .then(response => response.json())
    .then(data => {
      data.emergencies_markers.forEach(marker => {
        const popup = new mapboxgl.Popup().setHTML(marker.info_window_html);
        const customMarker = document.createElement("div");
        customMarker.innerHTML = marker.marker_html;
        customMarker.className = "marker-emergency";
        const emergencyMarkerInstance = new mapboxgl.Marker(customMarker)
          .setLngLat([marker.lng, marker.lat])
          .setPopup(popup)
          .addTo(this.map);
        this.markers.push(emergencyMarkerInstance);
      });
      data.schedules_markers.forEach(marker => {
        const popup = new mapboxgl.Popup().setHTML(marker.info_window_html);
        const customMarker = document.createElement("div");
        customMarker.innerHTML = marker.marker_html;
        customMarker.className = "marker-schedule";
        const scheduleMarkerInstance = new mapboxgl.Marker(customMarker)
          .setLngLat([marker.lng, marker.lat])
          .setPopup(popup)
          .addTo(this.map);
        this.markers.push(scheduleMarkerInstance);
      });
      data.hospitals_markers.forEach(marker => {
        const popup = new mapboxgl.Popup().setHTML(marker.info_window_html);
        const customMarker = document.createElement("div");
        customMarker.innerHTML = marker.marker_html;
        customMarker.className = "marker-hospital";
        const hospitalMarkerInstance = new mapboxgl.Marker(customMarker)
          .setLngLat([marker.lng, marker.lat])
          .setPopup(popup)
          .addTo(this.map);
        this.markers.push(hospitalMarkerInstance);
      });
    })
    .catch(error => {
      console.error('Erro ao obter marcadores de emergência:', error);
    });
  }

    // remocao dos markers
    #removeMarkers() {
      // this.markers.forEach(markerInstance => markerInstance.remove())
      this.markers.forEach(markerInstance => markerInstance.remove())
    };

  #addRoutes() {
    fetch('/emergencies/get_routes')
    .then(response => response.json())
    .then(data => {
      const routes = data.routes;

      // Limpe as camadas de rota existentes

      for (let i = 191; i < this.map.getStyle().layers.length; i++) {
        const layer = this.map.getStyle().layers[i];
        if (layer.id.startsWith("route-layer-")) {

          this.map.removeLayer(layer.id);
          this.map.removeSource(layer.id)
        }
      };

      // Iterar sobre cada rota e adicionar ao mapa
      routes.forEach((routeCoordinates, index) => {
          // Enviar solicitação para o Mapbox Directions API
          this.fetchDirections(routeCoordinates)
          .then(directions => {
            // Adicionar a rota ao mapa usando as coordenadas das curvas das ruas
            this.drawRoute(directions.routes[0].geometry, index);
          })
          .catch(error => {
            console.error('Erro ao obter direções:', error);
          });
      })

    })

 }

  fetchDirections(routeCoordinates) {
    const accessToken = this.apiKeyValue
    const baseUrl = 'https://api.mapbox.com/directions/v5/mapbox/driving';
    const query = `?access_token=${accessToken}&geometries=geojson&overview=full&steps=true`;
    const coordinates = `/${routeCoordinates[0][0]},${routeCoordinates[0][1]};${routeCoordinates[1][0]},${routeCoordinates[1][1]}`;

    return fetch(baseUrl + coordinates + query, {
    method: 'GET',
    headers: {
      'Content-Type': 'application/json'
    }
  })
  .then(response => response.json());
}

  drawRoute(geometry, index) {
  this.map.addLayer({
    'id': `route-layer-${index}`,
    'type': 'line',
    'source': {
      'type': 'geojson',
      'data': {
        'type': 'Feature',
        'properties': {},
        'geometry': geometry
      }
    },
    'layout': {
      'line-join': 'round',
      'line-cap': 'round'
    },
    'paint': {
      'line-color': '#888',
      'line-width': 8
    }
  });
}

  #fitMapToMarkers() {
    const bounds = new mapboxgl.LngLatBounds()
    fetch('/emergencies_obtain_markers')
    .then(response => response.json())
    .then(data => {
      data.emergencies_markers.forEach(marker => bounds.extend([ marker.lng, marker.lat ]))
      data.schedules_markers.forEach(marker => bounds.extend([ marker.lng, marker.lat ]))
      this.map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 0 })
    })
  }
}
