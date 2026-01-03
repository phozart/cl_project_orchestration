# Interaction Specifications

## Response Time Guidelines

| Category | Target | Example |
|----------|--------|---------|
| Instant | < 100ms | Button state change, toggle |
| Fast | < 300ms | Dropdown open, tooltip appear |
| Standard | < 1000ms | Page navigation, form submit |
| Extended | > 1000ms | File upload, complex operations |

## Feedback Patterns

### Immediate Feedback (< 100ms)

No loading indicator needed. Provide visual state change:

```
Button Click:
  ├─ Immediately: Active state (pressed appearance)
  ├─ On release: Return to hover/default
  └─ Result: Action happens instantly
```

### Fast Operations (100ms - 300ms)

Subtle indication acceptable:

```
Toggle Switch:
  ├─ Immediately: Begin animation
  ├─ 200ms: Animation completes
  └─ Result: New state visible
```

### Standard Operations (300ms - 1000ms)

Show progress indicator:

```
Form Submit:
  ├─ Immediately: Button shows loading spinner
  ├─ Disable further interaction
  ├─ On complete: Show success/error state
  └─ Auto-dismiss after 3 seconds
```

### Extended Operations (> 1000ms)

Show progress with context:

```
File Upload:
  ├─ Immediately: Progress bar appears (0%)
  ├─ During: Progress bar updates, show percentage
  ├─ On complete: Success message with preview
  └─ On error: Error message with retry option
```

## Loading States

### Spinner

Use for:
- Button loading
- Inline loading
- Small components

```css
.spinner {
  width: 20px;
  height: 20px;
  border: 2px solid var(--color-gray-200);
  border-top-color: var(--color-primary-500);
  border-radius: 50%;
  animation: spin 0.8s linear infinite;
}
```

### Skeleton

Use for:
- Content loading
- Page sections
- Lists and tables

Replace each content element with a skeleton of similar size.

### Progress Bar

Use for:
- File uploads
- Multi-step processes
- Known-duration operations

```
[████████████░░░░░░░░] 60%
```

### Overlay

Use for:
- Full-page operations
- Modal submissions
- Blocking operations

```
┌─────────────────────────────┐
│                             │
│      [Spinner]              │
│      Processing...          │
│                             │
└─────────────────────────────┘
```

## Success/Error Feedback

### Success Patterns

| Context | Feedback |
|---------|----------|
| Form submit | Toast notification + redirect |
| Inline action | Checkmark icon + text |
| Delete action | Item removal + undo toast |
| Save action | "Saved" indicator near save button |

### Error Patterns

| Context | Feedback |
|---------|----------|
| Form validation | Inline errors below fields |
| API error | Toast with error message |
| Network error | Banner with retry option |
| Permission denied | Modal explaining issue |

### Error Message Guidelines

```
✓ GOOD: "Email address is already registered"
✗ BAD:  "Error 409"

✓ GOOD: "Couldn't save changes. Check your connection and try again."
✗ BAD:  "Network error"

✓ GOOD: "Password must be at least 8 characters"
✗ BAD:  "Invalid password"
```

## Confirmation Patterns

### When to Confirm

| Action | Confirmation |
|--------|--------------|
| Delete item | Yes - destructive |
| Cancel form with changes | Yes - data loss |
| Log out | Optional |
| Submit form | No - reversible |
| Toggle setting | No - reversible |

### Confirmation Dialog

```
┌────────────────────────────────────┐
│ Delete this item?                  │
├────────────────────────────────────┤
│ This action cannot be undone.      │
│ The item will be permanently       │
│ removed from your account.         │
├────────────────────────────────────┤
│         [Cancel]  [Delete]         │
└────────────────────────────────────┘
```

Guidelines:
- Title: Action being taken
- Body: Consequence of action
- Primary button: Matches action (Delete, Remove, etc.)
- Destructive actions: Red button color

## Animation Specifications

### Easing Functions

| Function | Usage |
|----------|-------|
| ease-out | Enter animations, appearing elements |
| ease-in | Exit animations, disappearing elements |
| ease-in-out | Moving elements, transforms |
| linear | Progress indicators, spinners |

### Standard Animations

**Fade In**
```css
@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}
/* Duration: 200ms, Easing: ease-out */
```

**Slide Up**
```css
@keyframes slideUp {
  from { opacity: 0; transform: translateY(10px); }
  to { opacity: 1; transform: translateY(0); }
}
/* Duration: 200ms, Easing: ease-out */
```

**Scale In**
```css
@keyframes scaleIn {
  from { opacity: 0; transform: scale(0.95); }
  to { opacity: 1; transform: scale(1); }
}
/* Duration: 200ms, Easing: ease-out */
```

**Slide In Right (Toast)**
```css
@keyframes slideInRight {
  from { transform: translateX(100%); opacity: 0; }
  to { transform: translateX(0); opacity: 1; }
}
/* Duration: 300ms, Easing: ease-out */
```

### Reduced Motion

Always provide reduced motion alternative:

```css
@media (prefers-reduced-motion: reduce) {
  *,
  *::before,
  *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
  }
}
```

## Hover and Focus States

### Hover Guidelines

| Element | Hover Effect |
|---------|--------------|
| Buttons | Background color shift |
| Links | Underline or color change |
| Cards | Subtle shadow increase |
| Table rows | Background highlight |
| Icons | Opacity or color change |

### Focus Guidelines

| Element | Focus Effect |
|---------|--------------|
| Buttons | 2px outline, offset 2px |
| Inputs | Border color + ring |
| Links | Outline (same as buttons) |
| Cards (clickable) | Ring around card |

```css
/* Standard focus ring */
:focus-visible {
  outline: 2px solid var(--color-primary-500);
  outline-offset: 2px;
}

/* Input focus */
input:focus {
  border-color: var(--color-primary-500);
  box-shadow: 0 0 0 1px var(--color-primary-500);
  outline: none;
}
```

## Touch Interactions

### Touch Target Sizes

| Element | Minimum Size |
|---------|--------------|
| Buttons | 44px × 44px |
| Links (inline) | 44px height, natural width |
| Icons | 44px × 44px touch area |
| Form inputs | 44px height |

### Touch Feedback

```css
/* Tap highlight for touch devices */
.touchable {
  -webkit-tap-highlight-color: rgba(0, 0, 0, 0.1);
}

/* Active state on touch */
.button:active {
  transform: scale(0.98);
}
```

## Scroll Behavior

### Smooth Scrolling

```css
html {
  scroll-behavior: smooth;
}

@media (prefers-reduced-motion: reduce) {
  html {
    scroll-behavior: auto;
  }
}
```

### Scroll Indicators

Show scroll indicators when content overflows:

```
┌─────────────────────────────┐
│ Content                     │
│ More content                │
│ Even more content           │
│                             │
│                           ▼ │ ← Scroll indicator
└─────────────────────────────┘
```

### Infinite Scroll

```
[Item 1]
[Item 2]
[Item 3]
...
[Item 10]
[Loading more...] ← Triggered when visible
[Item 11]
[Item 12]
...
```

## Drag and Drop

### Visual Feedback

| State | Visual |
|-------|--------|
| Draggable | Grab cursor, subtle lift on hover |
| Dragging | Elevated shadow, reduced opacity |
| Drop target (valid) | Highlighted border/background |
| Drop target (invalid) | No highlight or red indicator |

### Drag Handle

```
┌──────────────────────────────┐
│ ⋮⋮ Item content              │
└──────────────────────────────┘
  ↑ Drag handle (6 dots)
```
