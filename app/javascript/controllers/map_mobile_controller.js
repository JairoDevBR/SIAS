import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    apiKey: String,
    markers: Array,
    schedulesMarkers: Array
  }

  connect() {
    mapboxgl.accessToken = this.apiKeyValue
    this.markers = []

    this.map = new mapboxgl.Map({
      container: this.element,
      style: "mapbox://styles/mapbox/streets-v9",
      center: [-46.68898, -23.55185 ],
      zoom: 12
    })

    this.#addMarkersToMap()
    this.#fitMapToMarkers()
    // Atualizacao dos markers e rotas a cada 5 segundos
    setInterval(() => {
      this.#removeMarkers();
      this.#addMarkersToMap();
    }, 5000);
  }


 // Adicao de novos markers
 #addMarkersToMap() {
  // Isso vai pegar o último segmento da URL, que deve ser o schedule_id
  const url = window.location.href;
  const scheduleId = url.split('/').pop();

  fetch(`/schedules_obtain_markers/${scheduleId}`)
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
  })
  .catch(error => {
    console.error('Erro ao obter marcadores de emergência:', error);
  });
}

  // remocao dos markers
  #removeMarkers() {
    this.markers.forEach(markerInstance => markerInstance.remove())
  };

  #fitMapToMarkers() {
      // Isso vai pegar o último segmento da URL, que deve ser o schedule_id
    const url = window.location.href;
    const scheduleId = url.split('/').pop();
    const bounds = new mapboxgl.LngLatBounds()
    fetch(`/schedules_obtain_markers/${scheduleId}`)
    .then(response => response.json())
    .then(data => {
      data.schedules_markers.forEach(marker => bounds.extend([ marker.lng, marker.lat ]))
      this.map.fitBounds(bounds, { padding: 70, maxZoom: 13, duration: 0 })
    })
  }
}
