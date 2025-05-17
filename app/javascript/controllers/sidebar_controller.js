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

    // If the sidebar is NOT expanded, expand it and prevent redirection
    if (!body.classList.contains('sidebar-expanded')) {
      event.preventDefault();
      body.classList.add('sidebar-expanded');
      this.toggleIconTarget.classList.remove('fa-angle-right');
      this.toggleIconTarget.classList.add('fa-angle-left');
    }
    // If it is expanded and there is a URL, redirect to it
    else if (url) {
      // Prevent default action and redirect:
      event.preventDefault();
      window.location.href = url;
    }
  }

  // Added method to toggle the search area
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