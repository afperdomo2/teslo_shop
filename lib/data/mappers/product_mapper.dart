import 'package:teslo_app/config/constants/envs_constants.dart';
import 'package:teslo_app/domain/entities/product.dart';

class ProductMapper {
  static Product productJsonToEntity(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      title: json['title'] as String,
      price: json['price'] as int,
      description: json['description'] as String,
      slug: json['slug'] as String,
      stock: json['stock'] as int,
      sizes: List<String>.from(json['sizes']),
      gender: json['gender'] as String,
      tags: List<String>.from(json['tags']),
      user: ProductUserMapper.productUserJsonToEntity(json['user'] as Map<String, dynamic>),
      images: List<String>.from(json['images'])
          .map(
            (String image) =>
                image.startsWith('http') ? image : '${EnvsConstants.apiUrl}/files/product/$image',
          )
          .toList(),
    );
  }
}

class ProductUserMapper {
  static ProductUser productUserJsonToEntity(Map<String, dynamic> json) {
    return ProductUser(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] as String,
      isActive: json['isActive'] as bool,
      roles: List<String>.from(json['roles']),
    );
  }
}
