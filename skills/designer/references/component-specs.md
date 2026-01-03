# Component Specifications

## Component State Matrix

Every interactive component must define ALL states:

| State | Description | Visual Changes |
|-------|-------------|----------------|
| Default | Normal resting state | Base styling |
| Hover | Mouse over element | Subtle highlight |
| Focus | Keyboard focus | Visible focus ring |
| Active | Being clicked/pressed | Pressed appearance |
| Disabled | Not interactive | Reduced opacity, no cursor |
| Loading | Async operation | Spinner, reduced opacity |
| Error | Validation failed | Error color, message |

## Button Component

### Variants

| Variant | Usage | Background | Text |
|---------|-------|------------|------|
| Primary | Main actions | primary-500 | white |
| Secondary | Secondary actions | gray-100 | gray-900 |
| Outline | Tertiary actions | transparent | primary-500 |
| Ghost | Minimal emphasis | transparent | gray-600 |
| Destructive | Delete, remove | error | white |

### Sizes

| Size | Height | Padding | Font Size |
|------|--------|---------|-----------|
| sm | 32px | 12px 16px | 14px |
| md | 40px | 12px 20px | 14px |
| lg | 48px | 16px 24px | 16px |

### States

```
Default:    bg-primary-500, text-white
Hover:      bg-primary-600, cursor-pointer
Focus:      ring-2 ring-primary-500 ring-offset-2
Active:     bg-primary-700
Disabled:   opacity-50, cursor-not-allowed
Loading:    opacity-70, spinner visible, text hidden
```

### Specification

```css
.button-primary {
  /* Base */
  background: var(--color-primary-500);
  color: white;
  padding: 12px 20px;
  border-radius: var(--radius-sm);
  font-weight: var(--font-medium);
  font-size: var(--text-sm);
  transition: background var(--duration-fast) var(--ease-out);

  /* States */
  &:hover:not(:disabled) { background: var(--color-primary-600); }
  &:focus-visible { outline: 2px solid var(--color-primary-500); outline-offset: 2px; }
  &:active:not(:disabled) { background: var(--color-primary-700); }
  &:disabled { opacity: 0.5; cursor: not-allowed; }
}
```

## Input Component

### Variants

| Variant | Usage | Border |
|---------|-------|--------|
| Default | Standard input | gray-200 |
| Error | Validation error | error |
| Success | Validated | success |

### States

```
Default:    border-gray-200, bg-white
Hover:      border-gray-300
Focus:      border-primary-500, ring-1 ring-primary-500
Error:      border-error, text-error (message below)
Disabled:   bg-gray-100, cursor-not-allowed
```

### Specification

```css
.input {
  /* Base */
  border: 1px solid var(--color-gray-200);
  border-radius: var(--radius-sm);
  padding: 10px 12px;
  font-size: var(--text-sm);
  background: white;
  transition: border-color var(--duration-fast);

  /* States */
  &:hover:not(:disabled):not(:focus) { border-color: var(--color-gray-300); }
  &:focus { border-color: var(--color-primary-500); box-shadow: 0 0 0 1px var(--color-primary-500); outline: none; }
  &:disabled { background: var(--color-gray-100); cursor: not-allowed; }
  &[aria-invalid="true"] { border-color: var(--color-error); }
}
```

### Anatomy

```
┌─────────────────────────────────────┐
│ Label *                              │ ← Label (optional asterisk for required)
├─────────────────────────────────────┤
│ ┌─────────────────────────────────┐ │
│ │ [icon] Placeholder text...      │ │ ← Input with optional leading icon
│ └─────────────────────────────────┘ │
│ Helper text or error message        │ ← Helper/Error text
└─────────────────────────────────────┘
```

## Card Component

### Variants

| Variant | Usage | Styling |
|---------|-------|---------|
| Default | Standard card | border, subtle shadow |
| Elevated | Emphasized | larger shadow |
| Outlined | Minimal | border only |
| Interactive | Clickable | hover state |

### Specification

```css
.card {
  background: white;
  border: 1px solid var(--color-gray-200);
  border-radius: var(--radius-md);
  padding: var(--space-5);

  &.elevated {
    border: none;
    box-shadow: var(--shadow-md);
  }

  &.interactive {
    cursor: pointer;
    transition: box-shadow var(--duration-fast);
    &:hover { box-shadow: var(--shadow-lg); }
  }
}
```

## Modal Component

### Sizes

