import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_app/presentation/features/products/screens/create_update_product_screen.dart';
import 'package:teslo_app/presentation/features/products/screens/product_detail_screen.dart';
import 'package:teslo_app/presentation/features/products/widgets/product_card.dart';
import 'package:teslo_app/presentation/providers/products_provider.dart';
import 'package:teslo_app/presentation/shared/widgets/side_menu.dart';

class ProductsScreen extends ConsumerStatefulWidget {
  static const String routeName = 'products';

  const ProductsScreen({super.key});

  @override
  ConsumerState<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends ConsumerState<ProductsScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToTopButton = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Mostrar botón de scroll to top si el usuario ha bajado más de 200 pixels
    if (_scrollController.position.pixels > 200 && !_showScrollToTopButton) {
      setState(() {
        _showScrollToTopButton = true;
      });
    } else if (_scrollController.position.pixels <= 200 && _showScrollToTopButton) {
      setState(() {
        _showScrollToTopButton = false;
      });
    }

    // Cargar más productos cuando esté cerca del final
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      ref.read(productsProvider.notifier).loadNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(productsProvider);
    final products = productsState.products;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Lógica de búsqueda (placeholder)
            },
          ),
        ],
      ),
      drawer: const SideMenu(),
      body: RefreshIndicator(
        onRefresh: () async {
          // Refrescar productos
          await ref.read(productsProvider.notifier).refresh();
        },
        child: products.isEmpty && !productsState.isLoading
            ? _buildEmptyState(context)
            : CustomScrollView(
                controller: _scrollController,
                slivers: [
                  // Grid de productos
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      delegate: SliverChildBuilderDelegate((context, index) {
                        if (index < products.length) {
                          final product = products[index];
                          return ProductCard(
                            product: product,
                            onTap: () {
                              // Navegación a detalle del producto
                              context.pushNamed(
                                ProductDetailScreen.routeName,
                                pathParameters: {'id': product.id},
                              );
                            },
                          );
                        }
                        return null;
                      }, childCount: products.length),
                    ),
                  ),

                  // Loading indicator
                  if (productsState.isLoading)
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    ),

                  // Final de la lista
                  if (productsState.isLastPage && products.isNotEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: Text(
                            'No hay más productos',
                            style: TextStyle(color: Colors.grey[600], fontSize: 14),
                          ),
                        ),
                      ),
                    ),

                  // Espaciado final
                  const SliverToBoxAdapter(child: SizedBox(height: 80)),
                ],
              ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedScale(
            scale: _showScrollToTopButton ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: AnimatedOpacity(
              opacity: _showScrollToTopButton ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: _showScrollToTopButton
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FloatingActionButton(
                          heroTag: 'scroll_top',
                          onPressed: () {
                            // Scroll to top
                            _scrollController.animateTo(
                              0,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: const Icon(Icons.arrow_upward),
                        ),
                        const SizedBox(height: 12),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          ),
          FloatingActionButton(
            heroTag: 'add_product',
            onPressed: () {
              context.pushNamed(CreateUpdateProductScreen.routeName);
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No hay productos disponibles',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Pull para refrescar',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
