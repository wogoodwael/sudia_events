import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class LanguageProvider with ChangeNotifier {
  Locale _locale = ui.window.locale;

  Locale get locale => _locale;
  TextDirection get textDirection =>
      _locale.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr;

  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }
}
