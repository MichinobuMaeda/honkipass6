import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers.dart';
import '../honkipass.dart';

class CharMap extends ConsumerWidget {
  const CharMap({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerHigh,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Wrap(
        alignment: WrapAlignment.start,
        spacing: 1.0,
        runSpacing: 1.0,
        children: charSetAll
            .split('')
            .toList()
            .map(
              (c) => Text(
                c,
                style: TextStyle(
                  fontFamily: 'Monospace',
                  fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
                  backgroundColor: ref.watch(passwordProvider).contains(c)
                      ? Theme.of(context).colorScheme.errorContainer
                      : ref.watch(charsetProvider).contains(c)
                      ? Theme.of(context).colorScheme.surfaceContainerLowest
                      : null,
                  color: ref.watch(charsetProvider).contains(c)
                      ? null
                      : Theme.of(context).colorScheme.secondary,
                ),
              ),
            )
            .toList(),
      ),),
    );
  }
}
