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
    // Initialize carousels after a short delay to ensure the DOM is ready
    setTimeout(() => {
      this.initProductsSection();
      this.initCuisinesCarousel();
    }, 100);
  }

  // Add the missing method to prevent errors
  initProductsSection() {
    // Add your initialization logic here if needed
    console.log('Initializing products section');

    // Set up mini carousel reveal on scroll
    this._boundRevealMiniCategories = this.revealMiniCategories.bind(this);
    window.addEventListener('scroll', this._boundRevealMiniCategories);
    this.revealMiniCategories();

    $('.products-section').slick({
      slidesToShow: 3,
      slidesToScroll: 1,
      centerMode: true,
      infinite: true,
      arrows: true,
      dots: false,
      autoplay: true,
      autoplaySpeed: 3000,
      prevArrow: '<button type="button" class="slick-prev product-arrow product-arrow--left"><i class="fas fa-chevron-left"></i></button>',
      nextArrow: '<button type="button" class="slick-next product-arrow product-arrow--right"><i class="fas fa-chevron-right"></i></button>',
      responsive: [
        {
          breakpoint: 992,
          settings: {
            slidesToShow: 2
          }
        },
        {
          breakpoint: 576,
          settings: {
            slidesToShow: 1,
            arrows: false
          }
        }
      ]
    });
  }

  // Initializes the cuisines carousel
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

  // Animates product cards in the hero section
  animateProductsInHero() {
    if (this.hasProductCardTarget) {
      this.productCardTargets.forEach((card, index) => {
        setTimeout(() => {
          card.classList.add('animated-product');
        }, index * 200);
      });
    }
  }

  // Handles add to cart button click
  addToCart(e) {
    e.preventDefault();
    const button = e.currentTarget;
  
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
  // Reveals the mini categories carousel when scrolled into view
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