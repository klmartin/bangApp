import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SearchHistoryManager {
  static const _maxHistorySize = 10;
  static const _historyKey = 'search_history';

  List<List<Map<String, dynamic>>> _searchHistory = [];

  List<List<Map<String, dynamic>>> get searchHistory => _searchHistory;

  Future<void> loadSearchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final storedHistory = prefs.getStringList(_historyKey) ?? [];

    // Clear existing history to avoid duplications
    _searchHistory.clear();

    for (var entry in storedHistory) {
      try {
        // Deserialize each entry and add it to the search history
        List<Map<String, dynamic>> deserializedEntry = (jsonDecode(entry) as List<dynamic>)
            .cast<Map<String, dynamic>>()
            .toList();
        _searchHistory.add(deserializedEntry);
      } catch (e) {
        print("Error decoding entry from SharedPreferences: $entry");
        // Handle or ignore the error based on your requirements
      }
    }
    // Take only up to _maxHistorySize entries
    _searchHistory = _searchHistory.take(_maxHistorySize).toList();
  }



  Future<void> saveSearch(List<Map<String, dynamic>> user) async {
    // Load existing search history
    await loadSearchHistory();
    // Remove existing entry if user is already in history
    _searchHistory.removeWhere((entry) =>
    entry.isNotEmpty &&
        entry.first['selected_user'] == user.first['selected_user']);
    // Add the new user entry to the front of the list
    _searchHistory.insert(0, List<Map<String, dynamic>>.from(user));
    // Trim the list to the maximum size
    _searchHistory = _searchHistory.take(_maxHistorySize).toList();

    // Save the updated history to SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final serializedHistory =
    _searchHistory.map((entry) => jsonEncode(entry)).toList();
    prefs.setStringList(_historyKey, serializedHistory);
  }
}
