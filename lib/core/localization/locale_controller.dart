import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleController extends StateNotifier<Locale> {
  static const _languageKey = 'app_language';

  LocaleController() : super(const Locale('id')) {
    load();
  }

  Future<void> load() async {
    final preferences = await SharedPreferences.getInstance();
    final languageCode = preferences.getString(_languageKey);
    if (languageCode == 'en' || languageCode == 'id') {
      state = Locale(languageCode!);
    }
  }

  Future<void> setLanguage(String languageCode) async {
    if (languageCode != 'en' && languageCode != 'id') return;

    state = Locale(languageCode);
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_languageKey, languageCode);
  }
}

final localeControllerProvider =
    StateNotifierProvider<LocaleController, Locale>((ref) {
      return LocaleController();
    });
