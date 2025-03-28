// import "@hotwired/turbo-rails"; // Turbo
import "./controllers"; // Stimulus
import "./poppers/my-get-base-placement.js"; // Popper customizado

// Importa os módulos do Rails
import Rails from "@rails/ujs";
import * as ActiveStorage from "@rails/activestorage";
import * as bootstrap from "bootstrap";
window.bootstrap = bootstrap;

// Inicializa os módulos do Rails
Rails.start();
ActiveStorage.start();
