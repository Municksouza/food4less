import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "preview"]

  connect() {
    this.inputTarget.addEventListener("change", (event) => {
      this.previewTarget.innerHTML = ""; // limpa preview anterior

      Array.from(event.target.files).forEach((file) => {
        const reader = new FileReader();
        reader.onload = (e) => {
          const div = document.createElement("div");
          div.classList.add("col-4", "mb-2");

          div.innerHTML = `
            <img src="${e.target.result}" class="img-fluid rounded border" style="max-height: 150px;">
          `;
          this.previewTarget.appendChild(div);
        };
        reader.readAsDataURL(file);
      });
    });
  }
}