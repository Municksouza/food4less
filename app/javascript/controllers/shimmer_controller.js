import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["shimmer", "poster"]

  connect() {
    console.log("Shimmer connected")
    this.fadeInAfterLoad()
    this.initScrollReveal()
  }

  fadeInAfterLoad() {
    setTimeout(() => {
      this.shimmerTargets.forEach(el => el.remove())
      this.posterTargets.forEach(el => el.classList.add("is-visible"))
    }, 1000)
  }

  initScrollReveal() {
    const observer = new IntersectionObserver(
      entries => {
        entries.forEach(entry => {
          if (entry.isIntersecting) {
            entry.target.classList.add("is-visible")
            observer.unobserve(entry.target)
          }
        })
      },
      { threshold: 0.1 }
    )

    this.posterTargets.forEach(el => observer.observe(el))
  }
}