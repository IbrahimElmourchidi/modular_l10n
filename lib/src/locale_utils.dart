import 'dart:ui';

/// Utility functions for working with locales in Flutter applications.
///
/// Provides lightweight, static helpers for:
/// - RTL (Right-to-Left) detection
/// - Locale parsing and matching
/// - Display name retrieval in English and native languages
/// - Text direction determination
///
/// All methods are static with zero performance overhead.
///
/// ## Example Usage
///
/// ```dart
/// // Check if locale is RTL
/// if (LocaleUtils.isRtl(const Locale('ar'))) {
///   // Apply RTL layout
/// }
///
/// // Get text direction
/// final direction = LocaleUtils.getTextDirection(locale);
///
/// // Parse locale string
/// final locale = LocaleUtils.parseLocale('en_US');
///
/// // Get display names
/// print(LocaleUtils.getDisplayName(locale)); // "English"
/// print(LocaleUtils.getNativeName(locale)); // "English"
///
/// // Find best match
/// final match = LocaleUtils.findBestMatch(
///   deviceLocale,
///   ML.supportedLocales,
/// );
/// ```
class LocaleUtils {
  // Private constructor to prevent instantiation
  LocaleUtils._();

  // ═══════════════════════════════════════════════════════════════════════════
  // RTL Detection
  // ═══════════════════════════════════════════════════════════════════════════

