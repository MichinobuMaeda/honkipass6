import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers.dart';

final Uri githubUrl = Uri.parse('https://github.com/MichinobuMaeda/honkipass6');

class Footer extends ConsumerWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> launchGithubUrl() async {
      if (!await launchUrl(githubUrl)) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not launch GitHub.')),
          );
        }
      }
    }

    return Wrap(
      spacing: 16.0,
      runSpacing: 4.0,
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          '© 2025 Michinobu Maeda',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        TextButton(onPressed: launchGithubUrl, child: const Text('GitHub')),
        ref
            .watch(packageInfoProvider)
            .when(
              data: (info) => Text(
                'v${info.version}+${info.buildNumber}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              loading: () => const Text(''),
              error: (e, s) => const Text(''),
            ),
      ],
    );
  }
}
