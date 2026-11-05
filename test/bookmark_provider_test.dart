import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:news_app/models/article.dart';
import 'package:news_app/providers/bookmark_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/mock_data_loader.dart'; // THIS LINE gives you loadMockJson

void main() {
  // Needed because SharedPreferences talks to the phone
  TestWidgetsFlutterBinding.ensureInitialized();

  late Article article;

  setUp(() {
    // Runs before EACH test: start with empty fake storage
    SharedPreferences.setMockInitialValues({});

    // Use the first article from the mock JSON
    final mockJson = jsonDecode(loadMockJson('headlines_success.json'));
    article = Article.fromJson(mockJson['articles'][0]);
  });

  group('BookmarkProvider', () {
    test('starts with no bookmarks', () async {
      final provider = BookmarkProvider();
      await provider.loadBookmarks();

      expect(provider.bookmarks, isEmpty);
    });

    test('toggleBookmark adds an article', () async {
      final provider = BookmarkProvider();
      await provider.toggleBookmark(article);

      expect(provider.bookmarks.length, 1);
      expect(provider.isBookmarked(article), isTrue);
    });

    test('toggleBookmark twice removes the article', () async {
      final provider = BookmarkProvider();
      await provider.toggleBookmark(article); // add
      await provider.toggleBookmark(article); // remove

      expect(provider.bookmarks, isEmpty);
      expect(provider.isBookmarked(article), isFalse);
    });

    test(
      'bookmarks are still there after app restart (offline save)',
      () async {
        // First "app session": bookmark an article
        final firstSession = BookmarkProvider();
        await firstSession.toggleBookmark(article);

        // New provider = like reopening the app
        final secondSession = BookmarkProvider();
        await secondSession.loadBookmarks();

        expect(secondSession.bookmarks.length, 1);
        expect(secondSession.bookmarks[0].title, 'Flutter 4 released');
        // Checks full article was saved, not just the title
        expect(
          secondSession.bookmarks[0].description,
          'Google announces a new Flutter version.',
        );
      },
    );
  });
}
