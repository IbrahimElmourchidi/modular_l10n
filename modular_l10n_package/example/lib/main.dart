import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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

  void _changeLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LocaleProvider(
      initialLocale: _locale,
      onLocaleChanged: _changeLocale,
      child: MaterialApp(
        title: 'Modular L10n Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        
        // Set the current locale
        locale: _locale,
        
        // Add supported locales
        supportedLocales: S.supportedLocales,
        
        // Add localization delegates
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        
        home: const HomePage(),
        
        // Handle text direction for RTL languages
        builder: (context, child) {
          return Directionality(
            textDirection: LocaleUtils.getTextDirection(_locale),
            child: child!,
          );
        },
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Using home module translation
        title: Text(S.home.title),
        actions: [
          // Language switcher
          PopupMenuButton<Locale>(
            icon: const Icon(Icons.language),
            tooltip: 'Change Language',
            onSelected: (locale) {
              context.setLocale(locale);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: Locale('en'),
                child: Row(
                  children: [
                    Text('🇺🇸 '),
                    SizedBox(width: 8),
                    Text('English'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: Locale('ar'),
                child: Row(
                  children: [
                    Text('🇸🇦 '),
                    SizedBox(width: 8),
                    Text('العربية'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current locale info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(
                      context.currentLocale.isRtl
                          ? Icons.format_textdirection_r_to_l
                          : Icons.format_textdirection_l_to_r,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Current: ${context.currentLocale.displayName} (${context.currentLocale.nativeName})',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Home Module Demo
            Text(
              'Home Module',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            
            // Using home module translations
            Text(
              S.home.welcomeMessage,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            
            // Using translation with parameters
            Text(
              S.home.greeting('morning', 'Ahmed'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            
            // Using pluralization
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pluralization Demo:',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    Text('• ${S.home.itemCount(0)}'),
                    Text('• ${S.home.itemCount(1)}'),
                    Text('• ${S.home.itemCount(5)}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Search field with placeholder
            TextField(
              decoration: InputDecoration(
                hintText: S.home.searchPlaceholder,
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 32),
            
            const Divider(),
            const SizedBox(height: 16),
            
            // Auth Module Demo
            Text(
              'Auth Module',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            
            // Using auth module translations
            TextField(
              decoration: InputDecoration(
                labelText: S.auth.email,
                prefixIcon: const Icon(Icons.email),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: S.auth.password,
                prefixIcon: const Icon(Icons.lock),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.login),
                label: Text(S.auth.login),
              ),
            ),
            const SizedBox(height: 8),
            
            Center(
              child: TextButton(
                onPressed: () {},
                child: Text(S.auth.forgotPassword),
              ),
            ),
            const SizedBox(height: 16),
            
            // Welcome message with parameter
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.waving_hand,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        S.auth.welcomeBack('Ahmed'),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
