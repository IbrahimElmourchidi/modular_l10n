import 'dart:ui';

/// Utility functions for working with locales.
///
/// Provides helpers for RTL detection, locale parsing, and display names.
///
/// ## Example
///
/// ```dart
/// // Check if locale is RTL
/// if (LocaleUtils.isRtl(locale)) {
///   // Handle RTL layout
/// }
///
/// // Get text direction
/// TextDirection direction = LocaleUtils.getTextDirection(locale);
///
/// // Parse locale string
/// Locale locale = LocaleUtils.parseLocale('en_US');
///
/// // Get display name
/// String name = LocaleUtils.getDisplayName(locale); // "English"
/// String nativeName = LocaleUtils.getNativeName(locale); // "English"
/// ```
class LocaleUtils {
  LocaleUtils._();

  /// Check if a locale is RTL (Right-to-Left).
  ///
  /// Returns `true` for Arabic, Hebrew, Persian, Urdu, and other RTL languages.
  ///
  /// ```dart
  /// if (LocaleUtils.isRtl(const Locale('ar'))) {
  ///   // Arabic is RTL
  /// }
  /// ```
  static bool isRtl(Locale locale) {
    return rtlLanguages.contains(locale.languageCode);
  }

  /// Set of RTL (Right-to-Left) language codes.
  ///
  /// Includes Arabic, Hebrew, Persian, Urdu, and other RTL languages.
  static const Set<String> rtlLanguages = {
    'ar', // Arabic
    'fa', // Persian/Farsi
    'he', // Hebrew
    'ur', // Urdu
    'ps', // Pashto
    'sd', // Sindhi
    'yi', // Yiddish
    'ku', // Kurdish (Sorani)
    'ug', // Uyghur
    'dv', // Divehi
  };

  /// Get text direction for a locale.
  ///
  /// Returns [TextDirection.rtl] for RTL languages, [TextDirection.ltr] otherwise.
  ///
  /// ```dart
  /// TextDirection direction = LocaleUtils.getTextDirection(locale);
  /// ```
  static TextDirection getTextDirection(Locale locale) {
    return isRtl(locale) ? TextDirection.rtl : TextDirection.ltr;
  }

  /// Parse a locale string to [Locale] object.
  ///
  /// Supports formats:
  /// - `"en"` → `Locale('en')`
  /// - `"en_US"` → `Locale('en', 'US')`
  /// - `"en-US"` → `Locale('en', 'US')`
  /// - `"zh_Hans_CN"` → `Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans', countryCode: 'CN')`
  ///
  /// ```dart
  /// Locale locale = LocaleUtils.parseLocale('en_US');
  /// ```
  static Locale parseLocale(String localeString) {
    final parts = localeString.split(RegExp(r'[_-]'));
    if (parts.length == 1) {
      return Locale(parts[0]);
    } else if (parts.length == 2) {
      return Locale(parts[0], parts[1]);
    } else if (parts.length >= 3) {
      return Locale.fromSubtags(
        languageCode: parts[0],
        scriptCode: parts[1],
        countryCode: parts[2],
      );
    }
    return Locale(localeString);
  }

  /// Find the best matching locale from supported locales.
  ///
  /// Matching priority:
  /// 1. Exact match (language + country)
  /// 2. Language + country match
  /// 3. Language only match
  ///
  /// Returns `null` if no match is found.
  ///
  /// ```dart
  /// final supportedLocales = [Locale('en'), Locale('ar'), Locale('de')];
  /// final deviceLocale = Locale('ar', 'EG');
  ///
  /// Locale? match = LocaleUtils.findBestMatch(deviceLocale, supportedLocales);
  /// // Returns Locale('ar')
  /// ```
  static Locale? findBestMatch(
    Locale locale,
    List<Locale> supportedLocales,
  ) {
    // Exact match
    for (final supported in supportedLocales) {
      if (supported == locale) {
        return supported;
      }
    }

    // Language + country match
    for (final supported in supportedLocales) {
      if (supported.languageCode == locale.languageCode &&
          supported.countryCode == locale.countryCode) {
        return supported;
      }
    }

    // Language only match
    for (final supported in supportedLocales) {
      if (supported.languageCode == locale.languageCode) {
        return supported;
      }
    }

    return null;
  }

  /// Get English display name for a locale.
  ///
  /// ```dart
  /// String name = LocaleUtils.getDisplayName(const Locale('ar')); // "Arabic"
  /// ```
  static String getDisplayName(Locale locale) {
    return _localeNames[locale.languageCode] ?? locale.languageCode;
  }

  /// Get native display name for a locale.
  ///
  /// ```dart
  /// String name = LocaleUtils.getNativeName(const Locale('ar')); // "العربية"
  /// ```
  static String getNativeName(Locale locale) {
    return _nativeLocaleNames[locale.languageCode] ?? locale.languageCode;
  }

