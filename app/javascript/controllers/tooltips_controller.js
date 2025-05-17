// app/javascript/controllers/tooltips_controller.js
import { Controller } from "@hotwired/stimulus"
import { Tooltip } from "bootstrap"

export default class extends Controller {
  connect() {
    this.element
      .querySelectorAll('[data-bs-toggle="tooltip"]')
      .forEach(el => new Tooltip(el))
  }
}