| Size | Max Width | Usage |
|------|-----------|-------|
| sm | 400px | Confirmations |
| md | 560px | Forms |
| lg | 720px | Complex content |
| full | 100% - 48px | Full-screen |

### Anatomy

```
┌────────────────────────────────────────┐
│ ┌────────────────────────────────────┐ │
│ │ Title                          [×] │ │ ← Header with close button
│ ├────────────────────────────────────┤ │
│ │                                    │ │
│ │         Modal Content              │ │ ← Scrollable content area
│ │                                    │ │
│ ├────────────────────────────────────┤ │
│ │              [Cancel] [Confirm]    │ │ ← Footer with actions
│ └────────────────────────────────────┘ │
└────────────────────────────────────────┘
  ↑ Backdrop (semi-transparent overlay)
```

### Animation

```css
/* Backdrop */
.modal-backdrop {
  opacity: 0;
  transition: opacity var(--duration-normal) var(--ease-out);
  &.open { opacity: 1; }
}

/* Modal */
.modal {
  opacity: 0;
  transform: scale(0.95);
  transition: opacity var(--duration-normal) var(--ease-out),
              transform var(--duration-normal) var(--ease-out);
  &.open { opacity: 1; transform: scale(1); }
}
```

## Toast/Notification Component

### Variants

| Variant | Icon | Background |
|---------|------|------------|
| Success | ✓ | success-50 |
| Error | ✕ | error-50 |
| Warning | ⚠ | warning-50 |
| Info | ℹ | info-50 |

### Specification

```css
.toast {
  padding: var(--space-3) var(--space-4);
  border-radius: var(--radius-md);
  box-shadow: var(--shadow-lg);
  display: flex;
  align-items: center;
  gap: var(--space-3);

  /* Animation */
  animation: slideIn var(--duration-normal) var(--ease-out);
}

@keyframes slideIn {
  from { transform: translateX(100%); opacity: 0; }
  to { transform: translateX(0); opacity: 1; }
}
```

## Table Component

### Anatomy

```
┌───────────────────────────────────────────────────┐
│ [Search...        ]  [Filter ▼] [+ Add New]       │ ← Toolbar
├───────────────────────────────────────────────────┤
│ □ Name ↕        Email              Role    Actions│ ← Header (sortable)
├───────────────────────────────────────────────────┤
│ □ John Doe      john@example.com   Admin   [···]  │ ← Row
│ □ Jane Smith    jane@example.com   User    [···]  │
│ □ Bob Wilson    bob@example.com    User    [···]  │
├───────────────────────────────────────────────────┤
│ Showing 1-10 of 156        [<] [1] [2] [3] [>]    │ ← Pagination
└───────────────────────────────────────────────────┘
```

### Row States

```
Default:    bg-white
Hover:      bg-gray-50
Selected:   bg-primary-50, border-left primary-500
```

## Form Component

### Field Spacing

```
Label
  ↓ 6px
Input
  ↓ 4px
Helper text
  ↓ 16px
Next field
```

### Validation States

| State | Border | Icon | Message Color |
|-------|--------|------|---------------|
| Default | gray-200 | none | gray-500 |
| Error | error | ✕ | error |
| Success | success | ✓ | success |
| Warning | warning | ⚠ | warning |

### Required Field Indicator

```
Label *        ← Asterisk in error color
[Input field]
```

## Skeleton/Loading Component

### Usage

Replace content with animated placeholders during loading:

```
┌────────────────────────────────────┐
│ [████████████]                     │ ← Title skeleton
│ [████████████████████████████]     │ ← Text skeleton
│ [█████████████████]                │ ← Shorter text
│                                    │
│ [██████████] [██████████]          │ ← Button skeletons
└────────────────────────────────────┘
```

### Animation

```css
.skeleton {
  background: linear-gradient(
    90deg,
    var(--color-gray-200) 0%,
    var(--color-gray-100) 50%,
    var(--color-gray-200) 100%
  );
  background-size: 200% 100%;
  animation: shimmer 1.5s infinite;
  border-radius: var(--radius-sm);
}

@keyframes shimmer {
  0% { background-position: 200% 0; }
  100% { background-position: -200% 0; }
}
```

## Empty State Component

### Anatomy

```
       ┌─────────────┐
       │   [icon]    │
       └─────────────┘

    No items found

  Try adjusting your filters
  or create a new item.

      [Create Item]
```

### Usage Guidelines

- Use relevant icon (empty box, search, etc.)
- Primary message: What's empty
- Secondary message: What user can do
- Action button: Primary action to resolve
