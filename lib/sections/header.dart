import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';
import '../widgets/app_bar_action.dart';
import '../widgets/selectable_popup_menu_item.dart';
import '../theme.dart';
import '../providers.dart';
import '../preferences.dart';
import 'reslut.dart';

class Header extends ConsumerWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;
    final prefs = ref.watch(prefsProvider);

    return SliverAppBar(
      pinned: true,
      snap: false,
      floating: true,
      leading: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Image.asset('images/logo.png'),
      ),
      title: Text(
        l10n.appTitle,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      actions: [
        if (screenWidth < breakpointMobile)
          PopupMenuButton<dynamic>(
            icon: const Icon(Icons.more_vert),
            position: PopupMenuPosition.under,
            onSelected: (dynamic value) {
              if (value is Locale) {
                ref.read(localeProvider.notifier).setLocale(value);
                prefs.setString(keyLocale, value.toLanguageTag());
              } else if (value is ThemeMode) {
                ref.read(themeModeProvider.notifier).setThemeMode(value);
                prefs.setInt(keyThemeMode, ThemeMode.values.indexOf(value));
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<dynamic>>[
              ...languageList.map(
                (item) => SelectablePopupMenuItem<Locale>(
                  value: item.locale,
                  label: Text(item.label),
                  isSelected: ref.watch(localeProvider) == item.locale,
                ),
              ),
              const PopupMenuDivider(),
              ...themeList(l10n).map(
                (item) => SelectablePopupMenuItem<ThemeMode>(
                  value: item.mode,
                  icon: Icon(item.icon),
                  label: Text(item.label),
                  isSelected: ref.watch(themeModeProvider) == item.mode,
                ),
              ),
            ],
          )
        else ...[
          ...languageList.map(
            (item) => AppBarAction(
              icon: Text(item.shortName),
              isSelected: ref.watch(localeProvider) == item.locale,
              onPressed: () {
                ref.read(localeProvider.notifier).setLocale(item.locale);
                prefs.setString(keyLocale, item.locale.toLanguageTag());
              },
            ),
          ),
          ...themeList(l10n).map(
            (item) => AppBarAction(
              icon: Icon(item.icon),
              isSelected: ref.watch(themeModeProvider) == item.mode,
              onPressed: () {
                ref.read(themeModeProvider.notifier).setThemeMode(item.mode);
                prefs.setInt(keyThemeMode, ThemeMode.values.indexOf(item.mode));
              },
            ),
          ),
        ],
        SizedBox(width: 4.0),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(84.0),
        child: Container(
          color: Theme.of(context).colorScheme.surfaceContainerLowest,
          child: Center(
            child: SizedBox(
              width: contentWidth,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: contentPadding,
                  vertical: 8.0,
                ),
                child: Result(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
