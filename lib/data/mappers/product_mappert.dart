import 'package:teslo_app/domain/entities/product.dart';

class ProductMapper {
  static Product productJsonToEntity(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      price: json['price'],
      description: json['description'],
      slug: json['slug'],
      stock: json['stock'],
      sizes: List<String>.from(json['sizes']),
      gender: json['gender'],
      tags: List<String>.from(json['tags']),
      images: List<String>.from(json['images']),
    );
  }
}
