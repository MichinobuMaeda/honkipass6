import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';
import '../providers.dart';
import '../preferences.dart';

class UniqueChars extends ConsumerWidget {
  const UniqueChars({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final prefs = ref.watch(prefsProvider);

    return Row(
      children: [
        Expanded(child: Text(l10n.uniqueChars)),
        Switch(
          value: ref.watch(uniqueCharsProvider),
          onChanged: (_) {
            ref.read(uniqueCharsProvider.notifier).toggle();
            prefs.setBool(keyUniqueChars, ref.watch(uniqueCharsProvider));
          },
        ),
      ],
    );
  }
}
