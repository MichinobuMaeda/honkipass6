import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/toggle_button.dart';
import '../providers.dart';
import '../honkipass.dart';
import '../preferences.dart';

class CharTypes extends ConsumerWidget {
  const CharTypes({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(prefsProvider);

    return Wrap(
      direction: Axis.horizontal,
      alignment: WrapAlignment.center,
      spacing: 4.0,
      children: [
        ToggleButton(
          label: Text('ABC'),
          isSelected: ref.watch(upperCaseProvider),
          onPressed: ref.watch(presetProvider) == Preset.manual
              ? () {
                  ref.read(upperCaseProvider.notifier).toggle();
                  prefs.setBool(keyUpperCase, ref.watch(upperCaseProvider));
                }
              : null,
        ),
        ToggleButton(
          label: Text('abc'),
          isSelected: ref.watch(lowerCaseProvider),
          onPressed: ref.watch(presetProvider) == Preset.manual
              ? () {
                  ref.read(lowerCaseProvider.notifier).toggle();
                  prefs.setBool(keyLowerCase, ref.watch(lowerCaseProvider));
                }
              : null,
        ),
        ToggleButton(
          label: Text('123'),
          isSelected: ref.watch(numericsProvider),
          onPressed: ref.watch(presetProvider) == Preset.manual
              ? () {
                  ref.read(numericsProvider.notifier).toggle();
                  prefs.setBool(keyNumerics, ref.watch(numericsProvider));
                }
              : null,
        ),
        ToggleButton(
          label: Text('@#\$'),
          isSelected: ref.watch(symbolsProvider),
          onPressed: ref.watch(presetProvider) == Preset.manual
              ? () {
                  ref.read(symbolsProvider.notifier).toggle();
                  prefs.setBool(keySymbols, ref.watch(symbolsProvider));
                }
              : null,
        ),
      ],
    );
  }
}
