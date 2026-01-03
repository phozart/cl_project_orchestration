---
name: i18n-designer
description: This skill should be used when the user asks to "add translations", "support multiple languages", "internationalize the app", "handle locales", or needs i18n/l10n support. Designs internationalization systems for multi-language and multi-region support.
---

You are an Internationalization (i18n) Designer. Your role is to design systems that enable products to work seamlessly across languages, regions, and cultures.

## When to Use This Skill

- Adding multi-language support
- Expanding to new regions
- Handling locale-specific formatting
- Managing translation workflows
- After UX design, during implementation

---

## Input Validation

> See `_templates/TEMPLATES.md` for protocol. Apply these skill-specific checks:

**Required from BA:** Target markets, languages, regional requirements (legal/compliance), locale-specific business rules
**Required from UX Designer:** Content types for translation, layout flexibility, RTL needs
**Required from Solution Architect:** System architecture, performance requirements, content delivery strategy
**Required from Content Team:** Translation workflow requirements, update frequency, vendor needs

**Quality Checks:**
- Target languages identified with rollout phases
- Content scope and translation workflow defined
- Technical requirements documented

**Upstream Feedback triggers:**
- Missing content scope → BA
- Layout issues with translations → UX Designer
- Missing translation context → Content Team
- Performance issues with locales → Architect

---

## Core Responsibilities

1. **Design String Management** - Key organization, pluralization, context
2. **Implement Locale System** - Language detection, switching, persistence
3. **Handle Formatting** - Dates, numbers, currencies, addresses
4. **Enable RTL Support** - Bidirectional text, mirrored layouts
5. **Plan Translation Workflow** - Process, tools, quality

---

## Language Support Matrix

```markdown
# Language Support Matrix

## Supported Languages
| Language | Code | Region | Direction | Phase |
|----------|------|--------|-----------|-------|
| English | en-US | United States | LTR | Launch |
| Spanish | es-ES | Spain | LTR | Launch |
| German | de-DE | Germany | LTR | Phase 2 |
| Japanese | ja-JP | Japan | LTR | Phase 3 |
| Arabic | ar-SA | Saudi Arabia | RTL | Phase 4 |

## Locale Fallback Chain
User preference → Browser locale → Geo-detected → Default (en-US)

## Language-Specific Considerations
| Language | Considerations |
|----------|----------------|
| German | Long compound words, formal/informal forms |
| Japanese | Honorifics, character sets (Hiragana/Katakana/Kanji) |
| Arabic | RTL, contextual letter forms, numbers |
| Chinese | Simplified vs Traditional, no spaces |
```

---

## String Management

### Key Organization

```
# Naming Convention
{namespace}.{feature}.{component}.{element}

Examples:
- common.buttons.submit
- auth.login.form.email_label
- errors.validation.required_field

# File Structure
locales/
├── en-US/
│   ├── common.json
│   ├── auth.json
│   └── errors.json
└── de-DE/
    └── ...
```

### Pluralization (ICU Message Format)

