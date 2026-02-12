// ============================================
// Bourbaki Landing Page — Animations & Effects
// ============================================

(function () {
  'use strict';

  // --- Intersection Observer for scroll animations ---
  const animatedElements = document.querySelectorAll('[data-animate]');

  const observer = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          entry.target.classList.add('visible');
          observer.unobserve(entry.target);
        }
      });
    },
    {
      threshold: 0.15,
      rootMargin: '0px 0px -40px 0px',
    }
  );

  animatedElements.forEach((el) => observer.observe(el));

  // --- Nav background on scroll ---
  const nav = document.querySelector('.nav');
  let lastScroll = 0;

  function updateNav() {
    const scrollY = window.scrollY;
    if (scrollY > 80) {
      nav.style.borderBottomColor = 'rgba(110, 106, 134, 0.15)';
    } else {
      nav.style.borderBottomColor = 'rgba(110, 106, 134, 0.05)';
    }
    lastScroll = scrollY;
  }

  window.addEventListener('scroll', updateNav, { passive: true });

  // --- Smooth anchor scrolling with offset ---
  document.querySelectorAll('a[href^="#"]').forEach((anchor) => {
    anchor.addEventListener('click', function (e) {
      const target = document.querySelector(this.getAttribute('href'));
      if (target) {
        e.preventDefault();
        const offset = 80; // nav height
        const top = target.getBoundingClientRect().top + window.scrollY - offset;
        window.scrollTo({ top, behavior: 'smooth' });
      }
    });
  });

  // --- Parallax on hero ornament ---
  const ornament = document.querySelector('.hero-ornament');
  if (ornament && window.matchMedia('(min-width: 901px)').matches) {
    window.addEventListener(
      'scroll',
      () => {
        const scrollY = window.scrollY;
        const factor = scrollY * 0.15;
        ornament.style.transform = `translateY(calc(-50% + ${factor}px))`;
        ornament.style.opacity = Math.max(0, 0.5 - scrollY * 0.0005);
      },
      { passive: true }
    );
  }

  // --- Keyboard shortcut hover effect ---
  document.querySelectorAll('kbd').forEach((key) => {
    key.addEventListener('mouseenter', () => {
      key.style.transform = 'translateY(-1px)';
      key.style.borderColor = 'var(--iris)';
      key.style.transition = 'all 0.15s ease';
    });
    key.addEventListener('mouseleave', () => {
      key.style.transform = 'translateY(0)';
      key.style.borderColor = 'var(--highlight-med)';
    });
  });

  // --- Feature card tilt effect ---
  document.querySelectorAll('.feature-card').forEach((card) => {
    card.addEventListener('mousemove', (e) => {
      const rect = card.getBoundingClientRect();
      const x = ((e.clientX - rect.left) / rect.width - 0.5) * 6;
      const y = ((e.clientY - rect.top) / rect.height - 0.5) * 6;
      card.style.transform = `translateY(-3px) perspective(600px) rotateX(${-y}deg) rotateY(${x}deg)`;
    });
    card.addEventListener('mouseleave', () => {
      card.style.transform = 'translateY(0) perspective(600px) rotateX(0deg) rotateY(0deg)';
    });
  });
})();
