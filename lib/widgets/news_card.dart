import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart'; // NEW

import '../models/article.dart';
import '../providers/bookmark_provider.dart';

class NewsCard extends StatelessWidget {
  final Article article;

  const NewsCard({super.key, required this.article});

  // Grey box with broken image icon (no image, or image failed to load)
  Widget _imagePlaceholder() {
    return Container(
      height: 200,
      width: double.infinity,
      color: Colors.grey[300],
      child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
    );
  }

  // NEW: grey box with a small loader (shown while the image is downloading)
  Widget _loadingPlaceholder() {
    return Container(
      height: 200,
      width: double.infinity,
      color: Colors.grey[200],
      child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Check if this article is bookmarked (watch = icon updates on tap)
    final isSaved = context.watch<BookmarkProvider>().isBookmarked(article);

    // True if article has no image URL (null or empty)
    final hasNoImage = article.imageUrl == null || article.imageUrl!.isEmpty;

    return Card(
      margin: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // CHANGED: Image.network → CachedNetworkImage
          // First time: downloads the image and saves it on the phone
          // Next time: loads it from the phone (works offline)
          hasNoImage
              ? _imagePlaceholder()
              : CachedNetworkImage(
                  imageUrl: article.imageUrl!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  // NEW: shown while downloading
                  placeholder: (context, url) => _loadingPlaceholder(),
                  // CHANGED: was errorBuilder, now errorWidget
                  // Shown if the link is bad, or offline and image was never cached
                  errorWidget: (context, url, error) => _imagePlaceholder(),
                ),

          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        article.title ??
                            '', // title can be null, so show '' instead
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(article.description ?? ''),
                    ],
                  ),
                ),

                // Bookmark button
                IconButton(
                  icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border),
                  onPressed: () {
                    // read = just call the method, no rebuild needed here
                    context.read<BookmarkProvider>().toggleBookmark(article);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
