import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';
import '../widgets/toggle_button.dart';
import '../providers.dart';
import '../preferences.dart';
import '../honkipass.dart';

class Presets extends ConsumerWidget {
  const Presets({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final prefs = ref.watch(prefsProvider);

    return Wrap(
      direction: Axis.horizontal,
      alignment: WrapAlignment.center,
      spacing: 4.0,
      children: [
        ToggleButton(
          label: Text(l10n.std(charSetStd.length)),
          isSelected: ref.watch(presetProvider) == Preset.std,
          onPressed: () {
            ref.read(presetProvider.notifier).setPreset(Preset.std);
            prefs.setInt(keyPreset, Preset.values.indexOf(Preset.std));
          },
        ),
        ToggleButton(
          label: Text(l10n.ext(charSetExt.length)),
          isSelected: ref.watch(presetProvider) == Preset.ext,
          onPressed: () {
            ref.read(presetProvider.notifier).setPreset(Preset.ext);
            prefs.setInt(keyPreset, Preset.values.indexOf(Preset.ext));
          },
        ),
        ToggleButton(
          label: Text(l10n.manual),
          isSelected: ref.watch(presetProvider) == Preset.manual,
          onPressed: () {
            ref.read(presetProvider.notifier).setPreset(Preset.manual);
            prefs.setInt(keyPreset, Preset.values.indexOf(Preset.manual));
          },
        ),
      ],
    );
  }
}
