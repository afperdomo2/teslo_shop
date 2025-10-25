import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_app/domain/entities/product.dart';
import 'package:teslo_app/domain/repositories/product_repository.dart';
import 'package:teslo_app/presentation/providers/product_repository_provider.dart';

// 1. Provider
final productsProvider = StateNotifierProvider<ProductsNotifier, ProductsState>((ref) {
  final productsRepository = ref.watch(productRepositoryProvider);
  return ProductsNotifier(productsRepository: productsRepository);
});

// 2. State
class ProductsState {
  final bool isLastPage;
  final bool isLoading;
  final List<Product> products;
  final int limit;
  final int offset;

  ProductsState({
    this.isLastPage = false,
    this.limit = 10,
    this.offset = 0,
    this.isLoading = false,
    this.products = const [],
  });

  ProductsState copyWith({
    bool? isLastPage,
    bool? isLoading,
    List<Product>? products,
    int? limit,
    int? offset,
  }) {
    return ProductsState(
      isLastPage: isLastPage ?? this.isLastPage,
      isLoading: isLoading ?? this.isLoading,
      products: products ?? this.products,
      limit: limit ?? this.limit,
      offset: offset ?? this.offset,
    );
  }
}

// 3. Notifier
class ProductsNotifier extends StateNotifier<ProductsState> {
  final ProductRepository productsRepository;

  ProductsNotifier({required this.productsRepository}) : super(ProductsState()) {
    loadNextPage();
  }

  Future<void> loadNextPage() async {
    if (state.isLoading || state.isLastPage) return;

    state = state.copyWith(isLoading: true);

    final products = await productsRepository.findAllProductsByPage(
      limit: state.limit,
      offset: state.offset,
    );

    final isLastPage = products.length < state.limit;

    state = state.copyWith(
      isLoading: false,
      isLastPage: isLastPage,
      offset: state.offset + products.length,
      products: [...state.products, ...products],
    );
  }

  Future<void> refresh() async {
    if (state.isLoading) return;

    // Resetear el estado
    state = ProductsState(isLoading: true);

    final products = await productsRepository.findAllProductsByPage(limit: state.limit, offset: 0);

    final isLastPage = products.length < state.limit;

    state = state.copyWith(
      isLoading: false,
      isLastPage: isLastPage,
      offset: products.length,
      products: products,
    );
  }
}
