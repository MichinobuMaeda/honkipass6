import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

@riverpod
class LocaleNotifier extends _$LocaleNotifier {
  @override
  Locale build() => const Locale(defaultLocaleName);

  setLocale(locale) => state = locale;
}

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

Future<void> initPreferences(WidgetRef ref) async {
  if (!ref.watch(preferencesInitializedProvider)) {
    final prefs = ref.watch(prefsProvider);
    debugPrint('start load preferences');
    ref
        .read(lengthIndexProvider.notifier)
        .setLengthIndex(
          lengthList.indexOf(await prefs.getInt('length') ?? defaultLength),
        );
    ref
        .read(presetProvider.notifier)
        .setPreset(Preset.values[await prefs.getInt('preset') ?? 0]);
    ref
        .read(upperCaseProvider.notifier)
        .setUpperCase(await prefs.getBool('upperCase') ?? defaultUpperCase);
    ref
        .read(lowerCaseProvider.notifier)
        .setLowerCase(await prefs.getBool('lowerCase') ?? defaultLowerCase);
    ref
        .read(numericsProvider.notifier)
        .setNumerics(await prefs.getBool('numerics') ?? defaultNumerics);
    ref
        .read(symbolsProvider.notifier)
        .setSymbols(await prefs.getBool('symbols') ?? defaultSymbols);
    ref
        .read(allTypesProvider.notifier)
        .setAllTypes(await prefs.getBool('allTypes') ?? defaultAllTypes);
    ref
        .read(uniqueCharsProvider.notifier)
        .setUniqueChars(
          await prefs.getBool('uniqueChars') ?? defaultUniqueChars,
        );
    ref
        .read(applyExcludedProvider.notifier)
        .setApplyExcluded(
          await prefs.getBool('applyExcluded') ?? defaultApplyExcluded,
        );
    ref
        .read(excludedCharsProvider.notifier)
        .setExcludedChars(
          await prefs.getString('excludedChars') ?? defaultExcludedChars,
        );
    ref
        .read(themeModeProvider.notifier)
        .setThemeMode(
          ThemeMode.values[await prefs.getInt('themeMode') ??
              ThemeMode.values.indexOf(defaultThemeMode)],
        );
    ref
        .read(localeProvider.notifier)
        .setLocale(
          Locale(await prefs.getString('locale') ?? defaultLocaleName),
        );
    ref.read(preferencesInitializedProvider.notifier).touch();
    debugPrint('end   load preferences');
  }
}

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

  final prefs = ref.watch(prefsProvider);
  prefs.remove('length');
  prefs.remove('preset');
  prefs.remove('upperCase');
  prefs.remove('lowerCase');
  prefs.remove('numerics');
  prefs.remove('symbols');
  prefs.remove('allTypes');
  prefs.remove('uniqueChars');
  prefs.remove('applyExcluded');
  prefs.remove('excludedChars');
}
