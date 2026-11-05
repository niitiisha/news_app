import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/news_provider.dart';
import '../widgets/news_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // The text field controller is UI-only, so it stays in the screen
  final TextEditingController searchController = TextEditingController();

  void onSearchPressed() {
    // read = just call the method, no rebuild needed here
    context.read<NewsProvider>().searchNews(searchController.text);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // watch = rebuild this screen when search data changes
    final newsProvider = context.watch<NewsProvider>();

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
                  onSubmitted: (_) => onSearchPressed(),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: onSearchPressed,
                child: const Text('Search'),
              ),
            ],
          ),
        ),
        Expanded(child: buildResults(newsProvider)),
      ],
    );
  }

  Widget buildResults(NewsProvider newsProvider) {
    if (newsProvider.isSearching) {
      return const Center(child: CircularProgressIndicator());
    }

    if (newsProvider.searchError != null) {
      return Center(child: Text(newsProvider.searchError!));
    }

    if (newsProvider.searchResults.isEmpty) {
      return const Center(child: Text('Search for any news topic'));
    }

    return ListView.builder(
      itemCount: newsProvider.searchResults.length,
      itemBuilder: (context, index) {
        return NewsCard(article: newsProvider.searchResults[index]);
      },
    );
  }
}
