import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'l10n/app_localizations.dart';
import 'theme.dart';
import 'providers.dart';
import 'preferences.dart';
import 'sections/header.dart';
import 'sections/char_map.dart';
import 'sections/reset.dart';
import 'sections/length.dart';
import 'sections/presets.dart';
import 'sections/char_types.dart';
import 'sections/excludes.dart';
import 'sections/all_types.dart';
import 'sections/unique_chars.dart';
import 'sections/footer.dart';

void main() {
  runApp(ProviderScope(observers: [UserActionObserver()], child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    initPreferences(ref);
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,
      themeMode: themeMode,
      theme: themeData,
      darkTheme: darkThemeData,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          Header(),
          SliverToBoxAdapter(
            child: Center(
              child: SizedBox(
                width: contentWidth,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: contentPadding,
                    vertical: 8.0,
                  ),
                  child: Column(
                    spacing: 16.0,
                    children: [
                      CharMap(),
                      Row(
                        spacing: 16.0,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Reset(),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 32.0),
                              child: Length(),
                            ),
                          ),
                        ],
                      ),
                      Presets(),
                      CharTypes(),
                      Excludes(),
                      AllTypes(),
                      UniqueChars(),
                      Footer(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
