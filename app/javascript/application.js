console.log("Application initialized"); // Added test log

import "@hotwired/stimulus";
import "./controllers"; // Import Stimulus controllers
import "./poppers/my-get-base-placement.js"; // Customized Popper
import "./mapbox_geocode";
import "./channels";
import "@hotwired/turbo-rails"
import "@fortawesome/fontawesome-free/css/all.min.css";
import "./register_service_worker";
import "./modal/show_no_results_modal.js"; // Import the modal script


// slick-carousel must be imported from node_modules:
import "slick-carousel";                             // o JS do Slick
import "slick-carousel/slick/slick.css";             // o CSS básico
import "slick-carousel/slick/slick-theme.css";       // tema opcional

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
