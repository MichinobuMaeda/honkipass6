import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

class ThemeList {
  const ThemeList(this.mode, this.icon, this.label);
  final ThemeMode mode;
  final IconData icon;
  final String label;
}

const themeList = [
  ThemeList(ThemeMode.light, Icons.light_mode,  'Light mode'),
  ThemeList(ThemeMode.dark, Icons.dark_mode, 'Dark mode'),
  ThemeList(ThemeMode.system, Icons.brightness_auto, 'Auto'),
];

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    const String title = 'Honkipass 6';
    final themeData = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
    );
    final darkThemeData = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.teal,
        brightness: Brightness.dark,
      ),
    );

    return MaterialApp(
      title: title,
      themeMode: themeMode,
      theme: themeData,
      darkTheme: darkThemeData,
      home: const MyHomePage(title: title),
    );
  }
}

class MyHomePage extends HookConsumerWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentThemeMode = ref.watch(themeModeProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        leading: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Image.asset('images/logo.png'),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        actions: [
          PopupMenuButton<ThemeMode>(
            icon: const Icon(Icons.more_vert),
            position: PopupMenuPosition.under,
            onSelected: (ThemeMode mode) {
              ref.read(themeModeProvider.notifier).state = mode;
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<ThemeMode>>[
              ...themeList.map(
                (item) => PopupMenuItem<ThemeMode>(
                  value: item.mode,
                  padding: EdgeInsets.zero,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0,
                    ),
                    color: currentThemeMode == item.mode
                        ? Theme.of(context).colorScheme.secondaryContainer
                        : null,
                    child: Row(
                      spacing: 8.0,
                      children: [
                        Icon(item.icon),
                        Text(item.label),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('You have pushed the button this many times:'),
          ],
        ),
      ),
    );
  }
}
