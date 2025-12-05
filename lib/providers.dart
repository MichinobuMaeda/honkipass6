import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:honkipass6/l10n/app_localizations.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'honkipass.dart';

part 'providers.g.dart';

const defaultThemeMode = ThemeMode.system;
const defaultLocaleName = 'ja';

final packageInfoProvider = FutureProvider<PackageInfo>(
  (ref) => PackageInfo.fromPlatform(),
);

final prefsProvider = Provider<SharedPreferencesAsync>(
  (ref) => SharedPreferencesAsync(options: SharedPreferencesOptions()),
);

@riverpod
class ThemeModeNotifier extends _$ThemeModeNotifier {
  @override
  ThemeMode build() => defaultThemeMode;

  setThemeMode(mode) => state = mode;
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

List<ThemeMenuItem> themeList(AppLocalizations l10n) => [
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

@riverpod
class LocaleNotifier extends _$LocaleNotifier {
  @override
  Locale build() => const Locale(defaultLocaleName);

  setLocale(locale) => state = locale;
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

const languageList = [
  LanguageMenuItem(locale: Locale('ja'), label: '日本語', shortName: '日'),
  LanguageMenuItem(locale: Locale('en'), label: 'English', shortName: 'En'),
];

@riverpod
class LengthIndexNotifier extends _$LengthIndexNotifier {
  @override
  int build() => lengthList.indexOf(defaultLength);

  setLengthIndex(value) => state = value;
  reset() => state = lengthList.indexOf(defaultLength);
}

final lengthProvider = Provider<int>(
  (ref) => lengthList[ref.watch(lengthIndexProvider)],
);

@riverpod
class PresetNotifier extends _$PresetNotifier {
  @override
  Preset build() => defaultPreset;

  setPreset(preset) => state = preset;
  reset() => state = defaultPreset;
}

@riverpod
class UpperCaseNotifier extends _$UpperCaseNotifier {
  @override
  bool build() => defaultUpperCase;

  setUpperCase(value) => state = value;
  toggle() => state = !state;
  reset() => state = defaultUpperCase;
}

@riverpod
class LowerCaseNotifier extends _$LowerCaseNotifier {
  @override
  bool build() => defaultLowerCase;

  setLowerCase(value) => state = value;
  toggle() => state = !state;
  reset() => state = defaultLowerCase;
}

@riverpod
class NumericsNotifier extends _$NumericsNotifier {
  @override
  bool build() => defaultNumerics;

  setNumerics(value) => state = value;
  toggle() => state = !state;
  reset() => state = defaultNumerics;
}

@riverpod
class SymbolsNotifier extends _$SymbolsNotifier {
  @override
  bool build() => defaultSymbols;

  setSymbols(value) => state = value;
  toggle() => state = !state;
  reset() => state = defaultSymbols;
}

@riverpod
class AllTypesNotifier extends _$AllTypesNotifier {
  @override
  bool build() => defaultAllTypes;

  setAllTypes(value) => state = value;
  toggle() => state = !state;
  reset() => state = defaultAllTypes;
}

@riverpod
class UniqueCharsNotifier extends _$UniqueCharsNotifier {
  @override
  bool build() => defaultUniqueChars;

  setUniqueChars(value) => state = value;
  toggle() => state = !state;
  reset() => state = defaultUniqueChars;
}

@riverpod
class ApplyExcludedNotifier extends _$ApplyExcludedNotifier {
  @override
  bool build() => defaultApplyExcluded;

  setApplyExcluded(value) => state = value;
  toggle() => state = !state;
  reset() => state = defaultApplyExcluded;
}

@riverpod
class ExcludedCharsNotifier extends _$ExcludedCharsNotifier {
  @override
  String build() => defaultExcludedChars;

  setExcludedChars(str) => state = str;
  reset() => state = defaultExcludedChars;
}

final excludesTextEditingControllerProvider = Provider<TextEditingController>(
  (ref) => TextEditingController(text: defaultExcludedChars),
);

final honkipassParamProvider = Provider<HonkipassParam>(
  (ref) => HonkipassParam(
    length: ref.watch(lengthProvider),
    preset: ref.watch(presetProvider),
    lowerCase: ref.watch(lowerCaseProvider),
    upperCase: ref.watch(upperCaseProvider),
    numerics: ref.watch(numericsProvider),
    symbols: ref.watch(symbolsProvider),
    allTypes: ref.watch(allTypesProvider),
    uniqueChars: ref.watch(uniqueCharsProvider),
    applyExcluded: ref.watch(applyExcludedProvider),
    excludedChars: ref.watch(excludedCharsProvider),
  ),
);

final charsetProvider = Provider<String>(
  (ref) => generateChars(ref.watch(honkipassParamProvider)),
);

@riverpod
class PasswordNotifier extends _$PasswordNotifier {
  @override
  String build() => initialPassword;

  setPassword(password) => state = password;
}

final passwordTextEditingControllerProvider = Provider<TextEditingController>(
  (ref) => TextEditingController(text: initialPassword),
);

@riverpod
class PasswordGenerateRequestNotifier
    extends _$PasswordGenerateRequestNotifier {
  @override
  bool build() => false;

  request() => state = !state;
}

enum Message { wait, generated, retry, copied, failedToCopy }

@riverpod
class MessageNotifier extends _$MessageNotifier {
  @override
  Message build() => Message.wait;

  setMessage(message) => state = message;
}

@riverpod
class PreferencesInitializedNotifier extends _$PreferencesInitializedNotifier {
  @override
  bool build() => false;

  touch() => state = true;
}

final isParamsChangedProvider = Provider<bool>(
  (ref) =>
      ref.watch(lengthProvider) != defaultLength ||
      ref.watch(presetProvider) != defaultPreset ||
      ref.watch(lowerCaseProvider) != defaultLowerCase ||
      ref.watch(upperCaseProvider) != defaultUpperCase ||
      ref.watch(numericsProvider) != defaultNumerics ||
      ref.watch(symbolsProvider) != defaultSymbols ||
      ref.watch(allTypesProvider) != defaultAllTypes ||
      ref.watch(uniqueCharsProvider) != defaultUniqueChars ||
      ref.watch(applyExcludedProvider) != defaultApplyExcluded ||
      ref.watch(excludedCharsProvider) != defaultExcludedChars,
);

void onParamsReset(WidgetRef ref) {
  ref.read(lengthIndexProvider.notifier).reset();
  ref.read(presetProvider.notifier).reset();
  ref.read(lowerCaseProvider.notifier).reset();
  ref.read(upperCaseProvider.notifier).reset();
  ref.read(numericsProvider.notifier).reset();
  ref.read(symbolsProvider.notifier).reset();
  ref.read(allTypesProvider.notifier).reset();
  ref.read(uniqueCharsProvider.notifier).reset();
  ref.read(applyExcludedProvider.notifier).reset();
  ref.read(excludedCharsProvider.notifier).reset();
  ref.read(excludesTextEditingControllerProvider).text = defaultExcludedChars;
}

final class UserActionObserver extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    final ref = context.container;

    if (newValue is HonkipassParam ||
        context.provider == passwordGenerateRequestProvider) {
      debugPrint("params changed");
      final newPassword = generatePassword(
        ref.read(honkipassParamProvider),
        ref.read(charsetProvider),
      );

      if (newPassword == null) {
        ref.read(messageProvider.notifier).setMessage(Message.retry);
      } else {
        debugPrint("new password $newPassword");
        ref.read(passwordProvider.notifier).setPassword(newPassword);
        ref.read(passwordTextEditingControllerProvider).text = newPassword;
        ref.read(messageProvider.notifier).setMessage(Message.generated);
      }
    }
  }
}
