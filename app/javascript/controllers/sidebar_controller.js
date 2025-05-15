import { Controller } from "@hotwired/stimulus"
import * as bootstrap from "bootstrap"

export default class extends Controller {
  static targets = ["sidebar", "toggleButton", "toggleIcon"]

  connect() {
    this.initTooltips();
  }

  initTooltips() {
    const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
    this.tooltipInstances = tooltipTriggerList.map(function (tooltipTriggerEl) {
      return new bootstrap.Tooltip(tooltipTriggerEl)
    })
  }

  toggleSidebar(event) {
    event.preventDefault();
    const body = document.body;
    const expanded = body.classList.toggle('sidebar-expanded');
  
    if (expanded) {
      this.toggleIconTarget.classList.remove('fa-angle-right');
      this.toggleIconTarget.classList.add('fa-angle-left');
    } else {
      this.toggleIconTarget.classList.remove('fa-angle-left');
      this.toggleIconTarget.classList.add('fa-angle-right');
    }
  }
  
  handleLinkClick(event) {
    event.stopPropagation();
    const body = document.body;
    const url = event.currentTarget.getAttribute("data-url");
  
    // Se o sidebar NÃO está expandido, expande-o e impede o redirecionamento
    if (!body.classList.contains('sidebar-expanded')) {
      event.preventDefault();
      body.classList.add('sidebar-expanded');
      this.toggleIconTarget.classList.remove('fa-angle-right');
      this.toggleIconTarget.classList.add('fa-angle-left');
    } 
    // Se estiver expandido e houver uma URL, redireciona para ela
    else if (url) {
      // Impede a ação padrão e redireciona:
      event.preventDefault();
      window.location.href = url;
    }
  }
  
  // Adicionado método para toggle da área de busca
  toggleSearch(event) {
    event.stopPropagation();
    const searchWrapper = this.element.querySelector('.sidebar-search-wrapper');
    searchWrapper.classList.toggle('active');

    const input = searchWrapper.querySelector('.form-control');
    if (searchWrapper.classList.contains('active')) {
      input.style.display = 'block';
      input.focus();
    } else {
      input.style.display = 'none';
    }
  }
}