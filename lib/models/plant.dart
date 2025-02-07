class Plant {
  final String name;
  final String category;
  final String description;
  final String imageUrl;

  Plant({
    required this.name,
    required this.category,
    required this.description,
    required this.imageUrl,
  });

  String get title => '$category-$name';
} 