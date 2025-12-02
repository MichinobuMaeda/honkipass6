// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Honkipass 6';

  @override
  String get password => 'パスワード';

  @override
  String get copied => 'コピーしました';

  @override
  String get failedToCopy => 'コピーに失敗しました';

  @override
  String get lightMode => 'ライトモード';

  @override
  String get darkMode => 'ダークモード';

  @override
  String get auto => '自動';

  @override
  String get waiting => 'お待ちください...';

  @override
  String get reset => 'リセット';

  @override
  String std(int count) {
    return '標準$count字';
  }

  @override
  String ext(int count) {
    return '拡張$count字';
  }

  @override
  String get manual => '詳細設定';

  @override
  String get excludedChars => '除外する文字';

  @override
  String get allTypes => 'すべての文字タイプを使用';

  @override
  String get uniqueChars => '同じ文字を繰り返し使わない';
}
