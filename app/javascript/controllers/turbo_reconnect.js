function connectCountdowns(root) {
    root.querySelectorAll('[data-controller~="countdown"]').forEach(el => {
      window.Stimulus?.connectContextForElement?.(el);
      console.log("🔄 Countdown connected for order",
                  el.getAttribute("data-countdown-order-id-value"));
    });
  }
  
  // 1) Frame carregado (serve para <turbo-frame> novo)
  document.addEventListener("turbo:frame-load", event => {
    connectCountdowns(event.target);
  });
  
  // 2) Fragmento que vai ser injetado por <turbo-stream>
  document.addEventListener("turbo:before-stream-render", event => {
    const fragment = event.detail?.newStreamFragment;
    if (fragment) connectCountdowns(fragment);
  
    // Se o próprio contêiner ('pending-orders' ou 'in-progress-orders')
    // estiver sendo trocado, precisamos observar o DOM NOVO na próxima
    // _tick_ do navegador.
    queueMicrotask(() => {
      ["pending-orders", "in-progress-orders"].forEach(observeContainer);
    });
  });
  
  // 3) MutationObserver para capturar nós adicionados depois
  function observeContainer(containerId) {
    const container = document.getElementById(containerId);
    if (!container || container.dataset.observed) return;
  
    const observer = new MutationObserver(mutations => {
      mutations.forEach(m => m.addedNodes.forEach(node => {
        if (node.nodeType === Node.ELEMENT_NODE) connectCountdowns(node);
      }));
    });
  
    observer.observe(container, { childList: true, subtree: true });
    container.dataset.observed = "true";
  }
  
  ["pending-orders", "in-progress-orders"].forEach(observeContainer);