import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_app/domain/entities/product.dart';
import 'package:teslo_app/presentation/providers/product_repository_provider.dart';

// Provider para obtener un producto por ID
final productProvider = StateNotifierProvider.family<ProductNotifier, ProductState, String>((
  ref,
  productId,
) {
  final productRepository = ref.watch(productRepositoryProvider);
  return ProductNotifier(productRepository: productRepository, productId: productId);
});

// Estado del producto
class ProductState {
  final Product? product;
  final bool isLoading;
  final String? errorMessage;

  ProductState({this.product, this.isLoading = false, this.errorMessage});

  ProductState copyWith({Product? product, bool? isLoading, String? errorMessage}) {
    return ProductState(
      product: product ?? this.product,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

// Notifier para manejar la lógica del producto
class ProductNotifier extends StateNotifier<ProductState> {
  final productRepository;
  final String productId;

  ProductNotifier({required this.productRepository, required this.productId})
    : super(ProductState(isLoading: true)) {
    loadProduct();
  }

  Future<void> loadProduct() async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      final product = await productRepository.findProductById(productId);
      state = state.copyWith(product: product, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error al cargar el producto: ${e.toString()}',
      );
    }
  }

  Future<void> refresh() async {
    await loadProduct();
  }
}
