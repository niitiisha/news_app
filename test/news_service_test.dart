import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:news_app/services/news_service.dart';

void main() {
  group('NewsService', () {
    test(
      'fetchHeadlines returns list of articles when request succeeds',
      () async {
        // Arrange
        final mockClient = MockClient((request) async {
          expect(request.url.path, '/v2/top-headlines');
          expect(request.url.queryParameters['country'], 'us');

          return http.Response('''
          {
            "status": "ok",
            "articles": [
              {
                "title": "Test Headline",
                "description": "Test Description",
                "urlToImage": "https://example.com/image.jpg"
              }
            ]
          }
          ''', 200);
        });

        final newsService = NewsService('fake-api-key', client: mockClient);

        // Act
        final articles = await newsService.fetchHeadlines();

        // Assert
        expect(articles.length, 1);
        expect(articles[0].title, 'Test Headline');
        expect(articles[0].description, 'Test Description');
        expect(articles[0].imageUrl, 'https://example.com/image.jpg');
      },
    );

    test('searchNews returns articles for search query', () async {
      // Arrange
      final mockClient = MockClient((request) async {
        expect(request.url.path, '/v2/everything');

        expect(request.url.queryParameters['q'], 'Flutter');

        return http.Response('''
          {
            "status": "ok",
            "articles": [
              {
                "title": "Flutter News",
                "description": "News about Flutter",
                "urlToImage": "https://example.com/flutter.jpg"
              }
            ]
          }
          ''', 200);
      });

      final newsService = NewsService('fake-api-key', client: mockClient);

      // Act
      final articles = await newsService.searchNews('Flutter');

      // Assert
      expect(articles.length, 1);
      expect(articles[0].title, 'Flutter News');
      expect(articles[0].description, 'News about Flutter');
    });

    test('fetchHeadlines throws exception when request fails', () async {
      // Arrange
      final mockClient = MockClient((request) async {
        return http.Response('Something went wrong', 500);
      });

      final newsService = NewsService('fake-api-key', client: mockClient);

      // Act + Assert
      expect(newsService.fetchHeadlines(), throwsException);
    });

    test('searchNews throws exception when request fails', () async {
      // Arrange
      final mockClient = MockClient((request) async {
        return http.Response('Something went wrong', 500);
      });

      final newsService = NewsService('fake-api-key', client: mockClient);

      // Act + Assert
      expect(newsService.searchNews('Flutter'), throwsException);
    });
  });
}
