import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="geolocation"
export default class extends Controller {
  updateLocation() {
    // Obter dados de geolocalização
    navigator.geolocation.getCurrentPosition((position) => {
      const latitude = position.coords.latitude;
      const longitude = position.coords.longitude;
      console.log(position);

      // Extrair o ID da URL
    const url = window.location.href;
    const id = url.substring(url.lastIndexOf('/') + 1);

    // Enviar os dados para o servidor
    fetch(`/update_schedule_location/${id}`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
      },
      body: JSON.stringify({ latitude: latitude, longitude: longitude })
    })
    .then(response => {
      if (!response.ok) {
        throw new Error('Erro ao atualizar localização');
      }
      return response.json();
    })
    .then(data => {
      console.log('Localização atualizada com sucesso:', data);
    })
    .catch(error => {
      console.error('Erro:', error);
    });
  })
  }

  initialize() {
    // Chamada inicial para iniciar a atualização da localização
    this.updateLocation();

    // Configura um intervalo para chamar a função updateLocation() a cada 10 segundos
    this.intervalId = setInterval(() => {
      this.updateLocation();
    }, 10000); // Intervalo de 10 segundos
  }

  disconnect() {
    // Limpa o intervalo quando o controlador é desconectado (por exemplo, quando a página é atualizada ou o controlador é removido)
    clearInterval(this.intervalId);
  }
}
