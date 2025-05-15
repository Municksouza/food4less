if ("serviceWorker" in navigator) {
    navigator.serviceWorker.register("/service-worker.js")
      .then(function(registration) {
        console.log("Service Worker registrado com sucesso:", registration.scope);
      })
      .catch(function(error) {
        console.log("Service Worker falhou:", error);
      });
  }