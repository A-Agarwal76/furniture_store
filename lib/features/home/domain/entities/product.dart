class Product {
  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imagePath,
    this.rating = 4.5,
  });

  final String id;
  final String name;
  final double price;
  final String imagePath;
  final double rating;
}
