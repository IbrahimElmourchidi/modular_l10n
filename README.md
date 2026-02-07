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
  <b>Lightweight runtime utilities for Flutter localization with full RTL support.</b>
</p>

---

## 🎯 Use This Package Standalone or With the Extension

This package provides **valuable locale utilities for ANY Flutter app** - no extension required!

### ✅ Works Standalone (Without Extension)

Perfect for projects already using `flutter_localizations` or any localization solution:

| Feature | Benefit |
|---------|---------|
| **RTL Detection** | Detect Arabic, Hebrew, Urdu, and 7 other RTL languages |
| **Locale Parsing** | Parse locale strings like `en_US`, `zh_Hans_CN`, `sr_Latn_RS` |
| **Best Match Algorithm** | Find closest supported locale from device locale |
| **Display Names** | Get language names in English and native scripts (70+ languages) |
| **Text Direction** | Easily get `TextDirection.rtl` or `TextDirection.ltr` |
| **Zero Dependencies** | No external packages - just pure Dart utilities |
| **High Performance** | Static methods with O(1) lookups using const data |
```dart
// Use with any localization solution
if (locale.isRtl) {
  // Handle RTL layout
}

print(locale.nativeName); // "العربية" for Arabic
final best = LocaleUtils.findBestMatch(deviceLocale, supportedLocales);
```

### 🚀 Extra Power With the VS Code Extension

