class Article {
  final String? title;
  final String? description;
  final String? imageUrl;

  Article({this.title, this.description, this.imageUrl});

  // JSON (from NewsAPI or saved bookmark) → Article
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'],
      description: json['description'],
      imageUrl: json['urlToImage'],
    );
  }

  // NEW: Article → JSON (used to save bookmarks on the phone)
  // Keys must match the ones fromJson reads above
  Map<String, dynamic> toJson() {
    return {'title': title, 'description': description, 'urlToImage': imageUrl};
  }
}
