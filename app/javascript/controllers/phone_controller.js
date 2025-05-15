import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    connect() {
        // Adds a click event listener to the element when the controller is connected
        this.element.addEventListener("click", this.onClick.bind(this))
    }

    disconnect() {
        // Removes the click event listener when the controller is disconnected
        this.element.removeEventListener("click", this.onClick)
    }

    onClick(event) {
        // Finds the closest element with the class "js-phone"
        const btn = event.target.closest(".js-phone")
        if (!btn) return // If no such element is found, exit the function

        event.preventDefault() // Prevents the default action of the click event
        const phone = btn.dataset.phone // Retrieves the phone number from the data attribute
        const ua = navigator.userAgent || window.opera // Gets the user agent string

        // Detects if the user is on a mobile device (iOS or Android)
        const isMobile = /Android|iPhone|iPad|iPod/i.test(ua)

        if (isMobile) {
            // On mobile devices: opens the phone dialer with the phone number
            window.location.href = `tel:${phone}`
        } else {
            // On desktop devices: shows a confirmation dialog
            const shouldCall = confirm(`Do you want to call ${phone}?`)
            if (shouldCall) {
                // If the user confirms, attempts to open the phone dialer (may trigger FaceTime)
                window.location.href = `tel:${phone}`
            }
            // If the user cancels, the dialog simply closes
        }
    }
}