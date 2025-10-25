import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_app/data/datasources/product_remote_data_source_impl.dart';
import 'package:teslo_app/data/repositories/product_repository_impl.dart';
import 'package:teslo_app/domain/repositories/product_repository.dart';
import 'package:teslo_app/presentation/providers/auth_provider.dart';

// Este provider tiene implementado correctamente el clean architecture, para manejar la inyeccion de dependencias
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final accessToken = ref.watch(authProvider).user?.token ?? '';
  final datasource = ProductRemoteDataSourceImpl(accessToken: accessToken);
  return ProductRepositoryImpl(datasource);
});
