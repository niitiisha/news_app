import 'package:flutter/foundation.dart';

import '../models/article.dart';
import '../services/analytics_service.dart';
import '../services/news_service.dart';

class NewsProvider extends ChangeNotifier {
  final NewsService newsService;
  final AnalyticsService analyticsService;

  NewsProvider({required this.newsService, required this.analyticsService});

  // ---------- HEADLINES STATE ----------
  List<Article> headlines = [];
  bool isLoadingHeadlines = true;
  String? headlinesError;

  Future<void> fetchHeadlines() async {
    isLoadingHeadlines = true;
    headlinesError = null;
    notifyListeners();

    try {
      headlines = await newsService.fetchHeadlines();
      await analyticsService.logRequestSuccess('top_headlines');
    } catch (error) {
      headlinesError = 'Failed to load headlines';
      await analyticsService.logRequestFailed('top_headlines');
      debugPrint('Failed to load headlines: $error');
    }

    isLoadingHeadlines = false;
    notifyListeners();
  }

  // ---------- SEARCH STATE ----------
  List<Article> searchResults = [];
  bool isSearching = false;
  String? searchError;

  Future<void> searchNews(String query) async {
    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) {
      return;
    }

    // Analytics: user tapped the Search button
    await analyticsService.logRequestTapped('search_news');

    isSearching = true;
    searchError = null;
    notifyListeners(); // show loader

    try {
      searchResults = await newsService.searchNews(trimmedQuery);
      // Analytics: Search API succeeded
      await analyticsService.logRequestSuccess('search_news');
    } catch (error) {
      searchError = 'Failed to search news';
      // Analytics: Search API failed
      await analyticsService.logRequestFailed('search_news');
      debugPrint('Failed to search news: $error');
    }

    isSearching = false;
    notifyListeners(); // show results or error
  }
}
