---
name: vader-animations
description: Use this skill whenever adding motion, effects, or interactive feedback to any VaderLabz or Vader Protocol project. Triggers: "add animations", "make it feel alive", "add effects", "cool interactions", "micro-interactions", "vader animations". Contains all approved animations, hover effects, entrance transitions, and atmospheric effects for the Vader Protocol design system. Never introduces colors or styles outside the Vader Protocol palette.
---

# Vader Protocol — Animation & Effects System

All motion in Vader Protocol serves atmosphere and feedback. Nothing is decorative without purpose. Effects should feel like a **military terminal coming online** — precise, intentional, slightly dangerous.

---

## Core Keyframes (globals.css)

Always include all of these in globals.css. They are the foundation.

```css
/* Title flicker — subtle CRT monitor effect */
@keyframes flicker {
  0%, 100% { opacity: 1; }
  92%  { opacity: 1; }
  93%  { opacity: 0.8; }
  94%  { opacity: 1; }
  96%  { opacity: 0.9; }
  97%  { opacity: 1; }
}

/* Entrance — content slides up from below */
@keyframes fadeInUp {
  from { opacity: 0; transform: translateY(24px); }
  to   { opacity: 1; transform: translateY(0); }
}

/* Staggered entrance — use with animation-delay */
@keyframes fadeInLeft {
  from { opacity: 0; transform: translateX(-20px); }
  to   { opacity: 1; transform: translateX(0); }
}

/* Red glow pulse — used on CTAs and status indicators */
@keyframes pulse-red {
  0%, 100% { box-shadow: 0 0 0 0 rgba(192, 57, 43, 0); }
  50%       { box-shadow: 0 0 12px 2px rgba(192, 57, 43, 0.3); }
}

/* Green glow pulse — used on ONLINE status dot */
@keyframes pulse-green {
  0%, 100% { box-shadow: 0 0 0 0 rgba(39, 174, 96, 0); }
  50%       { box-shadow: 0 0 8px 2px rgba(39, 174, 96, 0.5); }
}

/* Typing cursor blink */
@keyframes blink {
  0%, 100% { opacity: 1; }
  50%       { opacity: 0; }
}

/* Scan sweep — horizontal red line sweeping down (use sparingly, not on scroll) */
@keyframes scan-sweep {
  0%   { top: -2px; opacity: 0.6; }
  100% { top: 100%; opacity: 0; }
}

/* Boot sequence — text reveal character by character feel */
@keyframes bootReveal {
  from { clip-path: inset(0 100% 0 0); }
  to   { clip-path: inset(0 0% 0 0); }
}

/* Border march — animated dashed border */
@keyframes borderMarch {
  from { background-position: 0 0, 100% 0, 100% 100%, 0 100%; }
  to   { background-position: 20px 0, 100% 20px, calc(100% - 20px) 100%, 0 calc(100% - 20px); }
}

/* Shake — error / warning feedback */
@keyframes shake {
  0%, 100% { transform: translateX(0); }
  20%       { transform: translateX(-4px); }
  40%       { transform: translateX(4px); }
  60%       { transform: translateX(-3px); }
  80%       { transform: translateX(3px); }
}

/* Scale in — modal / card entrance */
@keyframes scaleIn {
  from { opacity: 0; transform: scale(0.95); }
  to   { opacity: 1; transform: scale(1); }
}

/* Number counter — use with JS for counting up stats */
@keyframes countUp {
  from { opacity: 0; transform: translateY(8px); }
  to   { opacity: 1; transform: translateY(0); }
}
```

---

## Applied Animations

### Hero Section
```css
/* Title flicker */
.heroTitle {
  animation: flicker 6s infinite;
}

/* Content entrance */
.heroContent {
  animation: fadeInUp 0.8s ease both;
}

/* Eyebrow text boot reveal */
.heroEyebrow {
  animation: bootReveal 1.2s ease both;
  animation-delay: 0.2s;
}

/* Staggered hero elements */
.heroTitle    { animation: fadeInUp 0.6s ease both; animation-delay: 0.1s; }
.heroSub      { animation: fadeInUp 0.6s ease both; animation-delay: 0.25s; }
.heroDesc     { animation: fadeInUp 0.6s ease both; animation-delay: 0.4s; }
.heroCtas     { animation: fadeInUp 0.6s ease both; animation-delay: 0.55s; }
.heroStatus   { animation: fadeInUp 0.6s ease both; animation-delay: 0.7s; }
```

### Status Dot (SYSTEM ONLINE)
```css
.statusDot {
  width: 6px;
  height: 6px;
  border-radius: 50%;
  background: #27ae60;
  animation: pulse-green 2s infinite;
}
```

