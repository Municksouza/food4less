console.log("Application initialized"); // Added test log

import "@hotwired/stimulus";
import "./controllers"; // Import Stimulus controllers
import "./poppers/my-get-base-placement.js"; // Customized Popper
import "./mapbox_geocode";
import "./channels";
import "@hotwired/turbo-rails"


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

