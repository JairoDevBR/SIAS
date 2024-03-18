import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="reset-emergency-form"
export default class extends Controller {
  connect() {
    // Adiciona um ouvinte de evento 'submit' no formulário
    this.element.addEventListener('submit', (event) => {
      // Chama o método para resetar o formulário antes do envio
      this.resetForm(event);
    });

  }


  resetForm(event) {
    // Obtém o formulário a partir do evento
    const form = event.target;

    // Executa a limpeza dos campos após um pequeno atraso para garantir que o formulário seja submetido primeiro
    setTimeout(() => {
      // Obtém todos os campos de entrada do formulário
      const inputs = form.querySelectorAll(".form-control");

      // Limpa os valores de todos os campos de entrada
      inputs.forEach(input => {
        input.value = '';
      });

    }, 500); // Ajuste o atraso conforme necessário
    window.scrollTo({ top: 0, behavior: 'smooth' });
  }
}
