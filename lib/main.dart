import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'l10n/app_localizations.dart';
import 'widgets/app_bar_action.dart';
import 'widgets/selectable_popup_menu_item.dart';
import 'widgets/toggle_button.dart';
import 'theme.dart';
import 'providers.dart';
import 'honkipass.dart';

const contentWidth = 640.0;
const contentPadding = 16.0;
final Uri githubUrl = Uri.parse('https://github.com/MichinobuMaeda/honkipass6');

void main() {
  runApp(ProviderScope(child: MyApp()));
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

    final screenWidth = MediaQuery.of(context).size.width;
    const breakpointMobile = 480.0;
    final message = useState<String>(l10n.generated);
    final passwordController = useTextEditingController(text: '');
    final password = useState<String>('');

    final prefs = ref.watch(prefsProvider);

    void generate() {
      final newPassword = generatePassword(
        ref.watch(honkipassParamProvider),
        ref.watch(charsetProvider),
      );
      if (newPassword == null) {
        message.value = l10n.retry;
      } else {
        password.value = newPassword;
        passwordController.text = newPassword;
        message.value = l10n.generated;
      }
    }

    useEffect(() {
      generate();
      return null;
    }, [ref.watch(honkipassParamProvider), ref.watch(charsetProvider)]);

    final excludedCharsController = useTextEditingController(
      text: ref.watch(excludedCharsProvider),
    );

    void copyPassword() {
      Clipboard.setData(ClipboardData(text: password.value))
          .then((_) {
            message.value = l10n.copied;
          })
          .catchError((_) {
            message.value = l10n.failedToCopy;
          });
    }

    Future<void> launchGithubUrl() async {
      if (!await launchUrl(githubUrl)) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not launch GitHub.')),
          );
        }
      }
    }

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
                      ref.read(localeProvider.notifier).setLocale(value);
                      prefs.setString('locale', value.toLanguageTag());
                    } else if (value is ThemeMode) {
                      ref.read(themeModeProvider.notifier).setThemeMode(value);
                      prefs.setInt(
                        'themeMode',
                        ThemeMode.values.indexOf(value),
                      );
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<dynamic>>[
                        ...languageList.map(
                          (item) => SelectablePopupMenuItem<Locale>(
                            value: item.locale,
                            label: Text(item.label),
                            isSelected:
                                ref.watch(localeProvider) == item.locale,
                          ),
                        ),
                        const PopupMenuDivider(),
                        ...themeList.map(
                          (item) => SelectablePopupMenuItem<ThemeMode>(
                            value: item.mode,
                            icon: Icon(item.icon),
                            label: Text(item.label),
                            isSelected:
                                ref.watch(themeModeProvider) == item.mode,
                          ),
                        ),
                      ],
                )
              else ...[
                ...languageList.map(
                  (item) => AppBarAction(
                    icon: Text(item.shortName),
                    isSelected: ref.watch(localeProvider) == item.locale,
                    onPressed: () {
                      ref.read(localeProvider.notifier).setLocale(item.locale);
                      prefs.setString('locale', item.locale.toLanguageTag());
                    },
                  ),
                ),
                ...themeList.map(
                  (item) => AppBarAction(
                    icon: Icon(item.icon),
                    isSelected: ref.watch(themeModeProvider) == item.mode,
                    onPressed: () {
                      ref
                          .read(themeModeProvider.notifier)
                          .setThemeMode(item.mode);
                      prefs.setInt(
                        'themeMode',
                        ThemeMode.values.indexOf(item.mode),
                      );
                    },
                  ),
                ),
              ],
              SizedBox(width: 4.0),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(84.0),
              child: Container(
                color: Theme.of(context).colorScheme.surfaceContainerLowest,
                child: Center(
                  child: SizedBox(
                    width: contentWidth,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: contentPadding,
                        vertical: 8.0,
                      ),
                      child: ValueListenableBuilder<String>(
                        valueListenable: message,
                        builder: (context, value, child) {
                          final isError = value == l10n.retry;
                          return TextFormField(
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
                                onPressed: () => generate(),
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
                    vertical: 8.0,
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
                                        ).colorScheme.errorContainer
                                      : ref.watch(charsetProvider).contains(c)
                                      ? null
                                      : Theme.of(
                                          context,
                                        ).colorScheme.secondaryContainer,
                                  color: ref.watch(charsetProvider).contains(c)
                                      ? null
                                      : Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      Row(
                        spacing: 16.0,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (screenWidth < breakpointMobile)
                            IconButton.filledTonal(
                              icon: const Icon(Icons.settings_backup_restore),
                              onPressed: ref.watch(isParamsChangedProvider)
                                  ? () => onParamsReset(ref)
                                  : null,
                            )
                          else
                            FilledButton.tonal(
                              onPressed: ref.watch(isParamsChangedProvider)
                                  ? () => onParamsReset(ref)
                                  : null,
                              child: Row(
                                spacing: 8.0,
                                children: [
                                  const Icon(Icons.settings_backup_restore),
                                  Text(l10n.reset),
                                ],
                              ),
                            ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 32.0),
                              child: Slider(
                                value: ref
                                    .watch(lengthIndexProvider)
                                    .toDouble(),
                                min: 0,
                                max: (lengthList.length - 1).toDouble(),
                                divisions: lengthList.length - 1,
                                onChanged: (value) {
                                  ref
                                      .read(lengthIndexProvider.notifier)
                                      .setLengthIndex(value);
                                  prefs.setInt(
                                    'length',
                                    ref.watch(lengthProvider),
                                  );
                                },
                                label: "${ref.watch(lengthProvider)}",
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
                            isSelected: ref.watch(presetProvider) == Preset.std,
                            onPressed: () {
                              ref
                                  .read(presetProvider.notifier)
                                  .setPreset(Preset.std);
                              prefs.setInt(
                                'preset',
                                Preset.values.indexOf(Preset.std),
                              );
                            },
                          ),
                          ToggleButton(
                            label: Text(l10n.ext(charSetExt.length)),
                            isSelected: ref.watch(presetProvider) == Preset.ext,
                            onPressed: () {
                              ref
                                  .read(presetProvider.notifier)
                                  .setPreset(Preset.ext);
                              prefs.setInt(
                                'preset',
                                Preset.values.indexOf(Preset.ext),
                              );
                            },
                          ),
                          ToggleButton(
                            label: Text(l10n.manual),
                            isSelected:
                                ref.watch(presetProvider) == Preset.manual,
                            onPressed: () {
                              ref
                                  .read(presetProvider.notifier)
                                  .setPreset(Preset.manual);
                              prefs.setInt(
                                'preset',
                                Preset.values.indexOf(Preset.manual),
                              );
                            },
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
                            isSelected: ref.watch(upperCaseProvider),
                            onPressed:
                                ref.watch(presetProvider) == Preset.manual
                                ? () {
                                    ref
                                        .read(upperCaseProvider.notifier)
                                        .toggle();
                                    prefs.setBool(
                                      'upperCase',
                                      ref.watch(upperCaseProvider),
                                    );
                                  }
                                : null,
                          ),
                          ToggleButton(
                            label: Text('abc'),
                            isSelected: ref.watch(lowerCaseProvider),
                            onPressed:
                                ref.watch(presetProvider) == Preset.manual
                                ? () {
                                    ref
                                        .read(lowerCaseProvider.notifier)
                                        .toggle();
                                    prefs.setBool(
                                      'lowerCase',
                                      ref.watch(lowerCaseProvider),
                                    );
                                  }
                                : null,
                          ),
                          ToggleButton(
                            label: Text('123'),
                            isSelected: ref.watch(numericsProvider),
                            onPressed:
                                ref.watch(presetProvider) == Preset.manual
                                ? () {
                                    ref
                                        .read(numericsProvider.notifier)
                                        .toggle();
                                    prefs.setBool(
                                      'numerics',
                                      ref.watch(numericsProvider),
                                    );
                                  }
                                : null,
                          ),
                          ToggleButton(
                            label: Text('@#\$'),
                            isSelected: ref.watch(symbolsProvider),
                            onPressed:
                                ref.watch(presetProvider) == Preset.manual
                                ? () {
                                    ref.read(symbolsProvider.notifier).toggle();
                                    prefs.setBool(
                                      'symbols',
                                      ref.watch(symbolsProvider),
                                    );
                                  }
                                : null,
                          ),
                        ],
                      ),
                      Row(
                        spacing: 16.0,
                        children: [
                          Expanded(
                            child: TextField(
                              controller: excludedCharsController,
                              enabled:
                                  ref.watch(presetProvider) == Preset.manual,
                              onChanged: (value) {
                                ref
                                    .read(excludedCharsProvider.notifier)
                                    .setExcludedChars(value);
                                prefs.setString(
                                  'excludedChars',
                                  ref.watch(excludedCharsProvider),
                                );
                              },
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                labelText: l10n.excludedChars,
                              ),
                              style: TextStyle(fontFamily: 'Monospace'),
                            ),
                          ),
                          Switch(
                            value: ref.watch(applyExcludedProvider),
                            onChanged:
                                ref.watch(presetProvider) == Preset.manual
                                ? (_) {
                                    ref
                                        .read(applyExcludedProvider.notifier)
                                        .toggle();
                                    prefs.setBool(
                                      'applyExcluded',
                                      ref.watch(applyExcludedProvider),
                                    );
                                  }
                                : null,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(child: Text(l10n.allTypes)),
                          Switch(
                            value: ref.watch(allTypesProvider),
                            onChanged: (_) {
                              ref.read(allTypesProvider.notifier).toggle();
                              prefs.setBool(
                                'allTypes',
                                ref.watch(allTypesProvider),
                              );
                            },
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(child: Text(l10n.uniqueChars)),
                          Switch(
                            value: ref.watch(uniqueCharsProvider),
                            onChanged: (_) {
                              ref.read(uniqueCharsProvider.notifier).toggle();
                              prefs.setBool(
                                'uniqueChars',
                                ref.watch(uniqueCharsProvider),
                              );
                            },
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
                          ref
                              .watch(packageInfoProvider)
                              .when(
                                data: (info) => Text(
                                  'v${info.version}+${info.buildNumber}',
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
