
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/download_item.dart';

class HistoryService {
  static const String _historyKey = 'video_download_history';

  Future<List<DownloadItem>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getString(_historyKey);

    if (data == null || data.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> decoded = jsonDecode(data);

      return decoded
          .map((item) => DownloadItem.fromJson(
                Map<String, dynamic>.from(item),
              ))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveItem(DownloadItem item) async {
    final history = await getHistory();

    history.removeWhere((old) => old.id == item.id);

    history.insert(0, item);

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      _historyKey,
      jsonEncode(history.map((item) => item.toJson()).toList()),
    );
  }

  Future<void> deleteItem(String id) async {
    final history = await getHistory();

    history.removeWhere((item) => item.id == id);

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      _historyKey,
      jsonEncode(history.map((item) => item.toJson()).toList()),
    );
  }

  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_historyKey);
  }
}
