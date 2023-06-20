
import 'dart:convert';

class News {
  News({
    required this.title,
    required this.publishedAt,
  });

  factory News.fromMap(Map<String, dynamic> map) {
    return News(
      title: map['title'] as String,
      publishedAt: map['publishedAt'] as String,
    );
  }

  static final empty = News(title: "title", publishedAt: "publishedAt");

  factory News.fromJson(String source) =>
      News.fromMap(json.decode(source) as Map<String, dynamic>);
  final String title;
  final String publishedAt;

  News copyWith({
    String? title,
    String? publishedAt,
  }) {
    return News(
      title: title ?? this.title,
      publishedAt: publishedAt ?? this.publishedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'publishedAt': publishedAt,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() => 'News(title: $title, publishedAt: $publishedAt)';

  @override
  bool operator ==(covariant News other) {
    if (identical(this, other)) return true;

    return other.title == title && other.publishedAt == publishedAt;
  }

  @override
  int get hashCode => title.hashCode ^ publishedAt.hashCode;
}
