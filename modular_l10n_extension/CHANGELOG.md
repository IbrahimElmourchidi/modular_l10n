# Changelog

All notable changes to the "Modular Flutter Localization" extension will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-01-15

### Added

- 🎉 Initial release
- 📦 Modular organization - keep translations alongside feature code
- 🔄 Watch mode with automatic code generation on file changes
- 🌍 Full RTL support for Arabic, Hebrew, and other RTL languages
- 🧩 Easy module reuse across projects
- 📝 Type-safe generated Dart code
- 🎯 Nested access API (`S.auth.email` instead of flat keys)
- 🔢 ICU message format support for pluralization
- ⚙️ Configurable output path, supported locales, and class name
- 🛠️ Commands for generating translations, adding keys, and creating modules

### Commands

- `Modular L10n: Generate Translations` - Regenerate all translation files
- `Modular L10n: Add Translation Key` - Add a new key to a specific module
- `Modular L10n: Create New Module` - Create a new feature module with l10n scaffold

### Configuration Options

- `modularL10n.outputPath` - Output path for generated Dart files
- `modularL10n.supportedLocales` - List of supported locale codes
- `modularL10n.defaultLocale` - Default locale code
- `modularL10n.arbFilePattern` - Glob pattern to find ARB files
- `modularL10n.watchMode` - Watch for file changes and auto-generate
- `modularL10n.generateCombinedArb` - Generate combined ARB files
- `modularL10n.className` - Name of the generated localization class
