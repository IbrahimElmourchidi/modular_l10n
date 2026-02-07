import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:modular_l10n/modular_l10n.dart';

// This example demonstrates how to use the modular_l10n package
// with your generated ML localization class

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Current locale - manage this with your preferred state management
  Locale _currentLocale = const Locale('en');

  @override
  void initState() {
    super.initState();
    _initializeLocale();
  }

  Future<void> _initializeLocale() async {
    // In a real app, you would:
    // 1. Load saved locale from SharedPreferences
    // 2. Or get device locale
    // 3. Find best match from supported locales
    // 4. Load the ML translations

    // Example:
    // final savedLocale = await loadSavedLocale();
    // final deviceLocale = WidgetsBinding.instance.window.locale;
    // final bestMatch = LocaleUtils.findBestMatch(
    //   savedLocale ?? deviceLocale,
    //   ML.supportedLocales,
    // );
    // await ML.load(bestMatch ?? ML.supportedLocales.first);
    // setState(() => _currentLocale = bestMatch ?? ML.supportedLocales.first);
  }

  Future<void> _changeLocale(Locale locale) async {
    if (_currentLocale != locale) {
      // Load new locale translations
      // await ML.load(locale);

      setState(() {
        _currentLocale = locale;
      });

      // Optionally save to SharedPreferences
      // await saveLocale(locale);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Modular L10n Example',
      locale: _currentLocale,
      // In real app, use: supportedLocales: ML.supportedLocales,
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
        Locale('de'),
        Locale('es'),
        Locale('zh', 'CN'),
        Locale('ja'),
      ],
      localizationsDelegates: const [
        // ML.delegate, // Your generated delegate
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) {
        // Automatically handle RTL/LTR text direction
        return Directionality(
          textDirection: _currentLocale.textDirection,
          child: child!,
        );
      },
      home: HomePage(
        currentLocale: _currentLocale,
        onLocaleChanged: _changeLocale,
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.currentLocale,
    required this.onLocaleChanged,
  });
  final Locale currentLocale;
  final ValueChanged<Locale> onLocaleChanged;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modular L10n Example'),
        actions: [
          // Locale switcher in app bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: LocaleSwitcherButton(
              currentLocale: currentLocale,
              onLocaleChanged: onLocaleChanged,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Locale Info
            const _SectionTitle('Current Locale Info'),
            _InfoCard(
              children: [
                _InfoRow('Language Code', currentLocale.languageCode),
                _InfoRow('Country Code', currentLocale.countryCode ?? 'N/A'),
                _InfoRow('Display Name', currentLocale.displayName),
                _InfoRow('Native Name', currentLocale.nativeName),
                _InfoRow('Is RTL', currentLocale.isRtl ? 'Yes' : 'No'),
                _InfoRow(
                  'Text Direction',
                  currentLocale.textDirection == TextDirection.rtl
                      ? 'RTL'
                      : 'LTR',
                ),
              ],
            ),

            const SizedBox(height: 24),

            // RTL Demo
            const _SectionTitle('RTL Layout Demo'),
            const _InfoCard(
              children: [
                Text(
                  'This row will automatically flip for RTL languages:',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.arrow_forward),
                    SizedBox(width: 8),
                    Text('Next'),
                    Spacer(),
                    Text('Previous'),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_back),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Available Locales
            const _SectionTitle('Available Locales'),
            _LocalesList(
              currentLocale: currentLocale,
              onLocaleChanged: onLocaleChanged,
            ),

            const SizedBox(height: 24),

            // Locale Parsing Demo
            const _SectionTitle('Locale Parsing Demo'),
            const _InfoCard(
              children: [
                _ParsingExample('en', 'Simple language code'),
                Divider(height: 24),
                _ParsingExample('en_US', 'Language + country (underscore)'),
                Divider(height: 24),
                _ParsingExample('en-GB', 'Language + country (hyphen)'),
                Divider(height: 24),
                _ParsingExample('zh_Hans_CN', 'Language + script + country'),
                Divider(height: 24),
                _ParsingExample('sr_Latn_RS', 'Serbian Latin'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class LocaleSwitcherButton extends StatelessWidget {
  const LocaleSwitcherButton({
    super.key,
    required this.currentLocale,
    required this.onLocaleChanged,
  });
  final Locale currentLocale;
  final ValueChanged<Locale> onLocaleChanged;

  @override
  Widget build(BuildContext context) {
    // In real app, use: ML.supportedLocales
    const supportedLocales = [
      Locale('en'),
      Locale('ar'),
      Locale('de'),
      Locale('es'),
      Locale('zh', 'CN'),
      Locale('ja'),
    ];

    return PopupMenuButton<Locale>(
      icon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            currentLocale.languageCode.toUpperCase(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          if (currentLocale.isRtl) ...[
            const SizedBox(width: 4),
            const Icon(Icons.format_textdirection_r_to_l, size: 16),
          ],
        ],
      ),
      itemBuilder: (context) {
        return supportedLocales.map((locale) {
          return PopupMenuItem<Locale>(
            value: locale,
            child: Row(
              children: [
                Text(locale.nativeName),
                const Spacer(),
                if (locale.isRtl)
                  const Icon(Icons.format_textdirection_r_to_l, size: 16),
                if (locale == currentLocale)
                  const Icon(Icons.check, size: 16, color: Colors.green),
              ],
            ),
          );
        }).toList();
      },
      onSelected: onLocaleChanged,
    );
  }
}

class _LocalesList extends StatelessWidget {
  const _LocalesList({
    required this.currentLocale,
    required this.onLocaleChanged,
  });
  final Locale currentLocale;
  final ValueChanged<Locale> onLocaleChanged;

  @override
  Widget build(BuildContext context) {
    // In real app, use: ML.supportedLocales
    const supportedLocales = [
      Locale('en'),
      Locale('ar'),
      Locale('de'),
      Locale('es'),
      Locale('fr'),
      Locale('zh', 'CN'),
      Locale('ja'),
      Locale('ko'),
      Locale('ru'),
      Locale('hi'),
    ];

    return Card(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: supportedLocales.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final locale = supportedLocales[index];
          final isSelected = locale == currentLocale;

          return ListTile(
            selected: isSelected,
            leading: CircleAvatar(
              child: Text(locale.languageCode.toUpperCase()),
            ),
            title: Text(locale.nativeName),
            subtitle: Text(locale.displayName),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (locale.isRtl)
                  const Icon(Icons.format_textdirection_r_to_l, size: 16),
                if (isSelected) const Icon(Icons.check, color: Colors.green),
              ],
            ),
            onTap: () => onLocaleChanged(locale),
          );
        },
      ),
    );
  }
}

class _ParsingExample extends StatelessWidget {
  const _ParsingExample(this.input, this.description);
  final String input;
  final String description;

  @override
  Widget build(BuildContext context) {
    final parsed = LocaleUtils.parseLocale(input);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          description,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Input: "$input"',
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Output: ${parsed.toString()}',
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
