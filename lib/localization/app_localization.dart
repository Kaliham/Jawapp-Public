import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalization {
  Map<String, String> _localizedValues;
  final Locale locale;

  AppLocalization(this.locale);

  static AppLocalization of(BuildContext context) {
    return Localizations.of<AppLocalization>(context, AppLocalization);
  }

  static const LocalizationsDelegate<AppLocalization> delegate =
      _AppLocatizationDelegate();

  Future load() async {
    String stringJson =
        await rootBundle.loadString("assets/lang/${locale.languageCode}.json");
    Map<String, dynamic> mapJson = json.decode(stringJson);
    _localizedValues =
        mapJson.map((key, value) => MapEntry(key, value.toString()));
  }
}

class _AppLocatizationDelegate extends LocalizationsDelegate<AppLocalization> {
  const _AppLocatizationDelegate();
  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalization> load(Locale locale) async {
    AppLocalization localization = new AppLocalization(locale);
    await localization.load();
    return localization;
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalization> old) => false;
}