Pair with the **[Modular Flutter Localization Extension](https://marketplace.visualstudio.com/items?itemName=UtaniumOrg.modular-flutter-l10n)** for a complete localization solution:

| Extension Feature | What You Get |
|------------------|--------------|
| **Code Generation** | Generates type-safe `ML` class from ARB files |
| **Modular Organization** | Organize translations by feature/module |
| **Auto-Regeneration** | Watch mode - changes to ARB files instantly update code |
| **ICU Message Support** | Plurals, select, gender, and complex messages |
| **Extract to ARB** | Right-click strings in code to extract them |
| **Multi-locale Management** | Easy commands to add/remove locales |
```dart
// With extension - type-safe translations
Text(ML.of(context).auth.emailLabel)
Text(ML.of(context).home.welcomeMessage)

// With extension + this package - RTL support
Directionality(
  textDirection: ML.of(context).locale.textDirection, // From this package!
  child: child,
)
```

**Both together = The best of both worlds!**

---

## Features

| Feature | Description |
|---------|-------------|
| **RTL Support** | Built-in detection for Arabic, Hebrew, Urdu, and other RTL languages |
| **Locale Utilities** | Parse, match, and get display names for locales |
| **Zero Dependencies** | Lightweight with no external dependencies |
| **Zero Performance Impact** | All utilities are static with const data structures |
| **Cross-Platform** | Works on Android, iOS, Web, macOS, Windows, and Linux |
| **Standalone or Paired** | Use alone or with the VS Code extension |

## Installation

Add to your `pubspec.yaml`:
```yaml
dependencies:
  modular_l10n: ^1.0.0
```

Then run:
```bash
flutter pub get
```

**Optional but Recommended:**
- Install the **[Modular Flutter Localization VS Code Extension](https://marketplace.visualstudio.com/items?itemName=UtaniumOrg.modular-flutter-l10n)** for automatic code generation

## Quick Start

### Standalone Usage (Any Localization Solution)
```dart
import 'package:modular_l10n/modular_l10n.dart';

// RTL Detection
if (LocaleUtils.isRtl(const Locale('ar'))) {
  // Arabic is RTL
}

// Parse locale strings
final locale = LocaleUtils.parseLocale('zh_Hans_CN');
// Returns: Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans', countryCode: 'CN')

// Get display names
print(const Locale('ar').displayName); // "Arabic"
print(const Locale('ar').nativeName);  // "العربية"

// Find best match for device locale
final deviceLocale = WidgetsBinding.instance.window.locale;
final supportedLocales = [Locale('en'), Locale('ar'), Locale('de')];
final bestMatch = LocaleUtils.findBestMatch(deviceLocale, supportedLocales);

// Use text direction in widgets
Directionality(
  textDirection: locale.textDirection,
  child: YourWidget(),
)
```

### With Flutter Intl / flutter_gen
```dart
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:modular_l10n/modular_l10n.dart';

MaterialApp(
  locale: currentLocale,
  supportedLocales: AppLocalizations.supportedLocales,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  builder: (context, child) {
    // Use this package's utilities!
    return Directionality(
      textDirection: currentLocale.textDirection, // ← From modular_l10n
      child: child!,
    );
  },
  home: HomePage(),
)

// Build a locale switcher
DropdownButton<Locale>(
  items: AppLocalizations.supportedLocales.map((locale) {
    return DropdownMenuItem(
      value: locale,
      child: Row(
        children: [
          Text(locale.nativeName), // ← From modular_l10n
          if (locale.isRtl)        // ← From modular_l10n
            Icon(Icons.format_textdirection_r_to_l),
        ],
      ),
    );
  }).toList(),
  onChanged: (locale) => changeLocale(locale),
)
```

### With the Modular Flutter L10n Extension
```dart
import 'package:modular_l10n/modular_l10n.dart';
import 'generated/modular_l10n/ml.dart'; // Generated by extension

// Type-safe translations from extension + utilities from package
Text(ML.of(context).auth.emailLabel)
Text(ML.of(context).home.welcomeMessage)

MaterialApp(
  locale: currentLocale,
  supportedLocales: ML.supportedLocales, // From extension
  localizationsDelegates: [
    ML.delegate, // From extension
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  builder: (context, child) {
    // Combine both!
    return Directionality(
      textDirection: currentLocale.textDirection, // From this package
      child: child!,
    );
  },
  home: HomePage(),
)
```

## RTL Support

### Supported RTL Languages

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

### Check if Locale is RTL
```dart
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

// In widgets
Directionality(
  textDirection: locale.textDirection,
  child: child,
)
```

## Locale Utilities

### Parse Locale Strings

Supports various locale formats:
```dart
LocaleUtils.parseLocale('en');         // Locale('en')
LocaleUtils.parseLocale('en_US');      // Locale('en', 'US')
LocaleUtils.parseLocale('en-US');      // Locale('en', 'US')
LocaleUtils.parseLocale('zh_Hans');    // Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans')
LocaleUtils.parseLocale('zh_Hans_CN'); // Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans', countryCode: 'CN')
LocaleUtils.parseLocale('sr_Latn_RS'); // Locale.fromSubtags(languageCode: 'sr', scriptCode: 'Latn', countryCode: 'RS')
```

### Find Best Matching Locale

Uses a priority-based matching algorithm:

1. Exact match (language + country + script)
2. Language + country match
3. Language-only match
```dart
final supportedLocales = [
  Locale('en'),
  Locale('en', 'GB'),
  Locale('ar'),
  Locale('ar', 'EG'),
  Locale('de'),
];

// Exact match
LocaleUtils.findBestMatch(Locale('en', 'GB'), supportedLocales);
// Returns Locale('en', 'GB')

// Language match (no exact country)
LocaleUtils.findBestMatch(Locale('ar', 'SA'), supportedLocales);
// Returns Locale('ar')

// No match
LocaleUtils.findBestMatch(Locale('fr'), supportedLocales);
// Returns null
```

### Get Locale Display Names

The package includes display names for 70+ languages:
```dart
Locale locale = const Locale('ar');

// English name
String displayName = locale.displayName;  // "Arabic"

// Native name
String nativeName = locale.nativeName;    // "العربية"
```

**Examples:**
- `en` → "English" / "English"
- `ar` → "Arabic" / "العربية"
- `zh` → "Chinese" / "中文"
- `ja` → "Japanese" / "日本語"
- `ru` → "Russian" / "Русский"
- `hi` → "Hindi" / "हिन्दी"

## Integration Examples

### With StatefulWidget (Simple)
```dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:modular_l10n/modular_l10n.dart';
import 'generated/modular_l10n/ml.dart'; // If using extension

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en');

  @override
  void initState() {
    super.initState();
    _initLocale();
  }

  Future<void> _initLocale() async {
    // Use package utilities to find best match
    final deviceLocale = WidgetsBinding.instance.window.locale;
    final bestMatch = LocaleUtils.findBestMatch(
      deviceLocale,
      ML.supportedLocales,
    );
    
    final initialLocale = bestMatch ?? ML.supportedLocales.first;
    await ML.load(initialLocale);
    
    setState(() => _locale = initialLocale);
  }

  Future<void> _changeLocale(Locale locale) async {
    await ML.load(locale);
    setState(() => _locale = locale);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: _locale,
      supportedLocales: ML.supportedLocales,
      localizationsDelegates: const [
        ML.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) {
        // Use package utilities for text direction
        return Directionality(
          textDirection: _locale.textDirection,
          child: child!,
        );
      },
      home: HomePage(onLocaleChange: _changeLocale),
    );
  }
}
```

### With Provider
```dart
import 'package:provider/provider.dart';
import 'package:modular_l10n/modular_l10n.dart';

class LocaleNotifier extends ChangeNotifier {
  Locale _locale = const Locale('en');
  Locale get locale => _locale;

  Future<void> setLocale(Locale locale) async {
    await ML.load(locale);
    _locale = locale;
    notifyListeners();
  }
}

// In your main.dart
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => LocaleNotifier(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleNotifier>(
      builder: (context, localeNotifier, _) {
        return MaterialApp(
          locale: localeNotifier.locale,
          supportedLocales: ML.supportedLocales,
          localizationsDelegates: const [
            ML.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          builder: (context, child) {
            return Directionality(
              textDirection: localeNotifier.locale.textDirection,
              child: child!,
            );
          },
          home: const HomePage(),
        );
      },
    );
  }
}

// Change locale from anywhere
Provider.of<LocaleNotifier>(context, listen: false)
    .setLocale(const Locale('ar'));
```

### With Riverpod
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modular_l10n/modular_l10n.dart';

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('en'));

  Future<void> setLocale(Locale locale) async {
    await ML.load(locale);
    state = locale;
  }
}

