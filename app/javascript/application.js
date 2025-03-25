// import "@hotwired/turbo-rails"; // Turbo para navegação otimizada
import "./controllers"; // Stimulus Controllers
console.log("✅ Application.js carregado com sucesso!");

// 🚀 Capturar erro do Turbo Fetch Request
document.addEventListener("turbo:fetch-request-error", (event) => {
    console.error("❌ Turbo Fetch Error:", event);
    alert("Erro ao carregar a página. Tente novamente mais tarde.");
});

// 🚀 Evento Turbo carregado
document.addEventListener("turbo:load", () => {
    console.log("✅ Turbo carregado corretamente.");
});

// 🚀 Turbo antes da requisição
document.addEventListener("turbo:before-fetch-request", (event) => {
    if (event.detail && event.detail.fetchOptions) {
        console.log("🚀 Turbo Fetch Request:", event.detail.fetchOptions);
    } else {
        console.warn("⚠️ Turbo Fetch Request: fetchOptions está indefinido ou nulo.");
    }
});

// 🚀 Inicializar Bootstrap
import * as bootstrap from "bootstrap";

document.addEventListener("turbo:load", () => {
    console.log("🔄 Turbo carregado - inicializando dropdowns...");

    document.querySelectorAll('[data-bs-toggle="dropdown"]').forEach((dropdown) => {
        try {
            new bootstrap.Dropdown(dropdown);
        } catch (error) {
            console.error("❌ Erro ao inicializar dropdown:", error);
        }
    });
});