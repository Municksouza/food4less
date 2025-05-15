// app/javascript/controllers/floating_emojis_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.animate()
  }

  animate() {
    const emojis = this.element.querySelectorAll(".emoji")
    emojis.forEach(emoji => {
      const duration = 3 + Math.random() * 3
      emoji.style.animationDuration = `${duration}s`
    })
  }
}