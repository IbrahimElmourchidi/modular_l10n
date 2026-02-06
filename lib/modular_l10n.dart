/// A modular approach to Flutter localization.
///
/// This package provides runtime support for the modular localization system.
/// Use it in conjunction with the Modular Flutter L10n VS Code extension.
///
/// ## Features
///
/// - **RTL Support**: Built-in detection for Arabic, Hebrew, and other RTL languages
/// - **LocaleProvider**: Easy runtime locale switching with InheritedWidget
/// - **Locale Utilities**: Parse, match, and get display names for locales
///
/// ## Quick Start
///
/// ```dart
/// import 'package:modular_l10n/modular_l10n.dart';
///
/// // Wrap your app with LocaleProvider
/// LocaleProvider(
///   initialLocale: const Locale('en'),
///   onLocaleChanged: (locale) {
///     // Handle locale change
///   },
///   child: MaterialApp(...),
/// )
///
/// // Change locale from anywhere
/// context.setLocale(const Locale('ar'));
///
/// // Check if locale is RTL
/// if (locale.isRtl) {
///   // Handle RTL layout
/// }
/// ```
library modular_l10n;

export 'src/modular_l10n_base.dart';
export 'src/locale_provider.dart';
export 'src/locale_utils.dart';
