// import { Controller } from "@hotwired/stimulus";

// export default class extends Controller {
//   static targets = ["storeItem"];

//   connect() {
//     this.loadStoreData();
//     this.createFlyout();
//   }

//   loadStoreData() {
//     const storeDataEl = document.getElementById("store-data");
//     if (!storeDataEl) {
//       console.warn("No #store-data element found.");
//       this.stores = [];
//       return;
//     }
//     try {
//       this.stores = JSON.parse(storeDataEl.textContent);
//     } catch {
//       console.error("Invalid JSON in #store-data");
//       this.stores = [];
//     }
//   }

//   createFlyout() {
//     this.flyout = document.createElement("div");
//     this.flyout.classList.add("sidebar-flyout");
//     document.body.appendChild(this.flyout);
//     this.renderFlyoutItems();
//   }

//   renderFlyoutItems() {
//     this.flyout.innerHTML = ""; 
//     this.stores.forEach((store) => {
//       const item = document.createElement("div");
//       item.classList.add("store-flyout-item");
//       item.innerHTML = `
//         <img src="${store.logo}" class="store-flyout-logo" alt="${store.name}" />
//         <span class="store-flyout-name">${store.name}</span>`;
//       item.onclick = () => (window.location.href = store.link);
//       this.flyout.appendChild(item);
//     });
//   }

//   showFlyout(event) {
//     const icon = event.currentTarget.querySelector("#storeIcon");
//     const rect = icon.getBoundingClientRect();
//     this.flyout.style.top = `${rect.top}px`;
//     this.flyout.style.left = `${rect.right + 10}px`;
//     this.flyout.classList.add("active");
//   }

//   hideFlyout() {
//     setTimeout(() => {
//       if (!this.flyout.matches(":hover")) {
//         this.flyout.classList.remove("active");
//       }
//     }, 200);
//   }
// }