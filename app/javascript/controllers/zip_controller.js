import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]

  async search() {
    const zip = this.inputTarget.value.trim()
    if (!zip) return

    const token = document.querySelector('meta[name="mapbox-token"]')?.content
    if (!token) {
      alert("Mapbox token not found.")
      return
    }

    try {
        const response = await fetch(`https://api.mapbox.com/geocoding/v5/mapbox.places/${zip}.json?country=CA&access_token=${token}`)
        const data = await response.json()
        if (data.features.length === 0 || !data.features[0].place_name.includes("Canada")) {
            alert("ZIP code not found in Canada. Please enter a valid Canadian ZIP.");
            return;
          }

      if (data.features.length === 0) {
        alert("Location not found.")
        return
      }

      const [lng, lat] = data.features[0].center
      const event = new CustomEvent("zip:located", { detail: { lng, lat } })
      window.dispatchEvent(event)
    } catch (err) {
      console.error("Geocoding error:", err)
    }
  }
}