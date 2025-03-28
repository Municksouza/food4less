import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  logout(event) {
    event.preventDefault();

    const logoutPath = event.target.dataset.logoutPath; // Obtém o caminho do logout do HTML
    const csrfToken = document.querySelector("[name='csrf-token']");

    if (!csrfToken) {
      console.error("CSRF token not found!");
      return;
    }

    fetch(logoutPath, { 
      method: "DELETE", 
      headers: { 
        "X-CSRF-Token": csrfToken.content,
        "Content-Type": "application/json"
      }
    })
    .then(response => {
      if (response.ok) {
        console.log("✅ Logout successful!");
        window.location.href = "/";
      } else {
        console.error("❌ Logout failed.");
      }
    })
    .catch(error => console.error("❌ Erro na requisição:", error));
  }
}