### Primary CTA Button
```css
.ctaPrimary {
  animation: pulse-red 3s infinite;
  transition: background 0.2s, border-color 0.2s, transform 0.1s;
}
.ctaPrimary:hover  { background: var(--accent-red-bright); transform: translateY(-1px); }
.ctaPrimary:active { transform: translateY(0) scale(0.98); }
```

### Secondary CTA Button
```css
.ctaSecondary {
  transition: border-color 0.2s, color 0.2s, transform 0.1s;
  position: relative;
  overflow: hidden;
}
.ctaSecondary::after {
  content: '';
  position: absolute;
  inset: 0;
  background: var(--accent-red-dim);
  opacity: 0;
  transition: opacity 0.2s;
}
.ctaSecondary:hover { border-color: var(--accent-red-dim); color: var(--text-primary); }
.ctaSecondary:hover::after { opacity: 0.08; }
```

### Project Cards
```css
.projectCard {
  transition: background 0.2s;
  position: relative;
  overflow: hidden;
}

/* Top border reveal on hover */
.projectCard::before {
  content: '';
  position: absolute;
  top: 0; left: 0; right: 0;
  height: 2px;
  background: var(--accent-red);
  transform: scaleX(0);
  transform-origin: left;
  transition: transform 0.3s ease;
}
.projectCard:hover { background: var(--bg-card-hover); }
.projectCard:hover::before { transform: scaleX(1); }

/* Subtle link reveal */
.projectLink {
  transition: color 0.2s, letter-spacing 0.2s;
}
.projectCard:hover .projectLink {
  color: var(--accent-red-bright);
  letter-spacing: 0.15em;
}
```

### Stack Items
```css
.stackItem {
  transition: border-color 0.2s, color 0.2s, background 0.2s;
}
.stackItem:hover {
  border-color: var(--accent-red-dim);
  color: var(--text-primary);
  background: var(--bg-card-hover);
}
```

### Nav Links
```css
.navLinks a {
  transition: color 0.2s;
  position: relative;
}
/* Underline slide-in on hover */
.navLinks a::after {
  content: '';
  position: absolute;
  bottom: -2px; left: 0;
  width: 0; height: 1px;
  background: var(--accent-red);
  transition: width 0.2s ease;
}
.navLinks a:hover { color: var(--accent-red-bright); }
.navLinks a:hover::after { width: 100%; }
```

### Section Headers (stagger on scroll — use Intersection Observer)
```css
.sectionHeader {
  animation: fadeInLeft 0.5s ease both;
}
```

---

## Atmospheric Effects

### Typing Cursor (add after any monospace text)
```tsx
// In TSX — add after eyebrow or status text
<span className={styles.cursor}>_</span>
```
```css
.cursor {
  display: inline-block;
  color: var(--accent-red);
  animation: blink 1s step-end infinite;
  margin-left: 2px;
}
```

### Marching Border (use on featured/highlighted cards)
```css
.featuredCard {
  background: 
    linear-gradient(90deg,  var(--accent-red-dim) 50%, transparent 50%) top    / 8px 1px repeat-x,
    linear-gradient(90deg,  var(--accent-red-dim) 50%, transparent 50%) bottom / 8px 1px repeat-x,
    linear-gradient(0deg,   var(--accent-red-dim) 50%, transparent 50%) left   / 1px 8px repeat-y,
    linear-gradient(0deg,   var(--accent-red-dim) 50%, transparent 50%) right  / 1px 8px repeat-y;
  background-color: transparent;
  animation: borderMarch 0.4s linear infinite;
}
```

### Boot Sequence Text (terminal startup feel)
```css
.bootText {
  animation: bootReveal 1.5s steps(30) both;
  white-space: nowrap;
  overflow: hidden;
}
```

### Glitch Effect (use on hover for logo or hero title — sparingly)
```css
@keyframes glitch-1 {
  0%, 100% { clip-path: inset(0 0 95% 0); transform: translate(-2px, 0); }
  25%       { clip-path: inset(30% 0 50% 0); transform: translate(2px, 0); }
  50%       { clip-path: inset(60% 0 20% 0); transform: translate(-1px, 0); }
  75%       { clip-path: inset(80% 0 5%  0); transform: translate(1px, 0); }
}
@keyframes glitch-2 {
  0%, 100% { clip-path: inset(50% 0 30% 0); transform: translate(2px, 0);  color: var(--accent-red); }
  33%       { clip-path: inset(10% 0 70% 0); transform: translate(-2px, 0); color: #e74c3c; }
  66%       { clip-path: inset(75% 0 10% 0); transform: translate(1px, 0);  color: var(--accent-red); }
}

.glitchWrapper {
  position: relative;
  display: inline-block;
}
.glitchWrapper::before,
.glitchWrapper::after {
  content: attr(data-text);
  position: absolute;
  inset: 0;
  opacity: 0;
  transition: opacity 0.1s;
}
.glitchWrapper:hover::before {
  opacity: 0.8;
  animation: glitch-1 0.3s steps(1) infinite;
}
.glitchWrapper:hover::after {
  opacity: 0.6;
  animation: glitch-2 0.3s steps(1) infinite;
}
```

