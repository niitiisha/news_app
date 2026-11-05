// NEW FILE: holds bookmarks and saves them on the phone

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/article.dart';

class BookmarkProvider extends ChangeNotifier {
  // Name under which bookmarks are saved on the device
  static const String _storageKey = 'bookmarked_articles';

  List<Article> bookmarks = [];

  // Check if an article is already bookmarked (we match by title)
  bool isBookmarked(Article article) {
    return bookmarks.any((saved) => saved.title == article.title);
  }

  // Load saved bookmarks from the phone (runs once when app starts)
  Future<void> loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final savedList = prefs.getStringList(_storageKey) ?? [];

    bookmarks = savedList
        .map(
          (item) => Article.fromJson(jsonDecode(item) as Map<String, dynamic>),
        )
        .toList();

    notifyListeners();
  }

  // Add bookmark if not saved, remove if already saved
  Future<void> toggleBookmark(Article article) async {
    if (isBookmarked(article)) {
      bookmarks.removeWhere((saved) => saved.title == article.title);
    } else {
      bookmarks.add(article);
    }

    notifyListeners(); // update UI immediately
    await _saveBookmarks(); // then save to phone
  }

  // CHANGED: save the FULL article (title + description + image), not just title
  Future<void> _saveBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = bookmarks.map((a) => jsonEncode(a.toJson())).toList();
    await prefs.setStringList(_storageKey, jsonList);
  }
}
