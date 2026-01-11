# Modular Flutter Localization

<p align="center">
  <img src="images/icon.png" alt="Modular Flutter L10n" width="128">
</p>

<p align="center">
  <a href="https://marketplace.visualstudio.com/items?itemName=utanium.modular-flutter-l10n">
    <img src="https://img.shields.io/visual-studio-marketplace/v/utanium.modular-flutter-l10n?style=flat-square&label=VS%20Code%20Marketplace" alt="VS Code Marketplace Version">
  </a>
  <a href="https://marketplace.visualstudio.com/items?itemName=utanium.modular-flutter-l10n">
    <img src="https://img.shields.io/visual-studio-marketplace/i/utanium.modular-flutter-l10n?style=flat-square" alt="VS Code Marketplace Installs">
  </a>
  <a href="https://github.com/IbrahimElmourchidi/modular_flutter_l10n/blob/main/LICENSE">
    <img src="https://img.shields.io/github/license/IbrahimElmourchidi/modular_flutter_l10n?style=flat-square" alt="License">
  </a>
</p>

<p align="center">
  <b>Organize your Flutter translations by feature/module for better scalability and reusability.</b>
</p>

---

## ✨ Features

| Feature | Description |
|---------|-------------|
| 📦 **Modular Organization** | Keep translations alongside your feature code |
| 🔄 **Auto-Generation** | Watch mode regenerates code on file changes |
| 🌍 **RTL Support** | Full support for Arabic, Hebrew, and other RTL languages |
| 🧩 **Reusable Modules** | Copy feature folders between projects with translations included |
| 📝 **Type-Safe** | Generated Dart code with full IDE autocompletion |
| 🎯 **Nested Access** | Clean API: `S.auth.email` instead of flat keys |
| 🔢 **Pluralization** | Full ICU message format support |

## 🚀 Quick Start

### 1. Install the Extension

