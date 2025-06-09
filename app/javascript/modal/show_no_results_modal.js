document.addEventListener("DOMContentLoaded", () => {
    const showModal = document.getElementById("noResultsModal");
    if (showModal) {
      const modal = new bootstrap.Modal(showModal);
      modal.show();
    }
  });