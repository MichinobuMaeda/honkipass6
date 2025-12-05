import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';
import '../providers.dart';
import '../preferences.dart';
import '../honkipass.dart';

class Excludes extends ConsumerWidget {
  const Excludes({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final prefs = ref.watch(prefsProvider);

    final excludedCharsController = ref.watch(
      excludesTextEditingControllerProvider,
    );

    return Row(
      spacing: 16.0,
      children: [
        Expanded(
          child: TextField(
            controller: excludedCharsController,
            enabled: ref.watch(presetProvider) == Preset.manual,
            onChanged: (value) {
              ref.read(excludedCharsProvider.notifier).setExcludedChars(value);
              prefs.setString(
                keyExcludedChars,
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
          onChanged: ref.watch(presetProvider) == Preset.manual
              ? (_) {
                  ref.read(applyExcludedProvider.notifier).toggle();
                  prefs.setBool(
                    keyApplyExcluded,
                    ref.watch(applyExcludedProvider),
                  );
                }
              : null,
        ),
      ],
    );
  }
}
