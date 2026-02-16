import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _currentSentenceKey = 'current_sentence';

  Future<String?> loadCurrentSentence() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_currentSentenceKey);
  }

  Future<void> saveCurrentSentence(String sentence) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentSentenceKey, sentence);
  }
}
