// app/javascript/controllers/carousel_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["carousel"]
  static values = {
    interval: { type: Number, default: 5000 }
  }

  connect() {
    this.index = 0
    this.cards = this.carouselTarget.children
    this.showSlide(this.index)
    this.startAutoSlide()
  }

  disconnect() {
    clearInterval(this.timer)
  }

  startAutoSlide() {
    this.timer = setInterval(() => {
      this.index = (this.index + 1) % this.cards.length
      this.showSlide(this.index)
    }, this.intervalValue)
  }

  goTo(event) {
    this.index = parseInt(event.currentTarget.dataset.index)
    this.showSlide(this.index)
    clearInterval(this.timer)
    this.startAutoSlide()
  }

  showSlide(index) {
    [...this.cards].forEach((card, i) => {
      card.style.display = i === index ? "block" : "none"
      card.classList.toggle("fade-in", i === index)
    })

    const buttons = this.element.querySelectorAll(".indicator")
    buttons.forEach((btn, i) => {
      btn.classList.toggle("active", i === index)
    })
  }
}