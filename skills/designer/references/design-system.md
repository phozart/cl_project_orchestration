# Design System Reference

## Color Palette

### Primary Colors

| Token | Value | Usage |
|-------|-------|-------|
| `--color-primary-50` | #f0f9ff | Backgrounds, hover states |
| `--color-primary-100` | #e0f2fe | Light backgrounds |
| `--color-primary-500` | #0ea5e9 | Primary buttons, links |
| `--color-primary-600` | #0284c7 | Primary button hover |
| `--color-primary-700` | #0369a1 | Primary button active |

### Semantic Colors

| Token | Value | Usage |
|-------|-------|-------|
| `--color-success` | #22c55e | Success messages, confirmations |
| `--color-warning` | #f59e0b | Warnings, cautions |
| `--color-error` | #ef4444 | Errors, destructive actions |
| `--color-info` | #3b82f6 | Informational messages |

### Neutral Colors

| Token | Value | Usage |
|-------|-------|-------|
| `--color-gray-50` | #f9fafb | Page backgrounds |
| `--color-gray-100` | #f3f4f6 | Card backgrounds |
| `--color-gray-200` | #e5e7eb | Borders, dividers |
| `--color-gray-400` | #9ca3af | Placeholder text |
| `--color-gray-600` | #4b5563 | Secondary text |
| `--color-gray-900` | #111827 | Primary text |

## Typography

### Font Family

```css
--font-sans: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
--font-mono: 'JetBrains Mono', 'Fira Code', monospace;
```

### Type Scale

| Token | Size | Line Height | Usage |
|-------|------|-------------|-------|
| `--text-xs` | 12px | 16px | Labels, captions |
| `--text-sm` | 14px | 20px | Secondary text, table cells |
| `--text-base` | 16px | 24px | Body text |
| `--text-lg` | 18px | 28px | Subheadings |
| `--text-xl` | 20px | 28px | Card titles |
| `--text-2xl` | 24px | 32px | Section headings |
| `--text-3xl` | 30px | 36px | Page titles |
| `--text-4xl` | 36px | 40px | Hero headings |

### Font Weights

| Token | Value | Usage |
|-------|-------|-------|
| `--font-normal` | 400 | Body text |
| `--font-medium` | 500 | Labels, buttons |
| `--font-semibold` | 600 | Headings |
| `--font-bold` | 700 | Emphasis |

## Spacing

### Spacing Scale

| Token | Value | Usage |
|-------|-------|-------|
| `--space-1` | 4px | Tight spacing, icon gaps |
| `--space-2` | 8px | Compact elements |
| `--space-3` | 12px | Form field gaps |
| `--space-4` | 16px | Standard padding |
| `--space-5` | 20px | Card padding |
| `--space-6` | 24px | Section gaps |
| `--space-8` | 32px | Large section gaps |
| `--space-10` | 40px | Page sections |
| `--space-12` | 48px | Major sections |
| `--space-16` | 64px | Page margins |

### Common Patterns

```css
/* Card padding */
padding: var(--space-5); /* 20px */

/* Form field gap */
gap: var(--space-3); /* 12px */

/* Section margin */
margin-bottom: var(--space-10); /* 40px */

/* Button padding */
padding: var(--space-2) var(--space-4); /* 8px 16px */
```

## Border Radius

| Token | Value | Usage |
|-------|-------|-------|
| `--radius-sm` | 4px | Buttons, inputs |
| `--radius-md` | 6px | Cards, dropdowns |
| `--radius-lg` | 8px | Modals, larger cards |
| `--radius-xl` | 12px | Featured cards |
| `--radius-full` | 9999px | Pills, avatars |

## Shadows

| Token | Value | Usage |
|-------|-------|-------|
| `--shadow-sm` | `0 1px 2px rgba(0,0,0,0.05)` | Subtle elevation |
| `--shadow-md` | `0 4px 6px rgba(0,0,0,0.1)` | Cards, dropdowns |
| `--shadow-lg` | `0 10px 15px rgba(0,0,0,0.1)` | Modals, popovers |
| `--shadow-xl` | `0 20px 25px rgba(0,0,0,0.1)` | Elevated modals |

## Z-Index Scale

| Token | Value | Usage |
|-------|-------|-------|
| `--z-dropdown` | 1000 | Dropdowns, selects |
| `--z-sticky` | 1020 | Sticky headers |
| `--z-fixed` | 1030 | Fixed elements |
| `--z-modal-backdrop` | 1040 | Modal overlays |
| `--z-modal` | 1050 | Modal content |
| `--z-popover` | 1060 | Popovers, tooltips |
| `--z-toast` | 1070 | Toast notifications |

## Breakpoints

| Token | Value | Usage |
|-------|-------|-------|
| `--screen-sm` | 640px | Mobile landscape |
| `--screen-md` | 768px | Tablet |
| `--screen-lg` | 1024px | Desktop |
| `--screen-xl` | 1280px | Large desktop |
| `--screen-2xl` | 1536px | Wide screens |

### Media Query Usage

```css
/* Mobile first approach */
.container {
  padding: var(--space-4);
}

@media (min-width: 768px) {
  .container {
    padding: var(--space-6);
  }
}

@media (min-width: 1024px) {
  .container {
    padding: var(--space-8);
  }
}
```

## Animation

### Timing Functions

| Token | Value | Usage |
|-------|-------|-------|
| `--ease-in` | cubic-bezier(0.4, 0, 1, 1) | Exit animations |
| `--ease-out` | cubic-bezier(0, 0, 0.2, 1) | Enter animations |
| `--ease-in-out` | cubic-bezier(0.4, 0, 0.2, 1) | General transitions |

### Durations

| Token | Value | Usage |
|-------|-------|-------|
| `--duration-fast` | 150ms | Micro-interactions |
| `--duration-normal` | 200ms | Standard transitions |
| `--duration-slow` | 300ms | Complex animations |

### Common Transitions

```css
/* Button hover */
transition: background-color var(--duration-fast) var(--ease-out);

/* Modal enter */
transition: opacity var(--duration-normal) var(--ease-out),
            transform var(--duration-normal) var(--ease-out);

/* Reduced motion */
@media (prefers-reduced-motion: reduce) {
  * {
    animation-duration: 0.01ms !important;
    transition-duration: 0.01ms !important;
  }
}
```

## Dark Mode

### Color Mappings

| Light Mode | Dark Mode |
|------------|-----------|
| `--color-gray-50` (bg) | `--color-gray-900` |
| `--color-gray-900` (text) | `--color-gray-50` |
| `--color-gray-200` (border) | `--color-gray-700` |

### Implementation

```css
:root {
  --bg-primary: var(--color-gray-50);
  --text-primary: var(--color-gray-900);
}

[data-theme="dark"] {
  --bg-primary: var(--color-gray-900);
  --text-primary: var(--color-gray-50);
}
```
