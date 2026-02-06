# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-01-15

### Added

- 🎉 Initial release
- 🌍 **RTL Support**
  - `LocaleUtils.isRtl()` - Check if a locale is RTL
  - `LocaleUtils.getTextDirection()` - Get TextDirection for locale
  - `LocaleUtils.rtlLanguages` - Set of RTL language codes
  - Support for Arabic, Hebrew, Persian, Urdu, and other RTL languages
- 🔄 **LocaleProvider**
  - `LocaleProvider` widget for managing locale state
  - `LocaleProviderState` with `currentLocale`, `setLocale()`, and `isLocale()`
  - BuildContext extensions: `context.currentLocale`, `context.setLocale()`, `context.isLocale()`
- 🛠️ **Locale Utilities**
  - `LocaleUtils.parseLocale()` - Parse locale strings (supports "en", "en_US", "en-US")
  - `LocaleUtils.findBestMatch()` - Find best matching locale from supported list
  - `LocaleUtils.getDisplayName()` - Get English display name for locale
  - `LocaleUtils.getNativeName()` - Get native display name for locale
- 📱 **Locale Extensions**
  - `locale.isRtl` - Check if locale is RTL
  - `locale.textDirection` - Get TextDirection
  - `locale.displayName` - Get English display name
  - `locale.nativeName` - Get native display name
- 📚 **Base Classes**
  - `ModularL10nBase` - Base class for localization
  - `ModuleL10nMixin` - Mixin for module classes

### Supported Languages (Display Names)

Added display names for 40+ languages including:
- Arabic, Bengali, Bulgarian, Chinese, Croatian, Czech
- Danish, Dutch, English, Estonian, Finnish, French
- German, Greek, Gujarati, Hebrew, Hindi, Hungarian
- Indonesian, Italian, Japanese, Kannada, Korean, Latvian
- Lithuanian, Malay, Malayalam, Marathi, Norwegian, Persian
- Polish, Portuguese, Punjabi, Romanian, Russian, Serbian
- Slovak, Slovenian, Spanish, Swedish, Tamil, Telugu
- Thai, Turkish, Ukrainian, Urdu, Vietnamese
