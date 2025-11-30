import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

// 1. Create a provider for the theme mode
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

void main() {
  // 2. Wrap the app in a ProviderScope
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 3. Watch the theme mode provider
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

class ThemeMenuItem {
  const ThemeMenuItem({
    required this.mode,
    required this.label,
    required this.icon,
  });
  final ThemeMode mode;
  final String label;
  final IconData icon;
}

const themeList = [
  ThemeMenuItem(
    mode: ThemeMode.light,
    label: 'Light Mode',
    icon: Icons.light_mode,
  ),
  ThemeMenuItem(
    mode: ThemeMode.dark,
    label: 'Dark Mode',
    icon: Icons.dark_mode,
  ),
  ThemeMenuItem(
    mode: ThemeMode.system,
    label: 'Auto',
    icon: Icons.brightness_auto,
  ),
];

class MyHomePage extends HookConsumerWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentThemeMode = ref.watch(themeModeProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    const breakpointMobile = 480.0;

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
          if (screenWidth < breakpointMobile)
            PopupMenuButton<ThemeMode>(
              icon: const Icon(Icons.more_vert),
              position: PopupMenuPosition.under,
              onSelected: (ThemeMode mode) {
                ref.read(themeModeProvider.notifier).state = mode;
              },
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<ThemeMode>>[
                    ...themeList.map(
                      (item) => PopupMenuItem<ThemeMode>(
                        value: item.mode,
                        padding: EdgeInsets.zero,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          color: currentThemeMode == item.mode
                              ? Theme.of(context).colorScheme.secondaryContainer
                              : null,
                          child: Text(item.label),
                        ),
                      ),
                    ),
                  ],
            )
          else
            Row(
              children: [
                ...themeList.map(
                  (item) => IconButton(
                    icon: Icon(item.icon),
                    tooltip: item.label,
                    isSelected: currentThemeMode == item.mode,
                    onPressed: () {
                      ref.read(themeModeProvider.notifier).state = item.mode;
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith<Color?>((
                        states,
                      ) {
                        if (states.contains(WidgetState.selected)) {
                          return Theme.of(
                            context,
                          ).colorScheme.secondaryContainer;
                        }
                        return null;
                      }),
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
