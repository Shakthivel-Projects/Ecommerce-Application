class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final String image;
  final String category;
  final String? brand;
  final int stock;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.image,
    required this.category,
    this.brand,
    required this.stock,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'] ?? json['id'],
      title: json['title'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      image: json['image'],
      category: json['category'],
      brand: json['brand'],
      stock: json['stock'] ?? 0,
    );
  }
}
