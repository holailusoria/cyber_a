import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../utils/language_presentation.dart';

String getCurrentLocaleAsString() {
  var supportedLocales = AppLocalizations.supportedLocales.map((e) => e.languageCode);
  var currentLanguageCode = Platform.localeName.split('_')[0];

  if(supportedLocales.contains(currentLanguageCode)) {
    return languagePresentation[currentLanguageCode]!;
  }

  return languagePresentation['en']!;
}

Locale getCurrentLocale() {
  var supportedLocales = AppLocalizations.supportedLocales;
  var currentLang= Platform.localeName.split('_')[0];
  var currentLocale = const Locale('en');

  currentLocale = supportedLocales.firstWhere((element) => element.languageCode == currentLang);

  return currentLocale;
}