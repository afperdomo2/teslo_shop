import 'package:dio/dio.dart';
import 'package:teslo_app/config/constants/envs_constants.dart';
import 'package:teslo_app/data/mappers/file_uploaded_mapper.dart';
import 'package:teslo_app/data/mappers/product_mapper.dart';
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
      final List<String> images = await _uploadAndGetImages(product.images);
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
          'images': images,
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

  Future<String> _uploadFile(String path) async {
    try {
      String fileName = path.split('/').last;
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(path, filename: fileName),
      });
      final response = await apiClient.post('/files/product', data: formData);
      if (response.statusCode == 201) {
        String imageUrl = FileUploadedMapper.fileJsonToEntity(response.data!).image;
        return imageUrl;
      } else {
        throw Exception('Error al subir la imagen: $fileName - Status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error de red al subir la imagen: ${e.message}');
    } catch (e) {
      throw Exception('Error inesperado al subir la imagen: $e');
    }
  }

  Future<List<String>> _uploadAndGetImages(List<String> imagePaths) async {
    final imagesToUpload = imagePaths.where((path) {
      return !path.startsWith('http://') && !path.startsWith('https://');
    }).toList();

    final imagesToIgnore = imagePaths.where((path) {
      return path.startsWith('http://') || path.startsWith('https://');
    }).toList();

    // Si no hay imágenes para subir, retornar solo las remotas
    if (imagesToUpload.isEmpty) {
      return imagesToIgnore;
    }

    final List<Future<String>> uploadJob = imagesToUpload.map(_uploadFile).toList();
    final uploadedImageUrls = await Future.wait(uploadJob);

    return [...imagesToIgnore, ...uploadedImageUrls];
  }

  @override
  Future<Product> updateProduct(Product product) async {
    try {
      final List<String> images = await _uploadAndGetImages(product.images);
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
          'images': images,
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
