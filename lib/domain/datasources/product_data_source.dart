import 'package:teslo_app/domain/entities/product.dart';

abstract class ProductDataSource {
  Future<List<Product>> findAllProductsByPage({int limit = 10, int offset = 0});

  Future<Product> findProductById(String id);
}
