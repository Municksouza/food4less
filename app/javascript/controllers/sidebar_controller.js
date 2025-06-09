import { Controller } from "@hotwired/stimulus";
import * as bootstrap from "bootstrap";

export default class extends Controller {
  static targets = ["sidebar", "toggleButton", "toggleIcon", "storeItem"];
  flyout;

  connect() {
    this.initTooltips();
    this.initExpandButton();
    this.highlightActiveLink();
    this.setupSearchFocusBehavior();
    this.renderFlyoutMenu();
  }

  initTooltips() {
    const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    this.tooltipInstances = tooltipTriggerList.map(el => new bootstrap.Tooltip(el));
  }

  toggleSidebar(event) {
    event.preventDefault();
    const body = document.body;
    const isCollapsed = body.classList.contains('sidebar-closed');

    body.classList.toggle('sidebar-closed', !isCollapsed);
    body.classList.toggle('sidebar-expanded', isCollapsed);

    this.toggleIcon();
    this.updateExpandButtonPosition();
  }

  toggleIcon() {
    const iconRight = this.element.querySelector(".toggle-icon-right");
    const iconLeft = this.element.querySelector(".toggle-icon-left");

    iconRight?.classList.toggle("hide");
    iconLeft?.classList.toggle("hide");
  }

  handleLinkClick(event) {
    event.stopPropagation();
    const url = event.currentTarget.getAttribute("data-url");

    if (!document.body.classList.contains('sidebar-expanded')) {
      event.preventDefault();
      document.body.classList.add('sidebar-expanded');
    } else if (url) {
      event.preventDefault();
      window.location.href = url;
    }
  }

  toggleSearch(event) {
    event.stopPropagation();
    const searchWrapper = this.element.querySelector('.search__wrapper');
    const input = searchWrapper.querySelector('.form-control');
    const isActive = searchWrapper.classList.toggle('active');

    input.style.display = isActive ? 'block' : 'none';
    if (isActive) input.focus();
  }

  initExpandButton() {
    const expandBtn = document.querySelector(".expand-btn");
    expandBtn?.addEventListener("click", () => {
      document.body.classList.toggle("sidebar-closed");
      document.body.classList.toggle("sidebar-expanded");
      this.updateExpandButtonPosition();
    });
  }

  updateExpandButtonPosition() {
    const expandBtn = document.querySelector(".expand-btn");
    if (!expandBtn) return;

    expandBtn.style.left = document.body.classList.contains("sidebar-closed") ? "45px" : "212px";
  }

  highlightActiveLink() {
    const allLinks = document.querySelectorAll(".sidebar-links a");

    allLinks.forEach(link => {
      link.addEventListener("click", () => {
        allLinks.forEach(l => l.classList.remove("active"));
        link.classList.add("active");
      });
    });
  }

  setupSearchFocusBehavior() {
    const searchInput = document.querySelector(".search__wrapper input");
    searchInput?.addEventListener("focus", () => {
      document.body.classList.remove("collapsed");
    });
  }

  toggleSubmenu(event) {
    event.preventDefault();
    const parentItem = event.currentTarget.closest('.sidebar-item');
    const submenu = parentItem.querySelector('.collapse');
    const icon = event.currentTarget.querySelector('.submenu-toggle-icon');

    if (!submenu) return;

    document.querySelectorAll('.submenu').forEach(el => el !== submenu && el.classList.remove('show'));
    document.querySelectorAll('.submenu-toggle-icon').forEach(el => el !== icon && el.classList.remove('rotate'));

    submenu.classList.toggle('show');
    icon?.classList.toggle('rotate');
  }

  showFlyout() {
    this.flyout?.classList.add("active");
  }

  hideFlyout() {
    setTimeout(() => {
      if (!this.flyout.matches(":hover")) {
        this.flyout.classList.remove("active");
      }
    }, 200);
  }

  toggleFlyout() {
    this.flyout?.classList.toggle("active");
  }

  renderFlyoutMenu() {
    const storeDataElement = document.getElementById("store-data");
    if (!storeDataElement) return;

    const stores = JSON.parse(storeDataElement.textContent || "[]");
    this.flyout = document.createElement("div");
    this.flyout.classList.add("sidebar-flyout");

    stores.forEach(store => {
      const item = document.createElement("div");
      item.className = "store-flyout-item";
      item.innerHTML = `
        <img src="${store.logo_url}" class="store-flyout-logo" alt="${store.name}">
        <span class="store-flyout-name">${store.name}</span>
      `;
      item.onclick = () => window.location.href = store.link;
      this.flyout.appendChild(item);
    });

    document.body.appendChild(this.flyout);
  }
}