import AOS from 'aos';
import 'aos/dist/aos.css';

export function initAOS() {
    AOS.init({
    once: true,
    duration: 700,
    easing: 'ease-out-cubic',
    mirror: true, 
    startEvent: 'DOMContentLoaded',
    });
}

document.addEventListener('DOMContentLoaded', initAOS);