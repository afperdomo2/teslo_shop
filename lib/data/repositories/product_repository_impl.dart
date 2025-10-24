import 'package:teslo_app/domain/datasources/product_data_source.dart';
import 'package:teslo_app/domain/entities/product.dart';
import 'package:teslo_app/domain/repositories/product_repository.dart';

class ProductRepositoryImpl extends ProductRepository {
  final ProductDataSource _dataSource;

  ProductRepositoryImpl(this._dataSource);

  @override
  Future<List<Product>> findAllProductsByPage({int limit = 10, int offset = 0}) {
    return _dataSource.findAllProductsByPage(limit: limit, offset: offset);
  }

  @override
  Future<Product> findProductById(String id) {
    return _dataSource.findProductById(id);
  }
}
