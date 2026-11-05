import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:news_app/models/article.dart';

import 'helpers/mock_data_loader.dart';

void main() {
  group('Article', () {
    // Read the mock file once and get the list of articles from it
    final mockJson = jsonDecode(loadMockJson('headlines_success.json'));
    final articlesJson = mockJson['articles'] as List;

    test('fromJson reads all fields correctly', () {
      final article = Article.fromJson(articlesJson[0]);

      expect(article.title, 'Flutter 4 released');
      expect(article.description, 'Google announces a new Flutter version.');
      expect(article.imageUrl, 'https://example.com/flutter.jpg');
    });

    test('fromJson handles missing description and image', () {
      final article = Article.fromJson(articlesJson[1]);

      expect(article.title, 'Article with missing data');
      expect(article.description, isNull);
      expect(article.imageUrl, isNull);
    });

    test(
      'toJson → fromJson gives back the same article (used by bookmarks)',
      () {
        final original = Article.fromJson(articlesJson[0]);

        // Same steps bookmarks use: Article → JSON → Article
        final copy = Article.fromJson(original.toJson());

        expect(copy.title, original.title);
        expect(copy.description, original.description);
        expect(copy.imageUrl, original.imageUrl);
      },
    );
  });
}
