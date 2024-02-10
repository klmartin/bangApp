import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SearchHistoryManager {
  static const _maxHistorySize = 10;
  static const _historyKey = 'search_history';

  List<Map<String, dynamic>> _searchHistory = [];

  List<Map<String, dynamic>> get searchHistory => _searchHistory;

  Future<void> loadSearchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final storedHistory = prefs.getStringList(_historyKey) ?? [];
    _searchHistory = (storedHistory.map((entry) => jsonDecode(entry) as Map<String, dynamic>))
        .take(_maxHistorySize)
        .toList();
  }

  Future<void> saveSearch(Map<String, dynamic> user) async {
    // Remove existing entry if user is already in history
    _searchHistory.removeWhere((entry) => entry['selected_user'] == user['selected_user']);

    // Add the new user to the front of the list
    _searchHistory.insert(0, user);

    // Trim the list to the maximum size
    _searchHistory = _searchHistory.take(_maxHistorySize).toList();

    // Save the updated history to SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final serializedHistory = _searchHistory.map((entry) => jsonEncode(entry)).toList();
    prefs.setStringList(_historyKey, serializedHistory);
  }
}
