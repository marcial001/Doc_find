import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final StateNotifierProvider<LocaleController, Locale> appLocaleProvider =
    StateNotifierProvider<LocaleController, Locale>((Ref ref) {
      return LocaleController();
    });

class LocaleController extends StateNotifier<Locale> {
  LocaleController() : super(const Locale('en'));

  void setLocale(Locale locale) {
    state = locale;
  }

  void toggleLocale() {
    state = state.languageCode == 'en'
        ? const Locale('fr')
        : const Locale('en');
  }
}
