import mapboxgl from "mapbox-gl"
import { Controller } from "@hotwired/stimulus"
import MapboxSdk from "@mapbox/mapbox-sdk"
import GeocodingService from "@mapbox/mapbox-sdk/services/geocoding"

export default class extends Controller {
  static values = {
    apiKey: String,
    stores: Array
  }

  connect() {
    console.log("Received token:", this.apiKeyValue)
    if (!this.apiKeyValue) return console.error("⚠️ Mapbox API token is missing!")

    if (!mapboxgl.supported()) {
      this.element.style.display = "none"
      const fallback = document.getElementById("unsupported-message")
      if (fallback) fallback.style.display = "block"
      return
    }

    const baseClient = MapboxSdk({ accessToken: this.apiKeyValue })
    this.geocoder = GeocodingService(baseClient)
    console.log("📡 Geocoder:", this.geocoder)

    mapboxgl.accessToken = this.apiKeyValue

    const mapEl = this.element.querySelector("#map")
    if (!mapEl) return console.error("🛑 #map não encontrado dentro do controller")

    this.map = new mapboxgl.Map({
      container: mapEl,
      style: "mapbox://styles/mapbox/streets-v12",
      center: [-106.6345, 52.1332],
      zoom: 11
    })

    const bounds = new mapboxgl.LngLatBounds()
    const stores = this.storesValue || []

    stores.forEach((store) => {
      const lat = parseFloat(store.latitude)
      const lng = parseFloat(store.longitude)

      if (!isNaN(lat) && !isNaN(lng)) {
        new mapboxgl.Marker({ color: "orange" })
          .setLngLat([lng, lat])
          .setPopup(new mapboxgl.Popup().setHTML(`<strong>${store.name}</strong><br>${store.address}`))
          .addTo(this.map)
        bounds.extend([lng, lat])
      }
    })

    if (!bounds.isEmpty()) {
      this.map.fitBounds(bounds, { padding: 20 })
    }

    let zipMarker = null

    window.addEventListener("zip:search", async (event) => {
      const zip = event.detail.zip
      console.log("📦 Buscando ZIP:", zip)
      try {
          const res = await this.geocoder
            .forwardGeocode({
              query: `${zip}, Canada`,
              types: ["postcode"],
              limit: 1
            })
            .send()

        const feature = res.body.features[0]
        console.log("📌 Geocode result:", feature)

        if (!feature) {
          alert("Postal code not found.")
          return
        }

        const [lng, lat] = feature.center

        this.map.flyTo({
          center: [lng, lat],
          zoom: 13,
          speed: 1.2,
          curve: 1.4,
          essential: true
        })

        if (zipMarker) zipMarker.remove()
        zipMarker = new mapboxgl.Marker({ color: "blue" })
          .setLngLat([lng, lat])
          .setPopup(new mapboxgl.Popup().setText("You searched here"))
          .addTo(this.map)
      } catch (err) {
        console.error("Geocoding failed:", err)
      }
    })
  }

  centerSaskatoon(event) {
    event?.preventDefault()
    console.log("🧭 Centralizando em Saskatoon...")
    if (this.map) {
      this.map.flyTo({
        center: [-106.6345, 52.1332],
        zoom: 11,
        speed: 1.2,
        curve: 1.4,
        essential: true
      })
    }
  }

  scrollToMap(event) {
    event?.preventDefault();
    const mapEl = this.element.querySelector("#map");
    if (mapEl) {
      mapEl.scrollIntoView({ behavior: "smooth", block: "start" });
    }
  }

  focus(event) {
    const lat = parseFloat(event.target.dataset.lat)
    const lng = parseFloat(event.target.dataset.lng)

    if (!isNaN(lat) && !isNaN(lng)) {
      this.map.flyTo({
        center: [lng, lat],
        zoom: 14
      })
    }
  }
}