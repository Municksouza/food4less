import { Controller } from "@hotwired/stimulus"
import * as bootstrap from "bootstrap"

function formatTime(seconds) {
  const mins = Math.floor(seconds / 60).toString().padStart(2, '0')
  const secs = (seconds % 60).toString().padStart(2, '0')
  return `${mins}:${secs}`
}

export default class extends Controller {
  static values = {
    endTime: String,
    playSound: Boolean,
    alertSound: String,
    orderId: Number,
    orderStatus: String
  }

  connect() {
    console.log(`Countdown connected for order ${this.orderIdValue}`);
    console.log("Countdown data attributes:", {
      endTimeValue: this.endTimeValue,
      playSoundValue: this.playSoundValue,
      orderStatusValue: this.orderStatusValue
    });

    if (!["accepted", "pending"].includes(this.orderStatusValue)) {
      console.log(`Countdown inactive: status is "${this.orderStatusValue}"`);
      return;
    }

    this.alertSound = new Audio(this.alertSoundValue);
    this.alertSound.loop = true;

    // For testing, use current time plus 5 minutes if endTime invalid
    if (!this.hasEndTimeValue || isNaN(Date.parse(this.endTimeValue))) {
      console.warn("Invalid end time, forcing 5 minutes from now.");
      this.endTime = new Date(Date.now() + 5 * 60 * 1000);
    } else {
      this.endTime = new Date(this.endTimeValue);
    }
    console.log("Parsed endTime:", this.endTime, "Current time:", new Date());

    if (this.playSoundValue) {
      this.alertSound.play().catch(err => {
        console.warn("Autoplay blocked:", err.message);
      });
    }

    // Use placeholder countdown element; create one if missing.
    this.countdownEl = this.element.querySelector('.countdown');
    if (!this.countdownEl) {
      this.countdownEl = document.createElement('span');
      this.countdownEl.classList.add('countdown');
      this.element.insertAdjacentElement('afterbegin', this.countdownEl);
      this.countdownEl.style.display = "block";
      this.countdownEl.style.fontWeight = "bold";
      console.log("Countdown element created and styled.");
    } else {
      console.log("Using existing countdown element.");
      this.countdownEl.style.display = "block";
      this.countdownEl.style.fontWeight = "bold";
    }

    this.modalShown = false;
    this.timer = setInterval(() => {
      this.updateCountdown();
    }, 1000);
    this.updateCountdown();  // Initial call
  }

  disconnect() {
    if (this.timer) {
      clearInterval(this.timer);
    }
    try {
      this.alertSound?.pause();
      this.alertSound.currentTime = 0;
    } catch (error) {
      console.warn("Error stopping sound:", error);
    }
  }

  updateCountdown() {
    const now = new Date();
    const remaining = this.endTime - now;
    console.log(`Order ${this.orderIdValue} remaining time (ms):`, remaining);
    if (remaining <= 0) {
      clearInterval(this.timer);
      this.countdownEl.textContent = "Time's up!";
      try {
        this.alertSound.pause();
        this.alertSound.currentTime = 0;
      } catch (err) {
        console.warn("Failed to stop sound:", err);
      }
      this.countdownEl.classList.add("text-danger");
      if (!this.modalShown) {
        this.modalShown = true;
        this.showModal();
      }
    } else {
      this.countdownEl.textContent = formatTime(Math.floor(remaining / 1000));
    }
  }

  tick() {
    const now = new Date()
    const diff = Math.floor((this.deadline - now)/1000)
    if (diff <= 0) {
      clearInterval(this.timer)
      this.countdownEl.textContent = "Time's up!"
      this.countdownEl.classList.add("text-danger")
      if (this.alertSound) {
        this.alertSound.currentTime = 0
        this.alertSound.play().catch(()=>{})
      }
      if (!this.modalShown) {
        this.modalShown = true
        this.showModal()
      }
    } else {
      this.countdownEl.textContent = formatTime(diff)
    }
  }

  showModal() {
    // Global search for the modal if it's not found within the element
    const modalEl = document.getElementById(`finalizeOrderModal-${this.orderIdValue}`);
    if (modalEl) {
      const modal = bootstrap.Modal.getOrCreateInstance(modalEl);
      modal.show();
      modalEl.addEventListener("hidden.bs.modal", () => {
        document.body.classList.remove("modal-open");
        document.querySelectorAll(".modal-backdrop").forEach(el => el.remove());
      });
      console.log("✅ Modal shown for order", this.orderIdValue);
    } else {
      console.warn("❌ Modal element not found for order", this.orderIdValue);
    }
  }

  async confirmFinalize(event) {
    event.preventDefault()

    const modalEl = document.getElementById(`finalizeOrderModal-${this.orderIdValue}`)
    if (!modalEl) return

    const modal = bootstrap.Modal.getOrCreateInstance(modalEl)

    try {
      const response = await fetch(`/stores/orders/${this.orderIdValue}/finalize`, {
        method: "PATCH",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token":  document.querySelector("meta[name='csrf-token']").content
        }
      })
      if (!response.ok) throw new Error("Erro ao finalizar pedido")

      // Remove o card
      document.getElementById(`order-${this.orderIdValue}`)?.remove()

      // Fecha o modal
      modal.hide()
    } catch (error) {
      alert("❌ " + error.message)
    } finally {
      // FORÇA a limpeza do backdrop e da classe modal-open
      document.body.classList.remove("modal-open")
      document.querySelectorAll(".modal-backdrop").forEach(el => el.remove())
    }
  }
}