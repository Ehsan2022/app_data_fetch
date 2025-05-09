// Model class
class Book {
  final String id;
  final String name;
  final String author;
  final String year;

  Book({
    required this.id,
    required this.name,
    required this.author,
    required this.year,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      author: json['author'] ?? '',
      year: json['year'] ?? '',
    );
  }
}


