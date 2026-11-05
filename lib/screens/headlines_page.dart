import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/news_provider.dart';
import '../widgets/news_card.dart';

class HeadlinesPage extends StatefulWidget {
  const HeadlinesPage({super.key});

  @override
  State<HeadlinesPage> createState() => _HeadlinesPageState();
}

class _HeadlinesPageState extends State<HeadlinesPage> {
  @override
  void initState() {
    super.initState();
    // Wait until the first frame is drawn, then fetch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NewsProvider>().fetchHeadlines();
    });
  }

  @override
  Widget build(BuildContext context) {
    final newsProvider = context.watch<NewsProvider>();

    if (newsProvider.isLoadingHeadlines) {
      return const Center(child: CircularProgressIndicator());
    }

    // CHANGED: error screen now has a Retry button + pull-to-refresh
    if (newsProvider.headlinesError != null && newsProvider.headlines.isEmpty) {
      return RefreshIndicator(
        onRefresh: () => context.read<NewsProvider>().fetchHeadlines(),
        child: ListView(
          // NEW: lets you pull down even though the screen isn't a long list
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            const SizedBox(height: 200),
            const Icon(Icons.wifi_off, size: 50, color: Colors.grey),
            const SizedBox(height: 12),
            Center(child: Text(newsProvider.headlinesError!)),
            const SizedBox(height: 12),
            // NEW: Retry button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  context.read<NewsProvider>().fetchHeadlines();
                },
                child: const Text('Retry'),
              ),
            ),
          ],
        ),
      );
    }

    // CHANGED: wrapped list in RefreshIndicator (pull down to reload)
    return RefreshIndicator(
      onRefresh: () => context.read<NewsProvider>().fetchHeadlines(),
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(), // NEW
        itemCount: newsProvider.headlines.length,
        itemBuilder: (context, index) {
          return NewsCard(article: newsProvider.headlines[index]);
        },
      ),
    );
  }
}
