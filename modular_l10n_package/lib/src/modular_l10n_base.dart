import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

/// Base class for modular localization.
///
/// This class provides the foundation for the generated localization classes.
/// It handles locale loading and message lookup.
abstract class ModularL10nBase {
  /// The current locale name
  static String? _currentLocale;

  /// Get the current locale name
  static String get currentLocale =>
      _currentLocale ?? Intl.defaultLocale ?? 'en';

  /// Set the current locale
  static void setLocale(String localeName) {
    _currentLocale = localeName;
    Intl.defaultLocale = localeName;
  }

  /// Initialize the localization system with a locale
  static Future<void> initialize(Locale locale) async {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    setLocale(localeName);
  }

  /// Check if a locale is supported
  static bool isLocaleSupported(Locale locale, List<Locale> supportedLocales) {
    return supportedLocales.any(
      (supportedLocale) => supportedLocale.languageCode == locale.languageCode,
    );
  }
}

/// Mixin for module localization classes.
///
/// Provides common functionality for all generated module classes.
mixin ModuleL10nMixin {
  /// The module name
  String get moduleName;

  /// Generate a prefixed key for intl lookup
  String prefixedKey(String key) => '${moduleName}_$key';
}
