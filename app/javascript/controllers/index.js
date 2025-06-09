import { Application } from "@hotwired/stimulus"
import "./turbo_reconnect"
import "./order_utils.js"

const application = Application.start()
window.Stimulus = application

// Register your controllers
import HelloController from "./hello_controller.js"
application.register("hello", HelloController)

import LogoutController from "./logout_controller.js"
application.register("logout", LogoutController)

import CountdownController from "./countdown_controller.js"
application.register("countdown", CountdownController)

import SoundActivationController from "./sound_activation_controller.js"
application.register("sound-activation", SoundActivationController)

import PreviewController from "./preview_controller.js"
application.register("preview", PreviewController)

import ShimmerController from "./shimmer_controller"
Stimulus.register("shimmer", ShimmerController)

// Expose global sound functions
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

import SidebarController from "./sidebar_controller"
application.register("sidebar", SidebarController)

import PhoneController from "./phone_controller.js"
application.register("phone", PhoneController)

import FloatingEmojisController from "./floating_emojis_controller.js"
application.register("floating-emojis", FloatingEmojisController)

import SearchModalController from "./search_modal_controller.js"
application.register("search_modal", SearchModalController)

import MapController from "./map_controller.js"
application.register("map", MapController)

import ZipController from "./zip_controller.js"
application.register("zip", ZipController)

import TooltipsController from "./tooltips_controller.js"
application.register("tooltips", TooltipsController)

import carousel_controller from "./carousel_controller.js"
application.register("carousel", carousel_controller)
