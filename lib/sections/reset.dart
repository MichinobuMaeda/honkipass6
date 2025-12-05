import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';
import '../theme.dart';
import '../providers.dart';
import '../preferences.dart';

class Reset extends ConsumerWidget {
  const Reset({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;

    void onReset() {
      onParamsReset(ref);
      resetPreferences(ref);
    }

    return (screenWidth < breakpointMobile)
        ? IconButton.filledTonal(
            icon: const Icon(Icons.settings_backup_restore),
            onPressed: ref.watch(isParamsChangedProvider) ? onReset : null,
          )
        : FilledButton.tonal(
            onPressed: ref.watch(isParamsChangedProvider) ? onReset : null,
            child: Row(
              spacing: 8.0,
              children: [
                const Icon(Icons.settings_backup_restore),
                Text(l10n.reset),
              ],
            ),
          );
  }
}
