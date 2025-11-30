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
                  ref.read(localeProvider.notifier).state = value;
                } else if (value is ThemeMode) {
                  ref.read(themeModeProvider.notifier).state = value;
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
              (item) => IconButton(
                icon: Text(item.shortName),
                isSelected: currentLocale == item.locale,
                onPressed: () {
                  ref.read(localeProvider.notifier).state = item.locale;
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith<Color?>((
                    states,
                  ) {
                    if (states.contains(WidgetState.selected)) {
                      return Theme.of(context).colorScheme.secondaryContainer;
                    }
                    return null;
                  }),
                ),
              ),
            ),
            ...themeList.map(
              (item) => IconButton(
                icon: Icon(item.icon),
                isSelected: currentThemeMode == item.mode,
                onPressed: () {
                  ref.read(themeModeProvider.notifier).state = item.mode;
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith<Color?>((
                    states,
                  ) {
                    if (states.contains(WidgetState.selected)) {
                      return Theme.of(context).colorScheme.secondaryContainer;
                    }
                    return null;
                  }),
                ),
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
                          IconButton.filledTonal(
                            icon: const Icon(Icons.settings_backup_restore),
                            onPressed: null,
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
