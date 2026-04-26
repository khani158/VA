import 'package:shared_preferences/shared_preferences.dart';
import '../../models/recent_number.dart';

class LocalStorage {
  static const String _key = 'recent_numbers';

  static Future<void> saveNumber(String number) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> existing = prefs.getStringList(_key) ?? [];
    
    // Remove if already exists to move to top
    existing.removeWhere((item) {
      final decoded = RecentNumber.fromJson(item);
      return decoded.number == number;
    });

    final newEntry = RecentNumber(number: number, timestamp: DateTime.now());
    existing.insert(0, newEntry.toJson());

    // Keep only last 20
    if (existing.length > 20) {
      existing.removeLast();
    }

    await prefs.setStringList(_key, existing);
  }

  static Future<List<RecentNumber>> getRecentNumbers() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> list = prefs.getStringList(_key) ?? [];
    return list.map((item) => RecentNumber.fromJson(item)).toList();
  }

  static Future<void> deleteNumber(String number) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> existing = prefs.getStringList(_key) ?? [];
    existing.removeWhere((item) {
      final decoded = RecentNumber.fromJson(item);
      return decoded.number == number;
    });
    await prefs.setStringList(_key, existing);
  }
}
