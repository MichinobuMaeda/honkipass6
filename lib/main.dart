import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'l10n/app_localizations.dart';
import 'widgets/app_bar_action.dart';
import 'widgets/selectable_popup_menu_item.dart';
import 'widgets/toggle_button.dart';
import 'theme.dart';
import 'honkipass.dart';

const contentWidth = 640.0;
const contentPadding = 16.0;

final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);
final localeProvider = StateProvider<Locale>((ref) => const Locale('ja'));
final packageInfoProvider = FutureProvider<PackageInfo>((ref) async {
  return await PackageInfo.fromPlatform();
});

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
    final packageInfo = ref.watch(packageInfoProvider);
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
    final charset = useState<String>(generateChars(HonkipassParam()));
    final password = useState(
      generatePassword(HonkipassParam(), charset.value),
    );
    final message = useState<String>(l10n.generated);
    final passwordController = useTextEditingController(text: password.value);

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
    final excludedCharsController = useTextEditingController(
      text: excludedChars.value,
    );

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

    void calc() {
      final param = HonkipassParam(
        length: lengthList[lengthIndex.value],
        preset: preset.value,
        lowerCase: lowerCase.value,
        upperCase: upperCase.value,
        numerics: numerics.value,
        symbols: symbols.value,
        allTypes: allTypes.value,
        uniqueChars: uniqueChars.value,
        applyExcluded: applyExcluded.value,
        excludedChars: excludedChars.value,
      );

      charset.value = generateChars(param);
      final newPassword = generatePassword(param, charset.value);
      if (newPassword.isNotEmpty) {
        password.value = newPassword;
        passwordController.text = newPassword;
        message.value = l10n.generated;
      } else {
        message.value = l10n.retry;
      }
    }

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
      excludedCharsController.text = defaultExcludedChars;
      calc();
    }

    void copyPassword() {
      Clipboard.setData(ClipboardData(text: password.value))
          .then((_) {
            message.value = l10n.copied;
          })
          .catchError((_) {
            message.value = l10n.failedToCopy;
          });
    }

    final Uri githubUrl = Uri.parse(
      'https://github.com/MichinobuMaeda/honkipass6',
    );

    Future<void> launchGithubUrl() async {
      if (!await launchUrl(githubUrl)) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not launch GitHub.')),
          );
        }
      }
    }

    useEffect(
      () {
        calc();
        return null;
      },
      [
        lengthIndex.value,
        preset.value,
        lowerCase.value,
        upperCase.value,
        numerics.value,
        symbols.value,
        allTypes.value,
        uniqueChars.value,
        applyExcluded.value,
        excludedChars.value,
      ],
    );

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            snap: false,
            floating: true,
            // elevation: 8.0,
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
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<dynamic>>[
                        ...languageList.map(
                          (item) =>
                              SelectablePopupMenuItem<Locale>(
                                    value: item.locale,
                                    icon: Text(item.shortName),
                                    label: Text(item.label),
                                    isSelected: currentLocale == item.locale,
                                  )
                                  as PopupMenuItem<Locale>,
                        ),
                        const PopupMenuDivider(),
                        ...themeList.map(
                          (item) =>
                              SelectablePopupMenuItem<ThemeMode>(
                                    value: item.mode,
                                    icon: Icon(item.icon),
                                    label: Text(item.label),
                                    isSelected: currentThemeMode == item.mode,
                                  )
                                  as PopupMenuItem<ThemeMode>,
                        ),
                      ],
                )
              else ...[
                ...languageList.map(
                  (item) => AppBarAction(
                    icon: Text(item.shortName),
                    isSelected: currentLocale == item.locale,
                    onPressed: () => setLocale(item.locale),
                  ),
                ),
                ...themeList.map(
                  (item) => AppBarAction(
                    icon: Icon(item.icon),
                    isSelected: currentThemeMode == item.mode,
                    onPressed: () => setThemeMode(item.mode),
                  ),
                ),
              ],
              SizedBox(width: 4.0),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(94.0),
              child: Container(
                color: Theme.of(context).colorScheme.surfaceContainerLowest,
                child: Center(
                  child: SizedBox(
                    width: contentWidth,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: contentPadding,
                        vertical: 12.0,
                      ),
                      child: ValueListenableBuilder<String>(
                        valueListenable: message,
                        builder: (context, value, child) {
                          final isError = value == l10n.retry;
                          return TextField(
                            readOnly: true,
                            controller: passwordController,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: l10n.password,
                              helperText: value,
                              helperStyle: isError
                                  ? TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.error,
                                    )
                                  : null,
                              enabledBorder: isError
                                  ? OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.error,
                                      ),
                                    )
                                  : null,
                              focusedBorder: isError
                                  ? OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.error,
                                        width: 2.0,
                                      ),
                                    )
                                  : null,
                              prefixIcon: IconButton(
                                icon: const Icon(Icons.content_copy),
                                onPressed: copyPassword,
                              ),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.refresh),
                                onPressed: calc,
                              ),
                            ),
                            style: TextStyle(
                              fontFamily: 'Monospace',
                              color: isError
                                  ? Theme.of(context).colorScheme.error
                                  : null,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Center(
              child: SizedBox(
                width: contentWidth,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: contentPadding,
                  ),
                  child: Column(
                    spacing: 16.0,
                    children: [
                      Wrap(
                        alignment: WrapAlignment.start,
                        spacing: 1.0,
                        children: charSetAll
                            .split('')
                            .toList()
                            .map(
                              (c) => Text(
                                c,
                                style: TextStyle(
                                  fontFamily: 'Monospace',
                                  fontSize: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.fontSize,
                                  backgroundColor: password.value.contains(c)
                                      ? Theme.of(
                                          context,
                                        ).colorScheme.tertiaryContainer
                                      : charset.value.contains(c)
                                      ? null
                                      : Theme.of(
                                          context,
                                        ).colorScheme.inverseSurface,
                                  color: charset.value.contains(c)
                                      ? null
                                      : Theme.of(
                                          context,
                                        ).colorScheme.onInverseSurface,
                                ),
                              ),
                            )
                            .toList(),
                      ),
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
                              child: Row(
                                children: [
                                  const Icon(Icons.settings_backup_restore),
                                  const SizedBox(width: 8.0),
                                  Text(l10n.reset),
                                ],
                              ),
                            ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 32.0),
                              child: Slider(
                                value: lengthIndex.value.toDouble(),
                                min: 0,
                                max: (lengthList.length - 1).toDouble(),
                                divisions: lengthList.length - 1,
                                onChanged: (value) {
                                  lengthIndex.value = value.toInt();
                                },
                                label: lengthList[lengthIndex.value].toString(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Wrap(
                        direction: Axis.horizontal,
                        alignment: WrapAlignment.center,
                        spacing: 4.0,
                        children: [
                          ToggleButton(
                            label: Text(l10n.std(charSetStd.length)),
                            isSelected: preset.value == Preset.std,
                            onPressed: () => preset.value = Preset.std,
                          ),
                          ToggleButton(
                            label: Text(l10n.ext(charSetExt.length)),
                            isSelected: preset.value == Preset.ext,
                            onPressed: () => preset.value = Preset.ext,
                          ),
                          ToggleButton(
                            label: Text(l10n.manual),
                            isSelected: preset.value == Preset.manual,
                            onPressed: () => preset.value = Preset.manual,
                          ),
                        ],
                      ),
                      Wrap(
                        direction: Axis.horizontal,
                        alignment: WrapAlignment.center,
                        spacing: 4.0,
                        children: [
                          ToggleButton(
                            label: Text('ABC'),
                            isSelected: upperCase.value,
                            onPressed: preset.value == Preset.manual
                                ? () => upperCase.value = !upperCase.value
                                : null,
                          ),
                          ToggleButton(
                            label: Text('abc'),
                            isSelected: lowerCase.value,
                            onPressed: preset.value == Preset.manual
                                ? () => lowerCase.value = !lowerCase.value
                                : null,
                          ),
                          ToggleButton(
                            label: Text('123'),
                            isSelected: numerics.value,
                            onPressed: preset.value == Preset.manual
                                ? () => numerics.value = !numerics.value
                                : null,
                          ),
                          ToggleButton(
                            label: Text('@#\$'),
                            isSelected: symbols.value,
                            onPressed: preset.value == Preset.manual
                                ? () => symbols.value = !symbols.value
                                : null,
                          ),
                        ],
                      ),
                      Row(
                        spacing: 12.0,
                        children: [
                          Expanded(
                            child: TextField(
                              controller: excludedCharsController,
                              enabled: preset.value == Preset.manual,
                              onChanged: (value) {
                                excludedChars.value = value;
                              },
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                labelText: l10n.excludedChars,
                              ),
                              style: TextStyle(fontFamily: 'Monospace'),
                            ),
                          ),
                          Switch(
                            value: applyExcluded.value,
                            onChanged: preset.value == Preset.manual
                                ? (value) => applyExcluded.value = value
                                : null,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(child: Text(l10n.allTypes)),
                          Switch(
                            value: allTypes.value,
                            onChanged: (value) => allTypes.value = value,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(child: Text(l10n.uniqueChars)),
                          Switch(
                            value: uniqueChars.value,
                            onChanged: (value) => uniqueChars.value = value,
                          ),
                        ],
                      ),
                      Wrap(
                        spacing: 16.0,
                        runSpacing: 4.0,
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            '© 2025 Michinobu Maeda',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          TextButton(
                            onPressed: launchGithubUrl,
                            child: const Text('GitHub'),
                          ),
                          packageInfo.when(
                            data: (info) => Text(
                              'v${info.version}(${info.buildNumber})',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            loading: () => const Text(''),
                            error: (e, s) => const Text(''),
                          ),
                        ],
                      ),
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
