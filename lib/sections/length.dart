import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers.dart';
import '../preferences.dart';
import '../honkipass.dart';

class Length extends ConsumerWidget {
  const Length({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(prefsProvider);

    return Slider(
      value: ref.watch(lengthIndexProvider).toDouble(),
      min: 0,
      max: (lengthList.length - 1).toDouble(),
      divisions: lengthList.length - 1,
      onChanged: (value) {
        ref.read(lengthIndexProvider.notifier).setLengthIndex(value);
        prefs.setInt(keyLength, ref.watch(lengthProvider));
      },
      label: "${ref.watch(lengthProvider)}",
    );
  }
}
