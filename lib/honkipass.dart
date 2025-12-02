import 'dart:math';

const maxTryCount = 1000;

enum Preset { std, ext, manual }

const lengthList = [6, 8, 10, 12, 16, 20, 24, 30, 36, 48, 64, 128];
const defaultLength = 8;
const defaultPreset = Preset.std;
const defaultLowerCase = true;
const defaultUpperCase = true;
const defaultNumerics = true;
const defaultSymbols = true;
const defaultAllTypes = true;
const defaultUniqueChars = true;
const defaultApplyExcluded = true;
const defaultExcludedChars = 'Il10O8B3Egqvu!|[]{}';

const charSetAll =
    "!\\\"#\$%&'()*+,-./0123456789:;<=>?@"
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\\\]^_`"
    "abcdefghijklmnopqrstuvwxyz{|}~";
const charSetStd =
    "!#%+23456789:=?@"
    "ABCDEFGHJKLMNPRSTUVWXYZ"
    "abcdefghijkmnopqrstuvwxyz";
const charSetExt =
    "!\\\"#\$%&'()*+,-./23456789:;<=>?@"
    "ABCDEFGHJKLMNOPRSTUVWXYZ[\\\\]^_"
    "abcdefghijkmnopqrstuvwxyz{|}~";

class HonkipassParam {
  int length;
  Preset preset;
  bool lowerCase;
  bool upperCase;
  bool numerics;
  bool symbols;
  bool allTypes;
  bool uniqueChars;
  bool applyExcluded;
  String excludedChars;

  HonkipassParam({
    this.length = defaultLength,
    this.preset = defaultPreset,
    this.lowerCase = defaultLowerCase,
    this.upperCase = defaultUpperCase,
    this.numerics = defaultNumerics,
    this.symbols = defaultSymbols,
    this.allTypes = defaultAllTypes,
    this.uniqueChars = defaultUniqueChars,
    this.applyExcluded = defaultApplyExcluded,
    this.excludedChars = defaultExcludedChars,
  });
}

String generateChars(HonkipassParam param) {
  String ret;
  switch (param.preset) {
    case Preset.ext:
      ret = charSetExt;
      break;
    case Preset.manual:
      ret = charSetAll;
      if (!param.upperCase) {
        ret = ret.replaceAll(RegExp(r'[A-Z]'), '');
      }
      if (!param.lowerCase) {
        ret = ret.replaceAll(RegExp(r'[a-z]'), '');
      }
      if (!param.numerics) {
        ret = ret.replaceAll(RegExp(r'[0-9]'), '');
      }
      if (!param.symbols) {
        ret = ret.replaceAll(RegExp(r'[^A-Za-z0-9]'), '');
      }
      if (param.applyExcluded) {
        for (var c in param.excludedChars.split('')) {
          ret = ret.replaceAll(c, '');
        }
      }
      break;
    case Preset.std:
      ret = charSetStd;
      break;
  }
  return ret;
}

String generateCandidate(HonkipassParam param, String chars) {
  final random = Random.secure();
  return String.fromCharCodes(
    List.generate(
      param.length,
      (index) => chars.codeUnitAt(random.nextInt(chars.length)),
    ),
  );
}

bool validatePassword(HonkipassParam param, String password) {
  if (password.length != param.length) {
    return false;
  }
  if (param.allTypes) {
    if (param.upperCase && !password.contains(RegExp(r'[A-Z]'))) {
      return false;
    }
    if (param.lowerCase && !password.contains(RegExp(r'[a-z]'))) {
      return false;
    }
    if (param.numerics && !password.contains(RegExp(r'[0-9]'))) {
      return false;
    }
    if (param.symbols && !password.contains(RegExp(r'[^A-Za-z0-9]'))) {
      return false;
    }
  }
  if (param.uniqueChars) {
    for (var i = 0; i < password.length; i++) {
      if (password.substring(i + 1).contains(password[i])) {
        return false;
      }
    }
  }
  return true;
}

String generatePassword(HonkipassParam param, String chars) {
  for (var i = 0; i < maxTryCount; ++i) {
    final password = generateCandidate(param, chars);
    if (validatePassword(param, password)) {
      return password;
    }
  }
  return "";
}
