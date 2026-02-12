// ============================================
// Bourbaki Landing Page — Animations & Effects
// ============================================

(function () {
  'use strict';

  // --- Theme Toggle ---
  const root = document.documentElement;
  const toggle = document.getElementById('theme-toggle');
  const STORAGE_KEY = 'bourbaki-theme';

  function getPreferredTheme() {
    const stored = localStorage.getItem(STORAGE_KEY);
    if (stored) return stored;
    return window.matchMedia('(prefers-color-scheme: light)').matches ? 'light' : 'dark';
  }

  function applyTheme(theme) {
    if (theme === 'light') {
      root.setAttribute('data-theme', 'light');
    } else {
      root.removeAttribute('data-theme');
    }
  }

  // Apply immediately (before paint) — also set in <head> inline script ideally
  applyTheme(getPreferredTheme());

  toggle.addEventListener('click', () => {
    const current = root.getAttribute('data-theme') === 'light' ? 'light' : 'dark';
    const next = current === 'dark' ? 'light' : 'dark';
    applyTheme(next);
    localStorage.setItem(STORAGE_KEY, next);
  });

  // Listen for OS-level theme changes (only if user hasn't manually chosen)
  window.matchMedia('(prefers-color-scheme: light)').addEventListener('change', (e) => {
    if (!localStorage.getItem(STORAGE_KEY)) {
      applyTheme(e.matches ? 'light' : 'dark');
    }
  });

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

  function updateNav() {
    const scrollY = window.scrollY;
    if (scrollY > 80) {
      nav.style.borderBottomColor = 'rgba(110, 106, 134, 0.15)';
    } else {
      nav.style.borderBottomColor = 'rgba(110, 106, 134, 0.05)';
    }
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