  static const Map<String, String> _localeNames = {
    'en': 'English',
    'ar': 'Arabic',
    'de': 'German',
    'es': 'Spanish',
    'fr': 'French',
    'it': 'Italian',
    'ja': 'Japanese',
    'ko': 'Korean',
    'pt': 'Portuguese',
    'ru': 'Russian',
    'zh': 'Chinese',
    'hi': 'Hindi',
    'tr': 'Turkish',
    'nl': 'Dutch',
    'pl': 'Polish',
    'sv': 'Swedish',
    'da': 'Danish',
    'no': 'Norwegian',
    'fi': 'Finnish',
    'he': 'Hebrew',
    'fa': 'Persian',
    'ur': 'Urdu',
    'id': 'Indonesian',
    'ms': 'Malay',
    'th': 'Thai',
    'vi': 'Vietnamese',
    'uk': 'Ukrainian',
    'cs': 'Czech',
    'el': 'Greek',
    'hu': 'Hungarian',
    'ro': 'Romanian',
    'sk': 'Slovak',
    'bg': 'Bulgarian',
    'hr': 'Croatian',
    'sr': 'Serbian',
    'sl': 'Slovenian',
    'et': 'Estonian',
    'lv': 'Latvian',
    'lt': 'Lithuanian',
    'bn': 'Bengali',
    'ta': 'Tamil',
    'te': 'Telugu',
    'mr': 'Marathi',
    'gu': 'Gujarati',
    'kn': 'Kannada',
    'ml': 'Malayalam',
    'pa': 'Punjabi',
  };

  static const Map<String, String> _nativeLocaleNames = {
    'en': 'English',
    'ar': 'العربية',
    'de': 'Deutsch',
    'es': 'Español',
    'fr': 'Français',
    'it': 'Italiano',
    'ja': '日本語',
    'ko': '한국어',
    'pt': 'Português',
    'ru': 'Русский',
    'zh': '中文',
    'hi': 'हिन्दी',
    'tr': 'Türkçe',
    'nl': 'Nederlands',
    'pl': 'Polski',
    'sv': 'Svenska',
    'da': 'Dansk',
    'no': 'Norsk',
    'fi': 'Suomi',
    'he': 'עברית',
    'fa': 'فارسی',
    'ur': 'اردو',
    'id': 'Bahasa Indonesia',
    'ms': 'Bahasa Melayu',
    'th': 'ไทย',
    'vi': 'Tiếng Việt',
    'uk': 'Українська',
    'cs': 'Čeština',
    'el': 'Ελληνικά',
    'hu': 'Magyar',
    'ro': 'Română',
    'sk': 'Slovenčina',
    'bg': 'Български',
    'hr': 'Hrvatski',
    'sr': 'Српски',
    'sl': 'Slovenščina',
    'et': 'Eesti',
    'lv': 'Latviešu',
    'lt': 'Lietuvių',
    'bn': 'বাংলা',
    'ta': 'தமிழ்',
    'te': 'తెలుగు',
    'mr': 'मराठी',
    'gu': 'ગુજરાતી',
    'kn': 'ಕನ್ನಡ',
    'ml': 'മലയാളം',
    'pa': 'ਪੰਜਾਬੀ',
  };
}

/// Extension for [Locale] with utility methods.
///
/// Provides convenient access to locale utilities:
///
/// ```dart
/// Locale locale = const Locale('ar');
///
/// bool isRtl = locale.isRtl;                    // true
/// TextDirection dir = locale.textDirection;     // TextDirection.rtl
/// String name = locale.displayName;             // "Arabic"
/// String nativeName = locale.nativeName;        // "العربية"
/// ```
extension LocaleExtension on Locale {
  /// Check if this locale is RTL.
  ///
  /// ```dart
  /// if (locale.isRtl) {
  ///   // Handle RTL layout
  /// }
  /// ```
  bool get isRtl => LocaleUtils.isRtl(this);

  /// Get text direction for this locale.
  ///
  /// ```dart
  /// Directionality(
  ///   textDirection: locale.textDirection,
  ///   child: child,
  /// )
  /// ```
  TextDirection get textDirection => LocaleUtils.getTextDirection(this);

  /// Get English display name for this locale.
  ///
  /// ```dart
  /// Text(locale.displayName) // "Arabic"
  /// ```
  String get displayName => LocaleUtils.getDisplayName(this);

  /// Get native display name for this locale.
  ///
  /// ```dart
  /// Text(locale.nativeName) // "العربية"
  /// ```
  String get nativeName => LocaleUtils.getNativeName(this);
}
