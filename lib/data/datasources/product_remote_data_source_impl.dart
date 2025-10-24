import 'package:dio/dio.dart';
import 'package:teslo_app/config/constants/envs_constants.dart';
import 'package:teslo_app/data/mappers/product_mappert.dart';
import 'package:teslo_app/domain/datasources/product_data_source.dart';
import 'package:teslo_app/domain/entities/product.dart';

class ProductRemoteDataSourceImpl extends ProductDataSource {
  late final Dio apiClient;
  final String accessToken;

  ProductRemoteDataSourceImpl({required this.accessToken})
    : apiClient = Dio(
        BaseOptions(
          baseUrl: EnvsConstants.apiUrl,
          connectTimeout: const Duration(milliseconds: 5000),
          receiveTimeout: const Duration(milliseconds: 3000),
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

  @override
  Future<List<Product>> findAllProductsByPage({int limit = 10, int offset = 0}) async {
    final response = await apiClient.get<List<dynamic>>(
      '/products',
      queryParameters: {'limit': limit, 'offset': offset},
    );
    return (response.data as List)
        .map((productJson) => ProductMapper.productJsonToEntity(productJson))
        .toList();
  }

  @override
  Future<Product> findProductById(String id) async {
    final response = await apiClient.get<Map<String, dynamic>>('/products/$id');
    return ProductMapper.productJsonToEntity(response.data!);
  }
}
