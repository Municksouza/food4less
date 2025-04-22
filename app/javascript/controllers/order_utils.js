// order_utils.js

// Função para formatar tempo
export function formatTime(seconds) {
  const mins = Math.floor(seconds / 60);
  const secs = seconds % 60;
  return `${String(mins).padStart(2, '0')}:${String(secs).padStart(2, '0')}`;
}

// Reconecta quando um Turbo Frame é carregado
document.addEventListener("turbo:frame-load", (event) => {
  reconnectCountdownControllers(event.target);
});

// Reconecta quando turbo-stream renderiza conteúdo novo
document.addEventListener("turbo:before-stream-render", (event) => {
  const fragment = event.detail?.newStreamFragment;
  if (fragment) reconnectCountdownControllers(fragment);
});

// Observa dinamicamente containers atualizados
["pending-orders", "in-progress-orders"].forEach((id) => {
  const container = document.getElementById(id);
  if (container) {
    const observer = new MutationObserver((mutations) => {
      mutations.forEach((mutation) => {
        mutation.addedNodes.forEach((node) => {
          if (node.nodeType === Node.ELEMENT_NODE) {
            reconnectCountdownControllers(node);
          }
        });
      });
    });
    observer.observe(container, { childList: true, subtree: true });
  }
});

// Função de reconexão
function reconnectCountdownControllers(scope) {
  const countdowns = scope.querySelectorAll?.('[data-controller~="countdown"]') || [];
  countdowns.forEach((el) => {
    window.Stimulus?.connectContextForElement?.(el);
    console.log("🔄 (observer) Countdown reconnected:", el.getAttribute("data-countdown-order-id-value"));
  });
}