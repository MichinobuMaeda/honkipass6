import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'l10n/app_localizations.dart';
import 'honkipass.dart';

// 1. Create a provider for the theme mode
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);
final localeProvider = StateProvider<Locale>((ref) => const Locale('ja'));

void main() {
  // 2. Wrap the app in a ProviderScope
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 3. Watch the theme mode provider
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

    final themeData = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
    );
    final darkThemeData = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.teal,
        brightness: Brightness.dark,
      ),
    );

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

class ThemeMenuItem {
  const ThemeMenuItem({
    required this.mode,
    required this.label,
    required this.icon,
  });
  final ThemeMode mode;
  final String label;
  final IconData icon;
}

class LanguageMenuItem {
  const LanguageMenuItem({
    required this.locale,
    required this.label,
    required this.shortName,
  });
  final Locale locale;
  final String label;
  final String shortName;
}

class MyHomePage extends HookConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final themeList = [
      ThemeMenuItem(
        mode: ThemeMode.light,
        label: l10n.lightMode,
        icon: Icons.light_mode,
      ),
      ThemeMenuItem(
        mode: ThemeMode.dark,
        label: l10n.darkMode,
        icon: Icons.dark_mode,
      ),
      ThemeMenuItem(
        mode: ThemeMode.system,
        label: l10n.auto,
        icon: Icons.brightness_auto,
      ),
    ];

    const languageList = [
      LanguageMenuItem(locale: Locale('ja'), label: '日本語', shortName: '日'),
      LanguageMenuItem(locale: Locale('en'), label: 'English', shortName: 'En'),
    ];

    void setLocale(locale) {
      ref.read(localeProvider.notifier).state = locale;
    }

    void setThemeMode(mode) {
      ref.read(themeModeProvider.notifier).state = mode;
    }

    final currentThemeMode = ref.watch(themeModeProvider);
    final currentLocale = ref.watch(localeProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    const breakpointMobile = 480.0;
    final password = useState('test');
    final message = useState<String>(l10n.waiting);

    final lengthIndex = useState(lengthList.indexOf(defaultLength));
    final preset = useState(defaultPreset);
    final lowerCase = useState(defaultLowerCase);
    final upperCase = useState(defaultUpperCase);
    final numerics = useState(defaultNumerics);
    final symbols = useState(defaultSymbols);
    final allTypes = useState(defaultAllTypes);
    final uniqueChars = useState(defaultUniqueChars);
    final applyExcluded = useState(defaultApplyExcluded);
    final excludedChars = useState(defaultExcludedChars);

    final isChanged =
        lengthIndex.value != lengthList.indexOf(defaultLength) ||
        preset.value != defaultPreset ||
        lowerCase.value != defaultLowerCase ||
        upperCase.value != defaultUpperCase ||
        numerics.value != defaultNumerics ||
        symbols.value != defaultSymbols ||
        allTypes.value != defaultAllTypes ||
        uniqueChars.value != defaultUniqueChars ||
        applyExcluded.value != defaultApplyExcluded ||
        excludedChars.value != defaultExcludedChars;

    void onReset() {
      lengthIndex.value = lengthList.indexOf(defaultLength);
      preset.value = defaultPreset;
      lowerCase.value = defaultLowerCase;
      upperCase.value = defaultUpperCase;
      numerics.value = defaultNumerics;
      symbols.value = defaultSymbols;
      allTypes.value = defaultAllTypes;
      uniqueChars.value = defaultUniqueChars;
      applyExcluded.value = defaultApplyExcluded;
      excludedChars.value = defaultExcludedChars;
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        leading: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Image.asset('images/logo.png'),
        ),
        title: Text(
          l10n.appTitle,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        actions: [
          if (screenWidth < breakpointMobile)
            PopupMenuButton<dynamic>(
              icon: const Icon(Icons.more_vert),
              position: PopupMenuPosition.under,
              onSelected: (dynamic value) {
                if (value is Locale) {
                  setLocale(value);
                } else if (value is ThemeMode) {
                  setThemeMode(value);
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<dynamic>>[
                ...languageList.map(
                  (item) => PopupMenuItem<Locale>(
                    value: item.locale,
                    padding: EdgeInsets.zero,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      color: currentLocale == item.locale
                          ? Theme.of(context).colorScheme.secondaryContainer
                          : null,
                      child: Row(
                        children: [
                          const SizedBox(width: 24.0),
                          Text(item.label),
                        ],
                      ),
                    ),
                  ),
                ),
                const PopupMenuDivider(),
                ...themeList.map(
                  (item) => PopupMenuItem<ThemeMode>(
                    value: item.mode,
                    padding: EdgeInsets.zero,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      color: currentThemeMode == item.mode
                          ? Theme.of(context).colorScheme.secondaryContainer
                          : null,
                      child: Row(children: [Icon(item.icon), Text(item.label)]),
                    ),
                  ),
                ),
              ],
            )
          else ...[
            ...languageList.map(
              (item) => currentLocale == item.locale
                  ? IconButton.filledTonal(
                      icon: Text(item.shortName),
                      onPressed: () => setLocale(item.locale),
                    )
                  : IconButton(
                      icon: Text(item.shortName),
                      onPressed: () => setLocale(item.locale),
                    ),
            ),
            ...themeList.map(
              (item) => currentThemeMode == item.mode
                  ? IconButton.filledTonal(
                      icon: Icon(item.icon),
                      onPressed: () => setThemeMode(item.mode),
                    )
                  : IconButton(
                      icon: Icon(item.icon),
                      onPressed: () => setThemeMode(item.mode),
                    ),
            ),
          ],
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100.0),
          child: Container(
            color: Theme.of(context).colorScheme.surfaceContainerLowest,
            child: Center(
              child: SizedBox(
                width: 640,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    readOnly: true,
                    controller: useTextEditingController(text: password.value),
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: l10n.password,
                      helperText: message.value,
                      prefixIcon: IconButton(
                        icon: const Icon(Icons.content_copy),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: password.value))
                              .then((_) {
                                message.value = l10n.copied;
                              })
                              .catchError((_) {
                                message.value = l10n.failedToCopy;
                              });
                        },
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Center(
        child: SizedBox(
          width: 640,
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (screenWidth < breakpointMobile)
                            IconButton(
                              icon: const Icon(Icons.settings_backup_restore),
                              onPressed: isChanged ? onReset : null,
                            )
                          else
                            FilledButton.tonal(
                              onPressed: isChanged ? onReset : null,
                              style: ButtonStyle(
                                padding: WidgetStateProperty.all(
                                  EdgeInsets.symmetric(
                                    vertical: 8.0,
                                    horizontal: 16.0,
                                  ),
                                ),
                                shape: WidgetStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.settings_backup_restore),
                                  const SizedBox(width: 8.0),
                                  Text(l10n.reset),
                                ],
                              ),
                            ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  showValueIndicator:
                                      ShowValueIndicator.alwaysVisible,
                                ),
                                child: Slider(
                                  value: lengthIndex.value.toDouble(),
                                  min: 0,
                                  max: (lengthList.length - 1).toDouble(),
                                  divisions: lengthList.length - 1,
                                  onChanged: (value) {
                                    lengthIndex.value = value.toInt();
                                  },
                                  label: lengthList[lengthIndex.value]
                                      .toString(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      Text(
                        '© 2025 Michinobu Maeda',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
