import 'package:flutter/material.dart';

import '../models/article.dart';

class NewsCard extends StatelessWidget {
  final Article article;

  const NewsCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final imageUrl = article.imageUrl;

    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ARTICLE IMAGE
          if (imageUrl != null && imageUrl.isNotEmpty)
            Image.network(
              imageUrl,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,

              // URL exists but image fails to load
              errorBuilder: (context, error, stackTrace) {
                return _buildImagePlaceholder();
              },
            )
          else
            // Article has no image URL
            _buildImagePlaceholder(),

          // ARTICLE TITLE
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              article.title ?? 'No title',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          // ARTICLE DESCRIPTION
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Text(article.description ?? 'No description available'),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      width: double.infinity,
      height: 200,
      color: Colors.grey.shade200,
      child: const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          size: 50,
          color: Colors.grey,
        ),
      ),
    );
  }
}
