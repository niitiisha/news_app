import 'package:flutter/material.dart';

import '../models/article.dart';
import '../services/analytics_service.dart';
import '../services/news_service.dart';
import '../widgets/news_card.dart';

class SearchPage extends StatefulWidget {
  final NewsService newsService;
  final AnalyticsService analyticsService;

  const SearchPage({
    super.key,
    required this.newsService,
    required this.analyticsService,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchController = TextEditingController();

  List<Article> searchArticles = [];

  bool isSearching = false;

  Future<void> searchNews() async {
    final query = searchController.text.trim();

    if (query.isEmpty) {
      return;
    }

    // Analytics: user tapped the Search button
    await widget.analyticsService.logRequestTapped('search_news');

    setState(() {
      isSearching = true;
    });

    try {
      final results = await widget.newsService.searchNews(query);

      // Analytics: NewsAPI request succeeded
      await widget.analyticsService.logRequestSuccess('search_news');

      if (!mounted) {
        return;
      }

      setState(() {
        searchArticles = results;
        isSearching = false;
      });
    } catch (error) {
      // Analytics: NewsAPI request failed
      await widget.analyticsService.logRequestFailed('search_news');

      if (!mounted) {
        return;
      }

      setState(() {
        isSearching = false;
      });

      debugPrint('Failed to search news: $error');
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search news...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              ElevatedButton(
                onPressed: searchNews,
                child: const Text('Search'),
              ),
            ],
          ),
        ),

        Expanded(
          child: isSearching
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: searchArticles.length,
                  itemBuilder: (context, index) {
                    return NewsCard(article: searchArticles[index]);
                  },
                ),
        ),
      ],
    );
  }
}
