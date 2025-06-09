import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]

  async search() {
    const zip = this.inputTarget.value.trim();
    if (!zip) {
      alert("Please enter a ZIP code.");
      return;
    }

    const token = document.querySelector('meta[name="mapbox-token"]')?.content;
    if (!token) {
      alert("Mapbox token not found.");
      return;
    }

    try {
      const response = await fetch(
        `https://api.mapbox.com/geocoding/v5/mapbox.places/${encodeURIComponent(zip)}.json?country=CA&limit=1&access_token=${token}`
      );
      const data = await response.json();

      if (
        data.features.length === 0 ||
        !data.features[0].place_name.toLowerCase().includes("canada")
      ) {
        alert("ZIP code not found in Canada. Please enter a valid Canadian ZIP.");
        return;
      }

      const [lng, lat] = data.features[0].center;
      const event = new CustomEvent("zip:located", { detail: { lng, lat } });
      window.dispatchEvent(new CustomEvent("zip:search", { detail: { zip } }))
      } catch (error) {
      console.error("Geocoding error:", error);
      alert("There was an error locating the ZIP code.");
    }
  }
}