Install from the [VS Code Marketplace](https://marketplace.visualstudio.com/items?itemName=utanium.modular-flutter-l10n) or search for "Modular Flutter Localization" in VS Code.

### 2. Create Your First Module

Create ARB files in your feature folder:

```
lib/features/auth/l10n/
├── auth_en.arb
└── auth_ar.arb
```

**auth_en.arb:**
```json
{
  "@@locale": "en",
  "@@context": "auth",
  "email": "Email",
  "password": "Password",
  "login": "Login",
  "welcomeBack": "Welcome back, {name}!"
}
```

**auth_ar.arb:**
```json
{
  "@@locale": "ar",
  "@@context": "auth",
  "email": "البريد الإلكتروني",
  "password": "كلمة المرور",
  "login": "تسجيل الدخول",
  "welcomeBack": "مرحباً بعودتك، {name}!"
}
```

### 3. Generate Code

The extension will auto-generate on save (if watch mode is enabled), or use the command palette:

- Press `Ctrl+Shift+P` (or `Cmd+Shift+P` on macOS)
- Type "Modular L10n: Generate Translations"
- Press Enter

### 4. Use in Your App

```dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'generated/l10n/l10n.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('en'),
      supportedLocales: S.supportedLocales,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Access translations with type-safe nested syntax
          TextField(decoration: InputDecoration(labelText: S.auth.email)),
          TextField(decoration: InputDecoration(labelText: S.auth.password)),
          ElevatedButton(
            onPressed: () {},
            child: Text(S.auth.login),
          ),
          // With parameters
          Text(S.auth.welcomeBack('Ahmed')),
        ],
      ),
    );
  }
}
```

## 📁 Project Structure

```
your_flutter_app/
├── lib/
│   ├── features/
│   │   ├── auth/
│   │   │   ├── l10n/
│   │   │   │   ├── auth_en.arb    ← English translations
│   │   │   │   └── auth_ar.arb    ← Arabic translations
│   │   │   ├── screens/
│   │   │   └── widgets/
│   │   ├── home/
│   │   │   ├── l10n/
│   │   │   │   ├── home_en.arb
│   │   │   │   └── home_ar.arb
│   │   │   └── ...
│   │   └── settings/
│   │       ├── l10n/
│   │       │   ├── settings_en.arb
│   │       │   └── settings_ar.arb
│   │       └── ...
│   └── generated/
│       └── l10n/                  ← Generated code (don't edit)
│           ├── s.dart
│           ├── auth_l10n.dart
│           ├── home_l10n.dart
│           └── settings_l10n.dart
```

## ⚙️ Configuration

Add to your `.vscode/settings.json`:

```json
{
  "modularL10n.outputPath": "lib/generated/l10n",
  "modularL10n.supportedLocales": ["en", "ar"],
  "modularL10n.defaultLocale": "en",
  "modularL10n.arbFilePattern": "**/l10n/*.arb",
  "modularL10n.watchMode": true,
  "modularL10n.generateCombinedArb": true,
  "modularL10n.className": "S"
}
```

| Setting | Default | Description |
|---------|---------|-------------|
| `outputPath` | `lib/generated/l10n` | Where to generate Dart files |
| `supportedLocales` | `["en", "ar"]` | List of locale codes to support |
| `defaultLocale` | `en` | Fallback locale |
| `arbFilePattern` | `**/l10n/*.arb` | Pattern to find ARB files |
| `watchMode` | `true` | Auto-regenerate on file changes |
| `generateCombinedArb` | `true` | Create combined ARB files |
| `className` | `S` | Name of main localization class |

## 🛠️ Commands

| Command | Description |
|---------|-------------|
| `Modular L10n: Generate Translations` | Regenerate all translation files |
| `Modular L10n: Add Translation Key` | Add a new key to a specific module |
| `Modular L10n: Create New Module` | Create a new feature module with l10n scaffold |

## 📖 ARB File Format

### Basic String

```json
{
  "greeting": "Hello"
}
```

### With Description

```json
{
  "greeting": "Hello",
  "@greeting": {
    "description": "Simple greeting shown on home screen"
  }
}
```

### With Placeholders

```json
{
  "welcomeMessage": "Welcome, {name}!",
  "@welcomeMessage": {
    "description": "Welcome message with user name",
    "placeholders": {
      "name": {
        "type": "String",
        "example": "John"
      }
    }
  }
}
```

### With Pluralization

```json
{
  "itemCount": "{count, plural, =0{No items} =1{1 item} other{{count} items}}",
  "@itemCount": {
    "description": "Number of items in cart",
    "placeholders": {
      "count": {
        "type": "int"
      }
    }
  }
}
```

**Usage:**
```dart
Text(S.home.itemCount(0))   // "No items"
Text(S.home.itemCount(1))   // "1 item"
Text(S.home.itemCount(5))   // "5 items"
```

## 🔄 Reusing Modules

One of the main benefits of this modular approach is easy module reuse:

```bash
# Copy auth feature to new project with all translations
cp -r old_project/lib/features/auth new_project/lib/features/

# Run generate in new project - translations are ready!
```

## 🌐 RTL Support

For full RTL support, use the companion Dart package:

```dart
import 'package:modular_l10n/modular_l10n.dart';

// Check if locale is RTL
if (LocaleUtils.isRtl(locale)) {
  // Handle RTL layout
}

// Get text direction
TextDirection direction = LocaleUtils.getTextDirection(locale);

// Use extension
bool isRtl = locale.isRtl;
```

## 📦 Companion Package

For runtime utilities like `LocaleProvider` and RTL support, install the [modular_l10n](https://pub.dev/packages/modular_l10n) Dart package:

```yaml
dependencies:
  modular_l10n: ^1.0.0
```

## 📋 Naming Conventions

| Type | Convention | Example |
|------|------------|---------|
| ARB files | `{moduleName}_{locale}.arb` | `auth_en.arb`, `home_ar.arb` |
| Module names | snake_case | `auth`, `home`, `user_profile` |
| Key names | camelCase | `welcomeMessage`, `loginButton` |

## 🔀 Migration from flutter_intl

If you're migrating from `flutter_intl`:

1. Create `l10n` folders in your feature directories
2. Split your single `.arb` file into module-specific files
3. Remove the `flutter_intl` configuration from `pubspec.yaml`
4. Run "Modular L10n: Generate Translations"

## ❓ FAQ

<details>
<summary><b>Why use modular localization?</b></summary>

- **Scalability**: Large apps with many translations become easier to manage
- **Team collaboration**: Different developers can work on different feature translations
- **Reusability**: Copy entire features between projects with translations included
- **Clean architecture**: Keeps related code and translations together

</details>

<details>
<summary><b>Does it work with existing flutter_intl projects?</b></summary>

Yes! You can gradually migrate by creating l10n folders in your features while keeping the old setup. Once you've moved all translations, remove the old configuration.

</details>

<details>
<summary><b>Can I use both this and flutter_intl?</b></summary>

We recommend migrating completely to avoid confusion, but they can technically coexist during a transition period.

</details>

## 🐛 Issues & Contributions

Found a bug or have a feature request?

- [Report an issue](https://github.com/IbrahimElmourchidi/modular_flutter_l10n/issues)
- [Contribute on GitHub](https://github.com/IbrahimElmourchidi/modular_flutter_l10n)

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

<p align="center">
  Made with ❤️ by <a href="https://ibrahim.utanium.org">Utanium</a>
</p>
