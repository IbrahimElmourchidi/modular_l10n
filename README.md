# modular_l10n

<p align="center">
  <a href="https://pub.dev/packages/modular_l10n">
    <img src="https://img.shields.io/pub/v/modular_l10n.svg?style=flat-square" alt="Pub Version">
  </a>
  <a href="https://pub.dev/packages/modular_l10n/score">
    <img src="https://img.shields.io/pub/points/modular_l10n?style=flat-square" alt="Pub Points">
  </a>
  <a href="https://pub.dev/packages/modular_l10n">
    <img src="https://img.shields.io/pub/popularity/modular_l10n?style=flat-square" alt="Popularity">
  </a>
  <a href="https://github.com/IbrahimElmourchidi/modular_l10n/blob/main/LICENSE">
    <img src="https://img.shields.io/github/license/IbrahimElmourchidi/modular_l10n?style=flat-square" alt="License">
  </a>
</p>

<p align="center">
  <b>Runtime utilities for modular Flutter localization with full RTL support.</b>
</p>

---

## ✨ Features

| Feature | Description |
|---------|-------------|
| 🌍 **RTL Support** | Built-in detection for Arabic, Hebrew, Urdu, and other RTL languages |
| 🔄 **LocaleProvider** | Easy runtime locale switching with InheritedWidget |
| 🛠️ **Locale Utilities** | Parse, match, and get display names for locales |
| 📱 **Cross-Platform** | Works on Android, iOS, Web, macOS, Windows, and Linux |

## 📦 Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  modular_l10n: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## 🚀 Quick Start

### 1. Wrap Your App with LocaleProvider

```dart
import 'package:flutter/material.dart';
import 'package:modular_l10n/modular_l10n.dart';
import 'generated/l10n/l10n.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en');

  @override
  Widget build(BuildContext context) {
    return LocaleProvider(
      initialLocale: _locale,
      onBeforeLocaleChanged: (locale) => S.load(locale),
      onLocaleChanged: (locale) {
        setState(() => _locale = locale);
      },
      child: MaterialApp(
        locale: _locale,
        supportedLocales: S.supportedLocales,
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        // Handle text direction for RTL languages
        builder: (context, child) {
          return Directionality(
            textDirection: LocaleUtils.getTextDirection(_locale),
            child: child!,
          );
        },
        home: const HomePage(),
      ),
    );
  }
}
```

### 2. Change Locale from Anywhere

```dart
class LanguageSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Locale>(
      icon: const Icon(Icons.language),
      onSelected: (locale) {
        // Change locale using context extension
        context.setLocale(locale);
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: Locale('en'),
          child: Text('English'),
        ),
        const PopupMenuItem(
          value: Locale('ar'),
          child: Text('العربية'),
        ),
      ],
    );
  }
}
```

### 3. Check Current Locale

```dart
// Get current locale
Locale current = context.currentLocale;

// Check if current locale is Arabic
if (context.isLocale('ar')) {
  // Handle Arabic-specific logic
}
```

## 🌐 RTL Support

### Check if Locale is RTL

```dart
import 'package:modular_l10n/modular_l10n.dart';

// Using static method
if (LocaleUtils.isRtl(locale)) {
  // Handle RTL layout
}

// Using extension
if (locale.isRtl) {
  // Handle RTL layout
}
```

### Get Text Direction

```dart
// Using static method
TextDirection direction = LocaleUtils.getTextDirection(locale);

// Using extension
TextDirection direction = locale.textDirection;
```

### Supported RTL Languages

The package automatically detects these RTL languages:

| Code | Language |
|------|----------|
| `ar` | Arabic |
| `fa` | Persian/Farsi |
| `he` | Hebrew |
| `ur` | Urdu |
| `ps` | Pashto |
| `sd` | Sindhi |
| `yi` | Yiddish |
| `ku` | Kurdish (Sorani) |
| `ug` | Uyghur |
| `dv` | Divehi |

## 🛠️ Locale Utilities

### Parse Locale String

```dart
// Supports multiple formats
Locale locale1 = LocaleUtils.parseLocale('en');      // Locale('en')
Locale locale2 = LocaleUtils.parseLocale('en_US');   // Locale('en', 'US')
Locale locale3 = LocaleUtils.parseLocale('en-US');   // Locale('en', 'US')
```

### Find Best Matching Locale

```dart
final supportedLocales = [Locale('en'), Locale('ar'), Locale('de')];
final deviceLocale = Locale('ar', 'EG');

Locale? match = LocaleUtils.findBestMatch(deviceLocale, supportedLocales);
// Returns Locale('ar')
```

### Get Locale Display Names

```dart
Locale locale = Locale('ar');

// English name
String displayName = locale.displayName;     // "Arabic"

// Native name
String nativeName = locale.nativeName;       // "العربية"

// Or using static methods
String displayName = LocaleUtils.getDisplayName(locale);
String nativeName = LocaleUtils.getNativeName(locale);
```

## 📖 API Reference

### LocaleProvider

A widget that provides locale state to the widget tree.

```dart
LocaleProvider({
  required Locale initialLocale,
  required Widget child,
  ValueChanged<Locale>? onLocaleChanged,
})
```

### LocaleProviderState

| Method | Description |
|--------|-------------|
| `currentLocale` | Get the current locale |
| `setLocale(Locale)` | Change the current locale |
| `isLocale(String)` | Check if current locale matches a language code |

### BuildContext Extensions

| Extension | Description |
|-----------|-------------|
| `context.currentLocale` | Get current locale from LocaleProvider |
| `context.setLocale(Locale)` | Set locale via LocaleProvider |
| `context.isLocale(String)` | Check if current locale matches |

### LocaleUtils

| Method | Description |
|--------|-------------|
| `isRtl(Locale)` | Check if locale is RTL |
| `getTextDirection(Locale)` | Get TextDirection for locale |
| `parseLocale(String)` | Parse locale string to Locale |
| `findBestMatch(Locale, List<Locale>)` | Find best matching locale |
| `getDisplayName(Locale)` | Get English display name |
| `getNativeName(Locale)` | Get native display name |

### Locale Extensions

| Extension | Description |
|-----------|-------------|
| `locale.isRtl` | Check if locale is RTL |
| `locale.textDirection` | Get TextDirection |
| `locale.displayName` | Get English display name |
| `locale.nativeName` | Get native display name |

## 🔗 VS Code Extension

This package is designed to work with the [Modular Flutter Localization](https://marketplace.visualstudio.com/items?itemName=utanium.modular-flutter-l10n) VS Code extension.

The extension provides:
- Automatic code generation from ARB files
- Watch mode for instant regeneration
- Commands to add keys and create modules
- Modular organization by feature

## 📁 Complete Example

See the [example](https://github.com/IbrahimElmourchidi/modular_l10n/tree/main/example) directory for a complete sample application.

## 🐛 Issues & Contributions

Found a bug or have a feature request?

- [Report an issue](https://github.com/IbrahimElmourchidi/modular_l10n/issues)
- [Contribute on GitHub](https://github.com/IbrahimElmourchidi/modular_l10n)

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/IbrahimElmourchidi/modular_l10n/blob/main/LICENSE) file for details.

---

<p align="center">
  Made with ❤️ by <a href="https://ibrahim.utanium.org">Utanium</a>
</p>
