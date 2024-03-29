import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="schedules-show-view-geolocation"
export default class extends Controller {
  updateLocation() {
    // Obter dados de geolocalização
    navigator.geolocation.getCurrentPosition((position) => {
      const latitude = position.coords.latitude;
      const longitude = position.coords.longitude;

      // Extrair o ID da URL = SCHEDULE -> AMBULANCIA
    const url = window.location.href;
    const id = url.substring(url.lastIndexOf('/') + 1);

    // Enviar os dados para o servidor COM ID AMBULANCIA
    fetch(`/update_location_from_schedules_show_view/${id}`, {
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
    this.findEmergency();

    // Configura um intervalo para chamar a função updateLocation() a cada 10 segundos
    this.intervalId = setInterval(() => {
      this.updateLocation();
    }, 5000); // Intervalo de 5 segundos
  }

  disconnect() {
    // Limpa o intervalo quando o controlador é desconectado (por exemplo, quando a página é atualizada ou o controlador é removido)
    clearInterval(this.intervalId);
  }

  findEmergency() {
    navigator.geolocation.getCurrentPosition((position) => {
      const latitude = position.coords.latitude;
      const longitude = position.coords.longitude;
        // Extrair o ID da URL = SCHEDULE -> AMBULANCIA
        const url = window.location.href;
        const id = url.substring(url.lastIndexOf('/') + 1);
        setTimeout(() => {
          // Envie a localização do schedule para o servidor
          fetch('/find_emergency_after_login/', {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json',
              'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
            },
            body: JSON.stringify({ latitude: latitude, longitude: longitude, schedule_id: id }) // Envie a localização do schedule como JSON
          })
          .then(response => {
            if (response.ok) {
              console.log('Request successful');
              // Faça algo com a resposta, se necessário
            } else {
              throw new Error('Request failed');
            }
          })
          .catch(error => {
            console.error('Request failed:', error);
          });
        }, 5000); // 6000 milissegundos = 6 segundos
      })
    }
}