  /// Set of language codes that use RTL (Right-to-Left) writing direction.
  ///
  /// Includes:
  /// - Arabic (ar)
  /// - Hebrew (he)
  /// - Persian/Farsi (fa)
  /// - Urdu (ur)
  /// - Pashto (ps)
  /// - Sindhi (sd)
  /// - Yiddish (yi)
  /// - Kurdish Sorani (ku)
  /// - Uyghur (ug)
  /// - Divehi/Maldivian (dv)
  ///
  /// This is a const set for optimal performance.
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
    'dv', // Divehi/Maldivian
  };

  /// Check if a locale uses RTL (Right-to-Left) writing direction.
  ///
  /// Returns `true` for Arabic, Hebrew, Persian, Urdu, and other RTL languages.
  /// Based on the language code only (ignores country/script codes).
  ///
  /// ## Example
  ///
  /// ```dart
  /// if (LocaleUtils.isRtl(const Locale('ar'))) {
  ///   // Arabic is RTL - apply RTL layout
  /// }
  ///
  /// if (LocaleUtils.isRtl(const Locale('ar', 'EG'))) {
  ///   // Egyptian Arabic is also RTL
  /// }
  ///
  /// if (!LocaleUtils.isRtl(const Locale('en'))) {
  ///   // English is LTR
  /// }
  /// ```
  ///
  /// ## Performance
  ///
  /// This is a const Set lookup with O(1) performance.
  static bool isRtl(Locale locale) {
    return rtlLanguages.contains(locale.languageCode);
  }

  /// Get the [TextDirection] for a given locale.
  ///
  /// Returns:
  /// - [TextDirection.rtl] for RTL languages (Arabic, Hebrew, etc.)
  /// - [TextDirection.ltr] for all other languages
  ///
  /// ## Example
  ///
  /// ```dart
  /// // Use in Directionality widget
  /// Directionality(
  ///   textDirection: LocaleUtils.getTextDirection(locale),
  ///   child: child,
  /// )
  ///
  /// // Or directly
  /// TextDirection direction = LocaleUtils.getTextDirection(const Locale('ar'));
  /// // Returns TextDirection.rtl
  /// ```
  ///
  /// ## See Also
  ///
  /// - [isRtl] for a boolean check
  /// - [LocaleExtension.textDirection] for the extension method
  static TextDirection getTextDirection(Locale locale) {
    return isRtl(locale) ? TextDirection.rtl : TextDirection.ltr;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Locale Parsing
  // ═══════════════════════════════════════════════════════════════════════════

  /// Parse a locale string to a [Locale] object.
  ///
  /// Supports various locale formats including:
  /// - Simple language code: `"en"` → `Locale('en')`
  /// - Language + country (underscore): `"en_US"` → `Locale('en', 'US')`
  /// - Language + country (hyphen): `"en-US"` → `Locale('en', 'US')`
  /// - Language + script + country: `"zh_Hans_CN"` →
  ///   `Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans', countryCode: 'CN')`
  ///
  /// ## Script Code Detection
  ///
  /// Script codes are automatically detected if they:
  /// - Start with an uppercase letter
  /// - Have 4 characters
  /// - Match common script codes (Hans, Hant, Latn, Cyrl, Arab, etc.)
  ///
  /// ## Examples
  ///
  /// ```dart
  /// // Simple language
  /// LocaleUtils.parseLocale('en'); // Locale('en')
  ///
  /// // Language + country
  /// LocaleUtils.parseLocale('en_US'); // Locale('en', 'US')
  /// LocaleUtils.parseLocale('en-US'); // Locale('en', 'US')
  ///
  /// // Language + script + country
  /// LocaleUtils.parseLocale('zh_Hans_CN');
  /// // Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans', countryCode: 'CN')
  ///
  /// LocaleUtils.parseLocale('sr_Latn_RS');
  /// // Locale.fromSubtags(languageCode: 'sr', scriptCode: 'Latn', countryCode: 'RS')
  /// ```
  ///
  /// ## Parameters
  ///
  /// - [localeString]: The locale string to parse
  ///
  /// ## Returns
  ///
  /// A [Locale] object. If the format is invalid, returns a [Locale]
  /// with the original string as the language code.
  static Locale parseLocale(String localeString) {
    final parts = localeString.split(RegExp(r'[_-]'));

    if (parts.length == 1) {
      // Simple language code: "en"
      return Locale(parts[0]);
    } else if (parts.length == 2) {
      // Could be "en_US" or "zh_Hans"
      final second = parts[1];

      // Check if second part is a script code (4 chars, starts with uppercase)
      if (second.length == 4 && _isScriptCode(second)) {
        return Locale.fromSubtags(
          languageCode: parts[0],
          scriptCode: second,
        );
      } else {
        // Regular language + country
        return Locale(parts[0], second);
      }
    } else if (parts.length >= 3) {
      // Language + script + country: "zh_Hans_CN"
      return Locale.fromSubtags(
        languageCode: parts[0],
        scriptCode: parts[1],
        countryCode: parts[2],
      );
    }

    // Fallback
    return Locale(localeString);
  }

  /// Check if a string is a valid script code.
  ///
  /// Script codes are 4-character codes starting with uppercase
  /// (Hans, Hant, Latn, Cyrl, Arab, Deva, etc.)
  static bool _isScriptCode(String code) {
    if (code.length != 4) return false;
    if (code[0] != code[0].toUpperCase()) return false;

    // Common script codes
    const commonScripts = {
      'Hans', // Simplified Chinese
      'Hant', // Traditional Chinese
      'Latn', // Latin
      'Cyrl', // Cyrillic
      'Arab', // Arabic
      'Deva', // Devanagari
      'Beng', // Bengali
      'Jpan', // Japanese
      'Kore', // Korean
      'Grek', // Greek
      'Hebr', // Hebrew
      'Thai', // Thai
      'Ethi', // Ethiopic
      'Armn', // Armenian
      'Geor', // Georgian
    };

    return commonScripts.contains(code);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Locale Matching
  // ═══════════════════════════════════════════════════════════════════════════

  /// Find the best matching locale from a list of supported locales.
  ///
  /// Uses a priority-based matching algorithm:
  /// 1. **Exact match**: Same language, country, and script
  /// 2. **Language + country match**: Same language and country (ignoring script)
  /// 3. **Language match**: Same language only (first match)
  ///
  /// ## Example
  ///
  /// ```dart
  /// final supportedLocales = [
  ///   Locale('en'),
  ///   Locale('en', 'GB'),
  ///   Locale('ar'),
  ///   Locale('ar', 'EG'),
  ///   Locale('de'),
  /// ];
  ///
  /// // Exact match
  /// LocaleUtils.findBestMatch(
  ///   const Locale('en', 'GB'),
  ///   supportedLocales,
  /// ); // Returns Locale('en', 'GB')
  ///
  /// // Language + country match
  /// LocaleUtils.findBestMatch(
  ///   const Locale('ar', 'EG'),
  ///   supportedLocales,
  /// ); // Returns Locale('ar', 'EG')
  ///
  /// // Language match (no exact country)
  /// LocaleUtils.findBestMatch(
  ///   const Locale('ar', 'SA'),
  ///   supportedLocales,
  /// ); // Returns Locale('ar')
  ///
  /// // No match
  /// LocaleUtils.findBestMatch(
  ///   const Locale('fr'),
  ///   supportedLocales,
  /// ); // Returns null
  /// ```
  ///
  /// ## Use Case
  ///
  /// Use this when handling device locale fallback:
  ///
  /// ```dart
  /// final deviceLocale = WidgetsBinding.instance.window.locale;
  /// final bestMatch = LocaleUtils.findBestMatch(
  ///   deviceLocale,
  ///   ML.supportedLocales,
  /// );
  ///
  /// final initialLocale = bestMatch ?? ML.supportedLocales.first;
  /// ```
  ///
  /// ## Parameters
  ///
  /// - [locale]: The locale to match
  /// - [supportedLocales]: List of available locales
  ///
  /// ## Returns
  ///
  /// The best matching [Locale], or `null` if no match is found.
  static Locale? findBestMatch(
    Locale locale,
    List<Locale> supportedLocales,
  ) {
    // Priority 1: Exact match (language + country + script)
    for (final supported in supportedLocales) {
      if (supported == locale) {
        return supported;
      }
    }

    // Priority 2: Language + country match (ignoring script)
    if (locale.countryCode != null && locale.countryCode!.isNotEmpty) {
      for (final supported in supportedLocales) {
        if (supported.languageCode == locale.languageCode &&
            supported.countryCode == locale.countryCode) {
          return supported;
        }
      }
    }

    // Priority 3: Language-only match (first match)
    for (final supported in supportedLocales) {
      if (supported.languageCode == locale.languageCode) {
        return supported;
      }
    }

    // No match found
    return null;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Display Names
  // ═══════════════════════════════════════════════════════════════════════════

  /// Get the English display name for a locale.
  ///
  /// Returns the English name of the language (e.g., "Arabic" for 'ar').
  /// Falls back to the language code if the name is not found.
  ///
  /// ## Example
  ///
  /// ```dart
  /// LocaleUtils.getDisplayName(const Locale('ar')); // "Arabic"
  /// LocaleUtils.getDisplayName(const Locale('en')); // "English"
  /// LocaleUtils.getDisplayName(const Locale('zh')); // "Chinese"
  /// LocaleUtils.getDisplayName(const Locale('xyz')); // "xyz" (fallback)
  /// ```
  ///
  /// ## Use Case
  ///
  /// Display locale options in English:
  ///
  /// ```dart
  /// // Locale switcher in English
  /// DropdownButton<Locale>(
  ///   items: ML.supportedLocales.map((locale) {
  ///     return DropdownMenuItem(
  ///       value: locale,
  ///       child: Text(LocaleUtils.getDisplayName(locale)),
  ///     );
  ///   }).toList(),
  /// )
  /// ```
  ///
  /// ## See Also
  ///
  /// - [getNativeName] for native language names
  /// - [LocaleExtension.displayName] for the extension method
  static String getDisplayName(Locale locale) {
    return _localeNames[locale.languageCode] ?? locale.languageCode;
  }

  /// Get the native display name for a locale.
  ///
  /// Returns the language name in its native script
  /// (e.g., "العربية" for 'ar', "中文" for 'zh').
  /// Falls back to the language code if the name is not found.
  ///
  /// ## Example
  ///
  /// ```dart
  /// LocaleUtils.getNativeName(const Locale('ar')); // "العربية"
  /// LocaleUtils.getNativeName(const Locale('en')); // "English"
  /// LocaleUtils.getNativeName(const Locale('zh')); // "中文"
  /// LocaleUtils.getNativeName(const Locale('ja')); // "日本語"
  /// ```
  ///
  /// ## Use Case
  ///
  /// Display locale options in their native language:
  ///
  /// ```dart
  /// // Locale switcher with native names
  /// DropdownButton<Locale>(
  ///   items: ML.supportedLocales.map((locale) {
  ///     return DropdownMenuItem(
  ///       value: locale,
  ///       child: Text(
  ///         locale.nativeName,
  ///         style: TextStyle(
  ///           // Use locale-specific font if needed
  ///         ),
  ///       ),
  ///     );
  ///   }).toList(),
  /// )
  /// ```
  ///
  /// ## See Also
  ///
  /// - [getDisplayName] for English language names
  /// - [LocaleExtension.nativeName] for the extension method
  static String getNativeName(Locale locale) {
    return _nativeLocaleNames[locale.languageCode] ?? locale.languageCode;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Private: Language Name Maps
  // ═══════════════════════════════════════════════════════════════════════════

  /// English names for language codes.
  ///
  /// This is a const map for optimal performance.
  static const Map<String, String> _localeNames = {
    // Major Languages
    'en': 'English',
    'zh': 'Chinese',
    'es': 'Spanish',
    'hi': 'Hindi',
    'ar': 'Arabic',
    'bn': 'Bengali',
    'pt': 'Portuguese',
    'ru': 'Russian',
    'ja': 'Japanese',
    'pa': 'Punjabi',

    // European Languages
    'de': 'German',
    'fr': 'French',
    'it': 'Italian',
    'pl': 'Polish',
    'uk': 'Ukrainian',
    'ro': 'Romanian',
    'nl': 'Dutch',
    'el': 'Greek',
    'cs': 'Czech',
    'sv': 'Swedish',
    'hu': 'Hungarian',
    'be': 'Belarusian',
    'fi': 'Finnish',
    'bg': 'Bulgarian',
    'hr': 'Croatian',
    'sr': 'Serbian',
    'sk': 'Slovak',
    'da': 'Danish',
    'no': 'Norwegian',
    'nb': 'Norwegian Bokmål',
    'nn': 'Norwegian Nynorsk',
    'lt': 'Lithuanian',
    'sl': 'Slovenian',
    'et': 'Estonian',
    'lv': 'Latvian',
    'bs': 'Bosnian',
    'sq': 'Albanian',
    'mk': 'Macedonian',
    'is': 'Icelandic',
    'ga': 'Irish',
    'cy': 'Welsh',
    'eu': 'Basque',
    'ca': 'Catalan',
    'gl': 'Galician',
    'mt': 'Maltese',
    'lb': 'Luxembourgish',

    // Middle Eastern & Central Asian Languages
    'tr': 'Turkish',
    'fa': 'Persian',
    'he': 'Hebrew',
    'ur': 'Urdu',
    'ps': 'Pashto',
    'ku': 'Kurdish',
    'hy': 'Armenian',
    'ka': 'Georgian',
    'az': 'Azerbaijani',
    'kk': 'Kazakh',
    'uz': 'Uzbek',
    'ky': 'Kyrgyz',
    'tk': 'Turkmen',
    'tg': 'Tajik',
    'yi': 'Yiddish',
    'dv': 'Divehi',

    // South Asian Languages
    'ta': 'Tamil',
    'te': 'Telugu',
    'mr': 'Marathi',
    'gu': 'Gujarati',
    'kn': 'Kannada',
    'ml': 'Malayalam',
    'si': 'Sinhala',
    'ne': 'Nepali',
    'sd': 'Sindhi',
    'or': 'Odia',

    // Southeast Asian Languages
    'th': 'Thai',
    'vi': 'Vietnamese',
    'id': 'Indonesian',
    'ms': 'Malay',
    'my': 'Burmese',
    'km': 'Khmer',
    'lo': 'Lao',
    'fil': 'Filipino',
    'tl': 'Tagalog',
    'jv': 'Javanese',

    // East Asian Languages
    'ko': 'Korean',
    'mn': 'Mongolian',
    'ug': 'Uyghur',

    // African Languages
    'sw': 'Swahili',
    'am': 'Amharic',
    'ha': 'Hausa',
    'yo': 'Yoruba',
    'ig': 'Igbo',
    'zu': 'Zulu',
    'af': 'Afrikaans',
    'so': 'Somali',
    'mg': 'Malagasy',
  };

  /// Native names for language codes.
  ///
  /// This is a const map for optimal performance.
  static const Map<String, String> _nativeLocaleNames = {
    // Major Languages
    'en': 'English',
    'zh': '中文',
    'es': 'Español',
    'hi': 'हिन्दी',
    'ar': 'العربية',
    'bn': 'বাংলা',
    'pt': 'Português',
    'ru': 'Русский',
    'ja': '日本語',
    'pa': 'ਪੰਜਾਬੀ',

    // European Languages
    'de': 'Deutsch',
    'fr': 'Français',
    'it': 'Italiano',
    'pl': 'Polski',
    'uk': 'Українська',
    'ro': 'Română',
    'nl': 'Nederlands',
    'el': 'Ελληνικά',
    'cs': 'Čeština',
    'sv': 'Svenska',
    'hu': 'Magyar',
    'be': 'Беларуская',
    'az': 'Azərbaycan',
    'fi': 'Suomi',
    'bg': 'Български',
    'hr': 'Hrvatski',
    'sr': 'Српски',
    'sk': 'Slovenčina',
    'da': 'Dansk',
    'no': 'Norsk',
    'nb': 'Norsk Bokmål',
    'nn': 'Norsk Nynorsk',
    'lt': 'Lietuvių',
    'sl': 'Slovenščina',
    'et': 'Eesti',
    'lv': 'Latviešu',
    'bs': 'Bosanski',
    'sq': 'Shqip',
    'mk': 'Македонски',
    'is': 'Íslenska',
    'ga': 'Gaeilge',
    'cy': 'Cymraeg',
    'eu': 'Euskara',
    'ca': 'Català',
    'gl': 'Galego',
    'mt': 'Malti',
    'lb': 'Lëtzebuergesch',

    // Middle Eastern & Central Asian Languages
    'tr': 'Türkçe',
    'fa': 'فارسی',
    'he': 'עברית',
    'ur': 'اردو',
    'ps': 'پښتو',
    'ku': 'Kurdî',
    'hy': 'Հայերեն',
    'ka': 'ქართული',
    'kk': 'Қазақ',
    'uz': 'Oʻzbek',
    'ky': 'Кыргызча',
    'tk': 'Türkmen',
    'tg': 'Тоҷикӣ',
    'yi': 'ייִדיש',
    'dv': 'ދިވެހި',

    // South Asian Languages
    'ta': 'தமிழ்',
    'te': 'తెలుగు',
    'mr': 'मराठी',
    'gu': 'ગુજરાતી',
    'kn': 'ಕನ್ನಡ',
    'ml': 'മലയാളം',
    'si': 'සිංහල',
    'ne': 'नेपाली',
    'sd': 'سنڌي',
    'or': 'ଓଡ଼ିଆ',

    // Southeast Asian Languages
    'th': 'ไทย',
    'vi': 'Tiếng Việt',
    'id': 'Bahasa Indonesia',
    'ms': 'Bahasa Melayu',
    'my': 'မြန်မာဘာသာ',
    'km': 'ភាសាខ្មែរ',
    'lo': 'ລາວ',
    'fil': 'Filipino',
    'tl': 'Tagalog',
    'jv': 'Basa Jawa',

    // East Asian Languages
    'ko': '한국어',
    'mn': 'Монгол',
    'ug': 'ئۇيغۇرچە',

    // African Languages
    'sw': 'Kiswahili',
    'am': 'አማርኛ',
    'ha': 'Hausa',
    'yo': 'Yorùbá',
    'ig': 'Igbo',
    'zu': 'isiZulu',
    'af': 'Afrikaans',
    'so': 'Soomaali',
    'mg': 'Malagasy',
  };
}

// ═══════════════════════════════════════════════════════════════════════════
// Locale Extensions
// ═══════════════════════════════════════════════════════════════════════════

/// Extension methods on [Locale] for convenient access to locale utilities.
///
/// These extension methods provide a more ergonomic API for common locale
/// operations, wrapping the static methods from [LocaleUtils].
///
/// ## Example Usage
///
/// ```dart
/// final locale = const Locale('ar', 'EG');
///
/// // Check RTL
/// if (locale.isRtl) {
///   // Apply RTL layout
/// }
///
/// // Get text direction
/// Directionality(
///   textDirection: locale.textDirection,
///   child: child,
/// )
///
/// // Get display names
/// Text(locale.displayName); // "Arabic"
/// Text(locale.nativeName);  // "العربية"
/// ```
///
/// ## Performance
///
/// All extension methods are simple wrappers around static utility methods,
/// so they have zero performance overhead.
extension LocaleExtension on Locale {
  /// Check if this locale uses RTL (Right-to-Left) writing direction.
  ///
  /// Returns `true` for Arabic, Hebrew, Persian, Urdu, and other RTL languages.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final locale = const Locale('ar');
  ///
  /// if (locale.isRtl) {
  ///   // Apply RTL-specific layout
  ///   return Row(
  ///     textDirection: TextDirection.rtl,
  ///     children: [...],
  ///   );
  /// }
  /// ```
  ///
  /// ## See Also
  ///
  /// - [LocaleUtils.isRtl] for the underlying implementation
  /// - [textDirection] for getting the [TextDirection] directly
  bool get isRtl => LocaleUtils.isRtl(this);

  /// Get the [TextDirection] for this locale.
  ///
  /// Returns:
  /// - [TextDirection.rtl] for RTL languages
  /// - [TextDirection.ltr] for LTR languages
  ///
  /// ## Example
  ///
  /// ```dart
  /// // Use in Directionality widget
  /// Directionality(
  ///   textDirection: locale.textDirection,
  ///   child: child,
  /// )
  ///
  /// // Use in Row/Column
  /// Row(
  ///   textDirection: locale.textDirection,
  ///   children: [...],
  /// )
  /// ```
  ///
  /// ## See Also
  ///
  /// - [LocaleUtils.getTextDirection] for the underlying implementation
  /// - [isRtl] for a boolean check
  TextDirection get textDirection => LocaleUtils.getTextDirection(this);

  /// Get the English display name for this locale.
  ///
  /// Returns the English name of the language (e.g., "Arabic" for 'ar').
  ///
  /// ## Example
  ///
  /// ```dart
  /// final locale = const Locale('ar');
  /// print(locale.displayName); // "Arabic"
  ///
  /// // Use in a locale selector
  /// DropdownButton<Locale>(
  ///   items: ML.supportedLocales.map((locale) {
  ///     return DropdownMenuItem(
  ///       value: locale,
  ///       child: Text(locale.displayName),
  ///     );
  ///   }).toList(),
  /// )
  /// ```
  ///
  /// ## See Also
  ///
  /// - [LocaleUtils.getDisplayName] for the underlying implementation
  /// - [nativeName] for the native language name
  String get displayName => LocaleUtils.getDisplayName(this);

  /// Get the native display name for this locale.
  ///
  /// Returns the language name in its native script
  /// (e.g., "العربية" for 'ar', "中文" for 'zh').
  ///
  /// ## Example
  ///
  /// ```dart
  /// final locale = const Locale('ar');
  /// print(locale.nativeName); // "العربية"
  ///
  /// // Use in a locale selector with native names
  /// DropdownButton<Locale>(
  ///   items: ML.supportedLocales.map((locale) {
  ///     return DropdownMenuItem(
  ///       value: locale,
  ///       child: Text(locale.nativeName),
  ///     );
  ///   }).toList(),
  /// )
  /// ```
  ///
  /// ## See Also
  ///
  /// - [LocaleUtils.getNativeName] for the underlying implementation
  /// - [displayName] for the English language name
  String get nativeName => LocaleUtils.getNativeName(this);
}
