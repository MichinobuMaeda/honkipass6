// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Honkipass 6';

  @override
  String get password => 'Password';

  @override
  String get copied => 'Copied';

  @override
  String get failedToCopy => 'Failed to copy';

  @override
  String get lightMode => 'Light Mode';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get auto => 'Auto';

  @override
  String get waiting => 'Waiting...';

  @override
  String get reset => 'Reset';

  @override
  String std(int count) {
    return 'Std $count';
  }

  @override
  String ext(int count) {
    return 'Ext $count';
  }

  @override
  String get manual => 'Manual';
}
