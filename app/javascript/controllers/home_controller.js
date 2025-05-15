import { Controller } from "@hotwired/stimulus"
import $ from "jquery"
import "slick-carousel"

// Ensure slick-carousel is properly initialized
if (typeof $.fn.slick === "undefined") {
  console.error("slick-carousel is not loaded. Please check your imports.");
}

export default class extends Controller {
  static targets = ["productCard", "addCartButton"]

  connect() {
    console.log('Home controller connected');
    // Inicializa os carrosséis após um pequeno atraso para garantir que o DOM esteja pronto
    setTimeout(() => {
      this.initProductsSection();
      this.initCuisinesCarousel();
    }, 100);

    // Configura a revelação do mini carrossel via scroll
    this._boundRevealMiniCategories = this.revealMiniCategories.bind(this);
    window.addEventListener('scroll', this._boundRevealMiniCategories);
    this.revealMiniCategories();
  }

  initProductsSection() {
    console.log('Slick initialization starting');
    const $productsSection = $('.products-section');
    console.log('Products section found:', $productsSection.length);

    if ($productsSection.length > 0) {
      $productsSection.slick({
        slidesToShow: 2,
        slidesToScroll: 1,
        centerMode: false,
        infinite: true,
        variableWidth: false,
        centerPadding: '0px',
        arrows: true,
        dots: true,
        autoplay: true,
        autoplaySpeed: 4000,
        accessibility: false,
        prevArrow: '<button type="button" class="slick-prev product-arrow product-arrow--left"><i class="fas fa-chevron-left"></i></button>',
        nextArrow: '<button type="button" class="slick-next product-arrow product-arrow--right"><i class="fas fa-chevron-right"></i></button>',
        responsive: [
          { breakpoint: 768, settings: { arrows: false, dots: true } }
        ]
      });
      console.log('Products-section carousel initialized');
    } else {
      console.error("Products-section carousel not found.");
    }
  }

  initCuisinesCarousel() {
    console.log('Initializing cuisines carousel');
    const $cuisinesCarousel = $('.cuisines-carousel');
    console.log('Cuisines carousel element found:', $cuisinesCarousel.length);
    if ($cuisinesCarousel.length > 0) {
      $cuisinesCarousel.slick({
        accessibility: false,
        slidesToShow: 5,
        slidesToScroll: 2,
        arrows: true,
        dots: false,
        autoplay: true,
        infinite: true,
        prevArrow: '<button type="button" class="slick-prev">←</button>',
        nextArrow: '<button type="button" class="slick-next">→</button>',
        responsive: [
          {
            breakpoint: 992,
            settings: { slidesToShow: 4 }
          },
          {
            breakpoint: 768,
            settings: { slidesToShow: 3 }
          },
          {
            breakpoint: 576,
            settings: { slidesToShow: 2 }
          }
        ]
      });
    }
  }

  animateProductsInHero() {
    if (this.hasProductCardTarget) {
      this.productCardTargets.forEach((card, index) => {
        setTimeout(() => {
          card.classList.add('animated-product');
        }, index * 200);
      });
    }
  }

  addToCart(event) {
    event.preventDefault();
    const button = event.currentTarget;
  
    button.classList.add("btn-added");
    button.innerHTML = "✅ Added";
  
    // After 2 seconds, restore button text
    setTimeout(() => {
      button.classList.remove("btn-added");
      button.innerHTML = "🛒 Add to Cart";
    }, 2000);
  
    // Continue form submission
    button.closest("form").submit();
  }

  revealMiniCategories() {
    const miniCarousel = document.querySelector('.cuisines-carousel');
    if (!miniCarousel) return;
    const rect = miniCarousel.getBoundingClientRect();
    const windowHeight = window.innerHeight;
    if (rect.top <= windowHeight - 100) {
      miniCarousel.classList.add('mini-categories-visible');
      window.removeEventListener('scroll', this._boundRevealMiniCategories);
    }
  }
}