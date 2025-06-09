document.addEventListener("DOMContentLoaded", () => {
  const form = document.querySelector(".store-form-page");
  const logoInput = document.querySelector(".store-logo-input");
  const preview = document.querySelector(".store-logo-preview");

  if (form) {
    form.addEventListener("submit", function (event) {
      if (!form.checkValidity()) {
        event.preventDefault();
        event.stopPropagation();
      }
      form.classList.add("was-validated");
    });
  }

  if (logoInput && preview) {
    logoInput.addEventListener("change", (e) => {
      const file = e.target.files[0];
      preview.innerHTML = "";

      if (file && file.type.startsWith("image/")) {
        const reader = new FileReader();
        reader.onload = (evt) => {
          const img = document.createElement("img");
          img.src = evt.target.result;
          img.alt = "Logo preview";
          preview.appendChild(img);
        };
        reader.readAsDataURL(file);
      } else {
        preview.innerHTML = "<p class='text-danger mt-2'>Invalid image file</p>";
      }
    });
  }
});