// In your app
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    
    return MaterialApp(
      locale: currentLocale,
      supportedLocales: ML.supportedLocales,
      localizationsDelegates: const [
        ML.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) {
        return Directionality(
          textDirection: currentLocale.textDirection,
          child: child!,
        );
      },
      home: const HomePage(),
    );
  }
}

// Change locale from anywhere
ref.read(localeProvider.notifier).setLocale(const Locale('ar'));
```

### With Bloc/Cubit
```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modular_l10n/modular_l10n.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(const Locale('en'));

  Future<void> setLocale(Locale locale) async {
    await ML.load(locale);
    emit(locale);
  }
}

// In your main.dart
void main() {
  runApp(
    BlocProvider(
      create: (_) => LocaleCubit(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, Locale>(
      builder: (context, locale) {
        return MaterialApp(
          locale: locale,
          supportedLocales: ML.supportedLocales,
          localizationsDelegates: const [
            ML.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          builder: (context, child) {
            return Directionality(
              textDirection: locale.textDirection,
              child: child!,
            );
          },
          home: const HomePage(),
        );
      },
    );
  }
}

// Change locale from anywhere
context.read<LocaleCubit>().setLocale(const Locale('ar'));
```

## Locale Switcher Widget Example
```dart
class LocaleSwitcher extends StatelessWidget {
  final Locale currentLocale;
  final List<Locale> supportedLocales;
  final ValueChanged<Locale> onLocaleChanged;

  const LocaleSwitcher({
    super.key,
    required this.currentLocale,
    required this.supportedLocales,
    required this.onLocaleChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Locale>(
      value: currentLocale,
      items: supportedLocales.map((locale) {
        return DropdownMenuItem(
          value: locale,
          child: Row(
            children: [
              // Native name from this package
              Text(locale.nativeName),
              const SizedBox(width: 8),
              // RTL indicator from this package
              if (locale.isRtl)
                const Icon(Icons.format_textdirection_r_to_l, size: 16),
            ],
          ),
        );
      }).toList(),
      onChanged: (locale) {
        if (locale != null) {
          onLocaleChanged(locale);
        }
      },
    );
  }
}

// Use with any localization solution
LocaleSwitcher(
  currentLocale: currentLocale,
  supportedLocales: ML.supportedLocales, // or your own list
  onLocaleChanged: (locale) => changeLocale(locale),
)
```

## API Reference

### LocaleUtils

Static utility class for locale operations.

| Method | Description | Return Type |
|--------|-------------|-------------|
| `isRtl(Locale)` | Check if locale is RTL | `bool` |
| `getTextDirection(Locale)` | Get TextDirection for locale | `TextDirection` |
| `parseLocale(String)` | Parse locale string to Locale | `Locale` |
| `findBestMatch(Locale, List<Locale>)` | Find best matching locale | `Locale?` |
| `getDisplayName(Locale)` | Get English display name | `String` |
| `getNativeName(Locale)` | Get native display name | `String` |

**Properties:**

| Property | Description | Type |
|----------|-------------|------|
| `rtlLanguages` | Set of RTL language codes | `Set<String>` |

### Locale Extensions

Convenient extension methods on the `Locale` class.

| Extension | Description | Return Type |
|-----------|-------------|-------------|
| `locale.isRtl` | Check if locale is RTL | `bool` |
| `locale.textDirection` | Get TextDirection | `TextDirection` |
| `locale.displayName` | Get English display name | `String` |
| `locale.nativeName` | Get native display name | `String` |

## Performance

This package has **zero performance overhead**:

- ✅ All methods are static (no object instantiation)
- ✅ Language maps are const (compile-time constants)
- ✅ RTL check is O(1) Set lookup
- ✅ No external dependencies
- ✅ No runtime state management

## VS Code Extension (Optional)

Want more than just utilities? The **[Modular Flutter Localization VS Code Extension](https://marketplace.visualstudio.com/items?itemName=UtaniumOrg.modular-flutter-l10n)** adds:

### Extension-Only Features

| Feature | Description |
|---------|-------------|
| **Type-Safe Code Generation** | Generates `ML` class with autocomplete for all translations |
| **Modular Organization** | Organize translations by feature (auth, home, profile, etc.) |
| **Watch Mode** | Auto-regenerate code when ARB files change |
| **ICU Messages** | Full support for plurals, select, gender, date/number formatting |
| **Extract to ARB** | Right-click strings in code to move them to ARB files |
| **CLI Commands** | Add/remove locales, create modules, migrate from Flutter Intl |
| **ARB Validation** | Real-time validation of ARB file syntax |

### How They Work Together

| Component | What It Does |
|-----------|--------------|
| **This Package** | Runtime utilities (RTL, parsing, display names) - works anywhere |
| **VS Code Extension** | Code generation from ARB files - creates type-safe `ML` class |
| **Together** | Complete localization solution with utilities AND type-safe translations |
```dart
// This package alone (utilities)
if (locale.isRtl) { /* ... */ }
print(locale.nativeName);

// With extension (type-safe translations)
Text(ML.of(context).auth.emailLabel)

// Together (best of both)
Directionality(
  textDirection: ML.of(context).locale.textDirection, // This package!
  child: Text(ML.of(context).auth.emailLabel),        // Extension!
)
```

**[👉 Get the VS Code Extension](https://marketplace.visualstudio.com/items?itemName=UtaniumOrg.modular-flutter-l10n)**

## Philosophy

This package **does NOT handle locale switching or state management**. It only provides information about locales. Handle locale switching using your preferred state management solution (Provider, Riverpod, Bloc, GetX, etc.).

**Why?**
- You know your app's architecture best
- No vendor lock-in to a specific state management solution
- Keeps the package lightweight and focused
- You maintain full control

## Migration from Version 0.x

If you're upgrading from version 0.x which included `LocaleProvider`, please see the [Migration Guide](https://github.com/IbrahimElmourchidi/modular_l10n/blob/main/MIGRATION.md).

**Key Changes:**
- ❌ Removed `LocaleProvider` widget (use your own state management)
- ❌ Removed `context.setLocale()` extension
- ✅ Kept all locale utilities (RTL, parsing, display names)
- ✅ Added comprehensive documentation
- ✅ Added 100+ unit tests

## Examples

See the [example](https://github.com/IbrahimElmourchidi/modular_l10n/tree/main/example) directory for complete working apps demonstrating:
- Standalone usage with flutter_localizations
- Integration with different state management solutions
- RTL support implementation
- Locale switcher widgets
- Best locale matching

## Issues & Contributions

Found a bug or have a feature request?

- [Report an issue](https://github.com/IbrahimElmourchidi/modular_l10n/issues)
- [Contribute on GitHub](https://github.com/IbrahimElmourchidi/modular_l10n)

## License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/IbrahimElmourchidi/modular_l10n/blob/main/LICENSE) file for details.

---

<p align="center">
  Made with care by <a href="https://ibrahim.utanium.org">Utanium</a>
</p>