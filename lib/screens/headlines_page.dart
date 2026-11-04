import 'package:flutter/material.dart';

import '../models/article.dart';
import '../services/analytics_service.dart';
import '../services/news_service.dart';
import '../widgets/news_card.dart';

class HeadlinesPage extends StatefulWidget {
  final NewsService newsService;
  final AnalyticsService analyticsService;

  const HeadlinesPage({
    super.key,
    required this.newsService,
    required this.analyticsService,
  });

  @override
  State<HeadlinesPage> createState() => _HeadlinesPageState();
}

class _HeadlinesPageState extends State<HeadlinesPage> {
  List<Article> articles = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchHeadlines();
  }

  Future<void> fetchHeadlines() async {
    try {
      final fetchedArticles = await widget.newsService.fetchHeadlines();

      // Analytics: Headlines API succeeded
      await widget.analyticsService.logRequestSuccess('top_headlines');

      if (!mounted) {
        return;
      }

      setState(() {
        articles = fetchedArticles;
        isLoading = false;
      });
    } catch (error) {
      // Analytics: Headlines API failed
      await widget.analyticsService.logRequestFailed('top_headlines');

      if (!mounted) {
        return;
      }

      setState(() {
        isLoading = false;
      });

      debugPrint('Failed to load headlines: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      itemCount: articles.length,
      itemBuilder: (context, index) {
        return NewsCard(article: articles[index]);
      },
    );
  }
}
