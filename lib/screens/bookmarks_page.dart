// NEW FILE: shows all bookmarked articles

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/bookmark_provider.dart';
import '../widgets/news_card.dart';

class BookmarksPage extends StatelessWidget {
  const BookmarksPage({super.key});

  @override
  Widget build(BuildContext context) {
    // watch = rebuild this page whenever bookmarks change
    final bookmarks = context.watch<BookmarkProvider>().bookmarks;

    if (bookmarks.isEmpty) {
      return const Center(child: Text('No bookmarks yet'));
    }

    return ListView.builder(
      itemCount: bookmarks.length,
      itemBuilder: (context, index) {
        return NewsCard(article: bookmarks[index]);
      },
    );
  }
}
