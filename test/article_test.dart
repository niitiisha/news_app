import 'package:flutter_test/flutter_test.dart';
import 'package:news_app/models/article.dart';

void main() {
  group('Article.fromJson', () {
    test('creates Article correctly from JSON', () {
      // Arrange
      final json = {
        'title': 'Flutter News',
        'description': 'Flutter is used for app development',
        'urlToImage': 'https://example.com/image.jpg',
      };

      // Act
      final article = Article.fromJson(json);

      // Assert
      expect(article.title, 'Flutter News');
      expect(article.description, 'Flutter is used for app development');
      expect(article.imageUrl, 'https://example.com/image.jpg');
    });

    test('handles null values correctly', () {
      // Arrange
      final json = {'title': null, 'description': null, 'urlToImage': null};

      // Act
      final article = Article.fromJson(json);

      // Assert
      expect(article.title, isNull);
      expect(article.description, isNull);
      expect(article.imageUrl, isNull);
    });
  });
}
