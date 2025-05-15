import { Application } from "@hotwired/stimulus"
import "./turbo_reconnect"
import "./order_utils.js"

const application = Application.start()
window.Stimulus = application

// Registre seus controllers
import HelloController from "./hello_controller.js"
application.register("hello", HelloController)

import LogoutController from "./logout_controller.js"
application.register("logout", LogoutController)

import CountdownController from "./countdown_controller.js"
application.register("countdown", CountdownController)

import SoundActivationController from "./sound_activation_controller.js"
application.register("sound-activation", SoundActivationController)

// Exponha funções globais de som
import {
  playNotificationSound,
  stopGlobalAudio,
  unlockAudioForAutoplay
} from "./sound_controller.js"

window.playNotificationSound      = playNotificationSound
window.stopNotificationSound      = stopGlobalAudio
window.unlockAudioForAutoplay     = unlockAudioForAutoplay

import HomeController from "./home_controller.js"  
application.register("home", HomeController)

import SidebarController from "./sidebar_controller.js"
application.register("sidebar", SidebarController)

import PhoneController from "./phone_controller"
application.register("phone", PhoneController)

import FloatingEmojisController from "./floating_emojis_controller"
application.register("floating-emojis", FloatingEmojisController)

import SearchModalController from "./search_modal_controller"
application.register("search_modal", SearchModalController)

import MapController from "./map_controller"
application.register("map", MapController)

import ZipController from "./zip_controller"
application.register("zip", ZipController)

