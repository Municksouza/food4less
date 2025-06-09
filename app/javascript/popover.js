import 'bootstrap/js/dist/popover'

document.addEventListener('DOMContentLoaded', () => {
  document
    .querySelectorAll('[data-bs-toggle="popover"]')
    .forEach(el => new bootstrap.Popover(el))
})