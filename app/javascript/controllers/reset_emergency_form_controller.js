import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="reset-emergency-form"
export default class extends Controller {

  resetForm(event) {
    event.preventDefault(); // Impede o comportamento padrão do formulário (recarregar a página)

    // Obtém o formulário a partir do evento
    const form = event.target;

    // Obtém todos os campos de entrada do formulário
    const inputs = form.querySelectorAll(".form-control");

    // Limpa os valores de todos os campos de entrada
    inputs.forEach(input => {
      input.value = '';
    });

    // Obtém todos os campos de entrada do formulário
    const inputMapbox = document.querySelector(".mapboxgl-ctrl-geocoder--input");

    // Limpa os valores de todos os campos de entrada
      inputMapbox.value = '';
  }
}
