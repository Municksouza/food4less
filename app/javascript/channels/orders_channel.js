import consumer from "./consumer.js"
import { playNotificationSound, stopGlobalAudio } from "../controllers/sound_controller.js"

document.addEventListener("turbo:load", () => {
  const dashboard = document.getElementById("store-dashboard")
  const storeId   = dashboard?.dataset.storeId?.trim()
  if (!storeId) return

  consumer.subscriptions.create(
    { channel: "OrdersChannel", store_id: storeId },
    {
      received(data) {
        if (data.playSound)  playNotificationSound()
        if (data.stopSound)  stopGlobalAudio()
      }
    }
  )
})