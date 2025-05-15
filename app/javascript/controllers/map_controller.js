import { Controller } from "@hotwired/stimulus";
import mapboxgl from "mapbox-gl";

export default class extends Controller {
    static values = { stores: Array, apiKey: String };

    connect() {
        const mapboxToken = document.querySelector('meta[name="mapbox-token"]').content;
        mapboxgl.accessToken = mapboxToken;

        const map = new mapboxgl.Map({
            container: "map",
            style: "mapbox://styles/mapbox/navigation-day-v1",
            center: [-106.6345, 52.1332],
            zoom: 9,
        });

        map.on("load", () => {
            map.resize(); // Ensures the container size is calculated correctly
            map.setCenter([-106.6345, 52.1332]); // Forces the center
            map.setZoom(9); // Reinforces the zoom level
        });

        const stores = window.stores || this.storesValue || [];
        const bounds = new mapboxgl.LngLatBounds();

        stores.forEach((store) => {
            const lat = parseFloat(store.latitude);
            const lng = parseFloat(store.longitude);

            if (!isNaN(lat) && !isNaN(lng)) {
                new mapboxgl.Marker({ color: "orange" })
                    .setLngLat([lng, lat])
                    .setPopup(new mapboxgl.Popup().setHTML(`<strong>${store.name}</strong><br>${store.address}`))
                    .addTo(map);

                // ESSENTIAL: Include the point in the bounds
                bounds.extend([lng, lat]);
            }
        });

        window.addEventListener("zip:located", (event) => {
            const { lng, lat } = event.detail;

            map.flyTo({
                center: [lng, lat],
                zoom: 13,
                speed: 1.2,
                curve: 1,
                essential: true,
            });

            // Optional: Adds a marker where the user searched
            new mapboxgl.Marker({ color: "blue" })
                .setLngLat([lng, lat])
                .setPopup(new mapboxgl.Popup().setText("You searched here"))
                .addTo(map);
        });
    }
}
