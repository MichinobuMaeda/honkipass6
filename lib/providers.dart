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
