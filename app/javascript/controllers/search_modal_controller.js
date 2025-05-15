import { Controller } from "@hotwired/stimulus";

export default class SearchModalController extends Controller {
  connect() {
    const modal = document.getElementById("productSearchModal") || document.getElementById("noResultsModal");
    if (modal) {
      new bootstrap.Modal(modal).show();
    }
  }
}