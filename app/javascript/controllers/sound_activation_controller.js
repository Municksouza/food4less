// app/javascript/controllers/sound_activation_controller.js
import { Controller } from "@hotwired/stimulus"
import { unlockAudioForAutoplay } from "./sound_controller.js"

export default class extends Controller {
  connect() {
    const storeId    = document.getElementById("store-dashboard")?.dataset.storeId || "default"
    const storageKey = `soundActivated_${storeId}`

    if (!sessionStorage.getItem("soundSessionInit")) {
      sessionStorage.setItem(storageKey, "false")
      sessionStorage.setItem("soundSessionInit", "true")
    }

    const activated = sessionStorage.getItem(storageKey) === "true"

    // Mostrar o banner **sempre**, até o usuário clicar
    this.element.style.display = "block"

    if (activated) {
      // Opcional: mude o texto para "Click to re-enable sound"
      this.element.querySelector("strong").textContent = "🔔 Click to re-enable sound alerts"
    }
  }

  activateSound() {
    const storeId    = document.getElementById("store-dashboard")?.dataset.storeId || "default"
    const storageKey = `soundActivated_${storeId}`

    sessionStorage.setItem(storageKey, "true")
    unlockAudioForAutoplay()
    this.element.remove()
  }
}