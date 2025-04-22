import { Controller } from "@hotwired/stimulus";
import { stopGlobalAudio } from "../controllers/sound_controller";

export default class extends Controller {
  logout(event) {
    event.preventDefault();

    const logoutPath = event.target.dataset.logoutPath;
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
        stopGlobalAudio();
        window.location.href = "/";
      } else {
        console.error("❌ Logout failed.");
        stopGlobalAudio();
      }
    })
    .catch(error => {
      console.error("❌ Erro na requisição:", error);
      stopGlobalAudio();
    });
  }
}