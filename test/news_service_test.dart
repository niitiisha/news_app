import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:news_app/services/news_service.dart';

import 'helpers/mock_data_loader.dart';

void main() {
  group('NewsService', () {
    test('fetchHeadlines returns articles from mock JSON', () async {
      final mockClient = MockClient((request) async {
        // Also checks that our code sends the API key
        expect(request.url.queryParameters['apiKey'], 'test-key');
        return http.Response(loadMockJson('headlines_success.json'), 200);
      });

      final service = NewsService('test-key', client: mockClient);
      final articles = await service.fetchHeadlines();

      expect(articles.length, 2);
      expect(articles[0].title, 'Flutter 4 released');
    });

    test('fetchHeadlines throws when API returns an error', () async {
      final mockClient = MockClient((request) async {
        return http.Response(loadMockJson('error_response.json'), 401);
      });

      final service = NewsService('wrong-key', client: mockClient);

      expect(() => service.fetchHeadlines(), throwsException);
    });

    test('searchNews sends the query and returns results', () async {
      final mockClient = MockClient((request) async {
        // Checks that the search word is sent as "q"
        expect(request.url.queryParameters['q'], 'dart');
        return http.Response(loadMockJson('search_success.json'), 200);
      });

      final service = NewsService('test-key', client: mockClient);
      final articles = await service.searchNews('dart');

      expect(articles.length, 1);
      expect(articles[0].title, 'Learning Dart in 2026');
    });
  });
}