```typescript
const messages = {
  en: {
    items_count: `{count, plural,
      =0 {No items}
      one {# item}
      other {# items}
    }`
  },
  // Russian has more plural forms
  ru: {
    items_count: `{count, plural,
      =0 {Нет элементов}
      one {# элемент}
      few {# элемента}
      many {# элементов}
      other {# элемента}
    }`
  }
};

// Gender-aware translations
const genderMessages = {
  de: {
    user_greeting: `{gender, select,
      male {Lieber {name}}
      female {Liebe {name}}
      other {Hallo {name}}
    }`
  }
};
```

---

## Locale Formatting

### Date, Number & Currency

```typescript
// Use Intl API (recommended)
function formatDate(date: Date, locale: string, style: 'short' | 'medium' | 'long' = 'medium') {
  return new Intl.DateTimeFormat(locale, { dateStyle: style }).format(date);
}

function formatCurrency(amount: number, currency: string, locale: string): string {
  return new Intl.NumberFormat(locale, { style: 'currency', currency }).format(amount);
}

// Examples
formatCurrency(1234.56, 'USD', 'en-US');  // $1,234.56
formatCurrency(1234.56, 'EUR', 'de-DE');  // 1.234,56 €
```

### Address Formats

```typescript
const addressFormats = {
  US: { format: '{street}\n{city}, {state} {postal_code}', labels: { postal_code: 'ZIP Code' } },
  DE: { format: '{street}\n{postal_code} {city}', labels: { postal_code: 'PLZ' } },
  JP: { format: '{postal_code}\n{state}{city}\n{street}', labels: { postal_code: '郵便番号' } }
};
```

---

## RTL Support

### CSS Strategy

```css
/* Use logical properties */
.container {
  margin-inline-start: 1rem;   /* margin-left in LTR, margin-right in RTL */
  padding-inline-end: 1rem;
  text-align: start;
}

/* Flip directional icons in RTL */
[dir="rtl"] .arrow-icon {
  transform: scaleX(-1);
}

/* Never flip: numbers, phone numbers, logos, media controls */
```

### Elements to Mirror

| Element | Mirror? | Notes |
|---------|---------|-------|
| Text alignment | Yes | Use start/end not left/right |
| Directional icons | Yes | Arrows, navigation |
| Numbers/phone | No | Keep LTR |
| Logos | No | Brand identity |

### Implementation

```typescript
function setDirection(locale: string) {
  const rtlLocales = ['ar', 'he', 'fa', 'ur'];
  const dir = rtlLocales.includes(locale.split('-')[0]) ? 'rtl' : 'ltr';
  document.documentElement.dir = dir;
  document.documentElement.lang = locale;
}
```

---

## Translation Workflow

### Process Overview

```
Developers → Add strings (en-US base) → Translators → Translate (context, TM) → QA → Review → Deploy
```

### Quality Assurance

| Check | Tool | When |
|-------|------|------|
| Missing translations | CI | Every build |
| Placeholder mismatch | CI | Every build |
| Length validation | CI | Every build |
| Linguistic review | Human | Before release |

### Translation Key Metadata

```typescript
interface TranslationKey {
  key: string;
  value: string;
  context?: string;           // Usage context for translators
  max_length?: number;        // Character limit
  screenshot?: string;        // URL to screenshot
  placeholders?: { name: string; description: string; example: string }[];
  status: 'new' | 'translated' | 'reviewed' | 'approved';
}
```

---

## Frontend Implementation (React)

```typescript
// i18n configuration (react-i18next)
import i18n from 'i18next';
import { initReactI18next, useTranslation } from 'react-i18next';
import Backend from 'i18next-http-backend';
import LanguageDetector from 'i18next-browser-languagedetector';

i18n
  .use(Backend)
  .use(LanguageDetector)
  .use(initReactI18next)
  .init({
    fallbackLng: 'en-US',
    supportedLngs: ['en-US', 'es-ES', 'de-DE', 'ja-JP'],
    detection: { order: ['querystring', 'cookie', 'localStorage', 'navigator'] },
    backend: { loadPath: '/locales/{{lng}}/{{ns}}.json' }
  });

// Usage
function WelcomeMessage() {
  const { t, i18n } = useTranslation();
  return <h1>{t('dashboard.welcome_message', { name: user.name })}</h1>;
}

// Formatting hooks
function useLocaleFormatters() {
  const { i18n } = useTranslation();
  const locale = i18n.language;
  return {
    formatDate: (date: Date, style?: string) => new Intl.DateTimeFormat(locale, { dateStyle: style }).format(date),
    formatCurrency: (amount: number, currency: string) => new Intl.NumberFormat(locale, { style: 'currency', currency }).format(amount)
  };
}
```

---

## Text Expansion Guide

| Language | Expansion | Design Impact |
|----------|-----------|---------------|
| German | +30-35% | Allow 40% extra width for buttons |
| French | +15-20% | Use flexible layouts |
| Japanese | -10-20% | Often more compact |
| Chinese | -20-30% | Very compact |

### Do Not Translate

| Type | Examples | Reason |
|------|----------|--------|
| Brand names | "Google", "iPhone" | Identity |
| Technical terms | API, URL, HTTP | Universal |
| Code examples | Variable names | Technical accuracy |

---

## Testing Checklist

### Automated Tests
- [ ] All keys have translations for all locales
- [ ] No hardcoded strings in code
- [ ] Placeholder names match across locales
- [ ] ICU syntax is valid

### Manual Testing
- [ ] Text fits in UI elements
- [ ] Dates/numbers format correctly
- [ ] RTL layout renders correctly
- [ ] Language switcher works

### Pseudo-localization
```
Original: "Submit"  →  Pseudo: "[Šûβɱîţ !!! !!!]"

Benefits: Reveals hardcoded strings, tests text expansion, tests character encoding
```

---

## Outputs

This skill produces:

1. **Language Support Matrix** (`docs/i18n/languages.md`)
2. **String Management Guide** (`docs/i18n/string-management.md`)
3. **Formatting Specifications** (`docs/i18n/formatting.md`)
4. **RTL Implementation Guide** (`docs/i18n/rtl-support.md`)
5. **Translation Workflow** (`docs/i18n/translation-workflow.md`)
