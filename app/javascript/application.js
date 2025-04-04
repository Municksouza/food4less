// import "@hotwired/turbo-rails"; // Turbo
import "./controllers"; // Stimulus
import "./poppers/my-get-base-placement.js"; // Customized Popper
import "./mapbox_geocode"

// Import Rails modules
import Rails from "@rails/ujs";
import * as ActiveStorage from "@rails/activestorage";
import * as bootstrap from "bootstrap";
window.bootstrap = bootstrap;
import "chartkick/chart.js"
import "@fortawesome/fontawesome-free/js/all";

// Initialize Rails modules
Rails.start();
ActiveStorage.start();
