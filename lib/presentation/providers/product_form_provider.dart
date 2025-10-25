import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_app/domain/entities/product.dart';
import 'package:teslo_app/domain/repositories/product_repository.dart';
import 'package:teslo_app/presentation/providers/product_repository_provider.dart';

// Provider para el formulario de productos
final productFormProvider =
    StateNotifierProvider.autoDispose<ProductFormNotifier, ProductFormState>((ref) {
      final productRepository = ref.watch(productRepositoryProvider);
      return ProductFormNotifier(productRepository: productRepository);
    });

// Estado del formulario
class ProductFormState {
  final bool isLoading;
  final bool isSaved;
  final String? errorMessage;
  final Product? savedProduct;

  ProductFormState({
    this.isLoading = false,
    this.isSaved = false,
    this.errorMessage,
    this.savedProduct,
  });

  ProductFormState copyWith({
    bool? isLoading,
    bool? isSaved,
    String? errorMessage,
    Product? savedProduct,
  }) {
    return ProductFormState(
      isLoading: isLoading ?? this.isLoading,
      isSaved: isSaved ?? this.isSaved,
      errorMessage: errorMessage,
      savedProduct: savedProduct ?? this.savedProduct,
    );
  }
}

// Notifier para el formulario
class ProductFormNotifier extends StateNotifier<ProductFormState> {
  final ProductRepository productRepository;

  ProductFormNotifier({required this.productRepository}) : super(ProductFormState());

  Future<bool> createProduct(Product product) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null, isSaved: false);
      final createdProduct = await productRepository.createProduct(product);
      state = state.copyWith(isLoading: false, isSaved: true, savedProduct: createdProduct);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isSaved: false,
        errorMessage: 'Error al crear el producto: ${e.toString()}',
      );
      return false;
    }
  }

  Future<bool> updateProduct(Product product) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null, isSaved: false);
      final updatedProduct = await productRepository.updateProduct(product);
      state = state.copyWith(isLoading: false, isSaved: true, savedProduct: updatedProduct);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isSaved: false,
        errorMessage: 'Error al actualizar el producto: ${e.toString()}',
      );
      return false;
    }
  }

  void resetState() {
    state = ProductFormState();
  }
}
