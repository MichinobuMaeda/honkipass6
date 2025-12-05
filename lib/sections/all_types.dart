import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';
import '../providers.dart';
import '../preferences.dart';

class AllTypes extends ConsumerWidget {
  const AllTypes({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final prefs = ref.watch(prefsProvider);

    return Row(
      children: [
        Expanded(child: Text(l10n.allTypes)),
        Switch(
          value: ref.watch(allTypesProvider),
          onChanged: (_) {
            ref.read(allTypesProvider.notifier).toggle();
            prefs.setBool(keyAllTypes, ref.watch(allTypesProvider));
          },
        ),
      ],
    );
  }
}
