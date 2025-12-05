import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers.dart';
import 'honkipass.dart';

const keyLength = 'length';
const keyPreset = 'preset';
const keyUpperCase = 'upperCase';
const keyLowerCase = 'lowerCase';
const keyNumerics = 'numerics';
const keySymbols = 'symbols';
const keyAllTypes = 'allTypes';
const keyUniqueChars = 'uniqueChars';
const keyApplyExcluded = 'applyExcluded';
const keyExcludedChars = 'excludedChars';
const keyThemeMode = 'themeMode';
const keyLocale = 'locale';

Future<void> initPreferences(WidgetRef ref) async {
  if (!ref.watch(preferencesInitializedProvider)) {
    debugPrint('start load preferences');
    final prefs = ref.watch(prefsProvider);

    final length = await prefs.getInt(keyLength) ?? defaultLength;
    final preset =
        await prefs.getInt(keyPreset) ?? Preset.values.indexOf(defaultPreset);
    final upperCase = await prefs.getBool(keyUpperCase) ?? defaultUpperCase;
    final lowerCase = await prefs.getBool(keyLowerCase) ?? defaultLowerCase;
    final numerics = await prefs.getBool(keyNumerics) ?? defaultNumerics;
    final symbols = await prefs.getBool(keySymbols) ?? defaultSymbols;
    final allTypes = await prefs.getBool(keyAllTypes) ?? defaultAllTypes;
    final uniqueChars =
        await prefs.getBool(keyUniqueChars) ?? defaultUniqueChars;
    final applyExcluded =
        await prefs.getBool(keyApplyExcluded) ?? defaultApplyExcluded;
    final excludedChars =
        await prefs.getString(keyExcludedChars) ?? defaultExcludedChars;
    final themeMode =
        await prefs.getInt(keyThemeMode) ??
        ThemeMode.values.indexOf(defaultThemeMode);
    final locale = await prefs.getString('locale') ?? defaultLocaleName;

    ref
        .read(lengthIndexProvider.notifier)
        .setLengthIndex(lengthList.indexOf(length));
    ref.read(presetProvider.notifier).setPreset(Preset.values[preset]);
    ref.read(upperCaseProvider.notifier).setUpperCase(upperCase);
    ref.read(lowerCaseProvider.notifier).setLowerCase(lowerCase);
    ref.read(numericsProvider.notifier).setNumerics(numerics);
    ref.read(symbolsProvider.notifier).setSymbols(symbols);
    ref.read(allTypesProvider.notifier).setAllTypes(allTypes);
    ref.read(uniqueCharsProvider.notifier).setUniqueChars(uniqueChars);
    ref.read(applyExcludedProvider.notifier).setApplyExcluded(applyExcluded);
    ref.read(excludedCharsProvider.notifier).setExcludedChars(excludedChars);
    ref
        .read(themeModeProvider.notifier)
        .setThemeMode(ThemeMode.values[themeMode]);
    ref.read(localeProvider.notifier).setLocale(Locale(locale));

    ref.read(preferencesInitializedProvider.notifier).touch();
    debugPrint('end   load preferences');
  }
}

Future<void> resetPreferences(WidgetRef ref) async {
  final prefs = ref.watch(prefsProvider);
  prefs.remove(keyLength);
  prefs.remove(keyPreset);
  prefs.remove(keyUpperCase);
  prefs.remove(keyLowerCase);
  prefs.remove(keyNumerics);
  prefs.remove(keySymbols);
  prefs.remove(keyAllTypes);
  prefs.remove(keyUniqueChars);
  prefs.remove(keyApplyExcluded);
  prefs.remove(keyExcludedChars);
}
