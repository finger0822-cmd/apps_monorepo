import 'package:shared_preferences/shared_preferences.dart';

/// Persists whether the user has seen the 7-day Aha Moment (first rhythm discovery).
class AhaPrefs {
  AhaPrefs._();

  static const _keyHasSeenAhaMoment = 'hasSeenAhaMoment';

  static Future<bool> hasSeenAhaMoment() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyHasSeenAhaMoment) ?? false;
  }

  static Future<void> setHasSeenAhaMoment(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyHasSeenAhaMoment, value);
  }
}
