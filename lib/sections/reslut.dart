import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';
import '../providers.dart';

class Result extends ConsumerWidget {
  const Result({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final passwordController = ref.watch(passwordTextEditingControllerProvider);

    String message() {
      switch (ref.watch(messageProvider)) {
        case Message.wait:
          return l10n.waiting;
        case Message.generated:
          return l10n.generated;
        case Message.retry:
          return l10n.retry;
        case Message.copied:
          return l10n.copied;
        case Message.failedToCopy:
          return l10n.failedToCopy;
      }
    }

    bool isError() {
      return ref.watch(messageProvider) == Message.retry;
    }

    void copyPassword() {
      Clipboard.setData(ClipboardData(text: ref.watch(passwordProvider)))
          .then((_) {
            ref.read(messageProvider.notifier).setMessage(Message.copied);
          })
          .catchError((_) {
            ref.read(messageProvider.notifier).setMessage(Message.failedToCopy);
          });
    }

    return TextFormField(
      readOnly: true,
      autofocus: true,
      controller: passwordController,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: l10n.password,
        helperText: message(),
        helperStyle: isError()
            ? TextStyle(color: Theme.of(context).colorScheme.error)
            : null,
        enabledBorder: isError()
            ? OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.error,
                ),
              )
            : null,
        focusedBorder: isError()
            ? OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.error,
                  width: 2.0,
                ),
              )
            : null,
        prefixIcon: IconButton(
          icon: const Icon(Icons.content_copy),
          onPressed: copyPassword,
        ),
        suffixIcon: IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () =>
              ref.read(passwordGenerateRequestProvider.notifier).request(),
        ),
      ),
      style: TextStyle(
        fontFamily: 'Monospace',
        color: isError() ? Theme.of(context).colorScheme.error : null,
      ),
    );
  }
}
