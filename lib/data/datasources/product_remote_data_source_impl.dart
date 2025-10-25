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
    try {
      final response = await apiClient.get<Map<String, dynamic>>('/products/$id');
      return ProductMapper.productJsonToEntity(response.data!);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        final errorMessage = e.response?.data['message'] ?? 'Producto no encontrado';
        throw Exception('Producto no encontrado: $errorMessage');
      }
      throw Exception('Error al obtener el producto: ${e.message}');
    } catch (e) {
      throw Exception('Error inesperado al obtener el producto: $e');
    }
  }

  @override
  Future<Product> createProduct(Product product) async {
    try {
      final response = await apiClient.post<Map<String, dynamic>>(
        '/products',
        data: {
          'title': product.title,
          'price': product.price,
          'description': product.description,
          'slug': product.slug,
          'stock': product.stock,
          'sizes': product.sizes,
          'gender': product.gender,
          'tags': product.tags,
          'images': product.images,
        },
      );
      return ProductMapper.productJsonToEntity(response.data!);
    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'] ?? 'Error desconocido';
      throw Exception('Error al crear el producto: $errorMessage');
    } catch (e) {
      throw Exception('Error inesperado al crear el producto: $e');
    }
  }

  @override
  Future<Product> updateProduct(Product product) async {
    try {
      final response = await apiClient.patch<Map<String, dynamic>>(
        '/products/${product.id}',
        data: {
          'title': product.title,
          'price': product.price,
          'description': product.description,
          'slug': product.slug,
          'stock': product.stock,
          'sizes': product.sizes,
          'gender': product.gender,
          'tags': product.tags,
          'images': product.images,
        },
      );
      return ProductMapper.productJsonToEntity(response.data!);
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final errorMessage = e.response?.data['message'] ?? 'Error desconocido';

      if (statusCode == 404) {
        throw Exception('Producto no encontrado: $errorMessage');
      } else if (statusCode == 403) {
        throw Exception('No tienes permisos para actualizar este producto: $errorMessage');
      }
      throw Exception('Error al actualizar el producto: $errorMessage');
    } catch (e) {
      throw Exception('Error inesperado al actualizar el producto: $e');
    }
  }
}