Usage in TSX:
```tsx
<h1 className={styles.glitchWrapper} data-text="VADERLABZ">
  VADER<span className={styles.heroTitleAccent}>LABZ</span>
</h1>
```

### Scroll-Triggered Entrance (Intersection Observer)
```tsx
// hooks/useInView.ts
import { useEffect, useRef, useState } from 'react';

export function useInView(threshold = 0.15) {
  const ref = useRef<HTMLElement>(null);
  const [inView, setInView] = useState(false);

  useEffect(() => {
    const observer = new IntersectionObserver(
      ([entry]) => { if (entry.isIntersecting) setInView(true); },
      { threshold }
    );
    if (ref.current) observer.observe(ref.current);
    return () => observer.disconnect();
  }, []);

  return { ref, inView };
}
```

```tsx
// Usage in any section
const { ref, inView } = useInView();
<section ref={ref} className={`${styles.section} ${inView ? styles.visible : ''}`}>
```

```css
.section { opacity: 0; transform: translateY(20px); transition: opacity 0.6s ease, transform 0.6s ease; }
.section.visible { opacity: 1; transform: translateY(0); }
```

---

## Page Load Boot Sequence (optional — high impact)

Adds a full-screen boot overlay that counts up and fades out before the page loads.

```tsx
// components/BootScreen.tsx
'use client';
import { useEffect, useState } from 'react';
import styles from './BootScreen.module.css';

export default function BootScreen() {
  const [progress, setProgress] = useState(0);
  const [done, setDone] = useState(false);

  useEffect(() => {
    const interval = setInterval(() => {
      setProgress(p => {
        if (p >= 100) { clearInterval(interval); setTimeout(() => setDone(true), 400); return 100; }
        return p + Math.floor(Math.random() * 12) + 3;
      });
    }, 80);
    return () => clearInterval(interval);
  }, []);

  if (done) return null;

  return (
    <div className={styles.boot}>
      <p className={styles.bootLine}>// VADER_PROTOCOL :: INITIALIZING</p>
      <p className={styles.bootLine}>// LOADING MODULES... {Math.min(progress, 100)}%</p>
      <div className={styles.bar}><div className={styles.fill} style={{ width: `${Math.min(progress, 100)}%` }} /></div>
      <p className={styles.bootLine}>// SYSTEM ONLINE</p>
    </div>
  );
}
```

```css
/* BootScreen.module.css */
.boot {
  position: fixed; inset: 0; z-index: 9999;
  background: var(--bg-void);
  display: flex; flex-direction: column;
  align-items: center; justify-content: center;
  gap: 1rem;
  animation: fadeOut 0.4s ease forwards;
  animation-delay: 0s;
}
.bootLine {
  font-family: var(--font-mono);
  font-size: 0.8rem;
  color: var(--accent-red);
  letter-spacing: 0.1em;
}
.bar {
  width: 300px; height: 2px;
  background: var(--border);
}
.fill {
  height: 100%;
  background: var(--accent-red);
  transition: width 0.1s ease;
}
@keyframes fadeOut {
  from { opacity: 1; }
  to   { opacity: 0; pointer-events: none; }
}
```

---

## Performance Rules

- Never animate `width`, `height`, `top`, `left` — use `transform` and `opacity` only
- Keep animation durations: micro (0.1–0.2s), feedback (0.2–0.3s), entrance (0.5–0.8s), atmospheric (2s+)
- Use `animation-fill-mode: both` on entrance animations so elements don't flash before animating
- Use `will-change: transform, opacity` only on elements that animate on every frame (scanline, looping effects)
- Respect `prefers-reduced-motion`:

```css
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
  }
}
```

---

## Quick Reference — What to Use Where

| Element | Animation |
|---|---|
| Hero title | `flicker` 6s infinite |
| Hero content | `fadeInUp` staggered |
| Eyebrow text | `bootReveal` |
| CTA primary | `pulse-red` 3s infinite |
| Status dot | `pulse-green` 2s infinite |
| Project cards | top border `scaleX` reveal on hover |
| Nav links | underline `width` slide on hover |
| Stack items | border color + bg transition |
| Logo (optional) | `glitch` on hover |
| Page load (optional) | `BootScreen` component |
| Sections (optional) | `useInView` scroll trigger |
| Featured card (optional) | `borderMarch` dashed border |
| Any mono label | `cursor` blink after text |

---

## Live Reference
https://vaderlabz.com
