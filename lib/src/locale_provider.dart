import 'package:flutter/widgets.dart';

/// Provider for managing locale state in the widget tree.
///
/// Wrap your MaterialApp or CupertinoApp with this widget to enable
/// runtime locale switching.
///
/// ## Example
///
/// ```dart
/// LocaleProvider(
///   initialLocale: const Locale('en'),
///   onLocaleChanged: (locale) {
///     // Persist locale preference
///     prefs.setString('locale', locale.languageCode);
///   },
///   child: MaterialApp(
///     locale: LocaleProvider.of(context).currentLocale,
///     supportedLocales: S.supportedLocales,
///     localizationsDelegates: [...],
///     home: const HomePage(),
///   ),
/// )
/// ```
///
/// Then change the locale from anywhere:
///
/// ```dart
/// context.setLocale(const Locale('ar'));
/// ```
class LocaleProvider extends StatefulWidget {
  /// The initial locale to use
  final Locale initialLocale;

  /// The child widget
  final Widget child;

  /// Callback when locale changes
  ///
  /// Use this to persist the locale preference:
  /// ```dart
  /// onLocaleChanged: (locale) {
  ///   prefs.setString('locale', locale.languageCode);
  /// }
  /// ```
  final ValueChanged<Locale>? onLocaleChanged;

  /// Async callback invoked *before* the locale state is updated.
  ///
  /// Use this to pre-load translations so that `Intl.defaultLocale` and
  /// message lookup tables are ready before the widget tree rebuilds.
  ///
  /// ```dart
  /// onBeforeLocaleChanged: (locale) => S.load(locale),
  /// ```
  final Future<void> Function(Locale)? onBeforeLocaleChanged;

  /// Creates a LocaleProvider.
  const LocaleProvider({
    super.key,
    required this.initialLocale,
    required this.child,
    this.onLocaleChanged,
    this.onBeforeLocaleChanged,
  });

  /// Get the LocaleProvider state from context.
  ///
  /// Throws an assertion error if no LocaleProvider is found.
  ///
  /// ```dart
  /// final provider = LocaleProvider.of(context);
  /// print(provider.currentLocale);
  /// ```
  static LocaleProviderState of(BuildContext context) {
    final state = context.findAncestorStateOfType<LocaleProviderState>();
    assert(state != null, 'No LocaleProvider found in context');
    return state!;
  }

  /// Try to get the LocaleProvider state from context.
  ///
  /// Returns null if no LocaleProvider is found.
  ///
  /// ```dart
  /// final provider = LocaleProvider.maybeOf(context);
  /// if (provider != null) {
  ///   print(provider.currentLocale);
  /// }
  /// ```
  static LocaleProviderState? maybeOf(BuildContext context) {
    return context.findAncestorStateOfType<LocaleProviderState>();
  }

  @override
  State<LocaleProvider> createState() => LocaleProviderState();
}

/// State for [LocaleProvider].
///
/// Access this state to get or change the current locale:
///
/// ```dart
/// final state = LocaleProvider.of(context);
/// print(state.currentLocale);
/// state.setLocale(const Locale('ar'));
/// ```
class LocaleProviderState extends State<LocaleProvider> {
  late Locale _currentLocale;

  /// The current locale.
  Locale get currentLocale => _currentLocale;

  @override
  void initState() {
    super.initState();
    _currentLocale = widget.initialLocale;
  }

  /// Change the current locale.
  ///
  /// This will trigger a rebuild of all widgets that depend on the locale
  /// and call [LocaleProvider.onLocaleChanged] if provided.
  ///
  /// If [LocaleProvider.onBeforeLocaleChanged] is provided, it will be
  /// awaited before the state is updated — this allows pre-loading
  /// translations so that `Intl.defaultLocale` is set before the rebuild.
  ///
  /// ```dart
  /// LocaleProvider.of(context).setLocale(const Locale('ar'));
  /// ```
  Future<void> setLocale(Locale locale) async {
    if (_currentLocale != locale) {
      await widget.onBeforeLocaleChanged?.call(locale);
      if (!mounted) return;
      setState(() {
        _currentLocale = locale;
      });
      widget.onLocaleChanged?.call(locale);
    }
  }

  /// Check if the current locale matches a language code.
  ///
  /// ```dart
  /// if (LocaleProvider.of(context).isLocale('ar')) {
  ///   // Current locale is Arabic
  /// }
  /// ```
  bool isLocale(String languageCode) {
    return _currentLocale.languageCode == languageCode;
  }

  @override
  Widget build(BuildContext context) {
    return _LocaleInheritedWidget(
      state: this,
      child: widget.child,
    );
  }
}

class _LocaleInheritedWidget extends InheritedWidget {
  final LocaleProviderState state;

  const _LocaleInheritedWidget({
    required this.state,
    required super.child,
  });

  @override
  bool updateShouldNotify(_LocaleInheritedWidget oldWidget) {
    return state._currentLocale != oldWidget.state._currentLocale;
  }
}

/// Extension for easy access to locale provider from BuildContext.
///
/// Instead of:
/// ```dart
/// LocaleProvider.of(context).currentLocale
/// LocaleProvider.of(context).setLocale(locale)
/// ```
///
/// You can use:
/// ```dart
/// context.currentLocale
/// context.setLocale(locale)
/// ```
extension LocaleProviderExtension on BuildContext {
  /// Get the current locale from LocaleProvider.
  ///
  /// ```dart
  /// final locale = context.currentLocale;
  /// ```
  Locale get currentLocale => LocaleProvider.of(this).currentLocale;

  /// Set a new locale via LocaleProvider.
  ///
  /// ```dart
  /// context.setLocale(const Locale('ar'));
  /// ```
  Future<void> setLocale(Locale locale) =>
      LocaleProvider.of(this).setLocale(locale);

  /// Check if the current locale matches a language code.
  ///
  /// ```dart
  /// if (context.isLocale('ar')) {
  ///   // Current locale is Arabic
  /// }
  /// ```
  bool isLocale(String languageCode) =>
      LocaleProvider.of(this).isLocale(languageCode);
}
