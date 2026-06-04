class Product {
  final String id;
  final String categoryId;
  final String name;
  final double price;
  final int stockQuantity;
  final int minStockLevel;

  Product({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.price,
    required this.stockQuantity,
    required this.minStockLevel,
  });

  factory Product.fromJson(Map<String, dynamic> json, String id) {
    return Product(
      id: id,
      categoryId: json['categoryId'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      stockQuantity: json['stockQuantity'] as int,
      minStockLevel: json['minStockLevel'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
      'name': name,
      'price': price,
      'stockQuantity': stockQuantity,
      'minStockLevel': minStockLevel,
    };
  }
}
