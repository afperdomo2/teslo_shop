import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_app/presentation/providers/product_provider.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  static const String routeName = 'product-detail';
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  ConsumerState<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  int _currentImageIndex = 0;
  String? _selectedSize;

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(productProvider(widget.productId));

    return Scaffold(
      appBar: AppBar(title: const Text('Detalles del Producto'), centerTitle: true),
      body: productState.isLoading
          ? const _LoadingView()
          : productState.errorMessage != null
          ? _ErrorView(
              errorMessage: productState.errorMessage!,
              onRetry: () => ref.read(productProvider(widget.productId).notifier).refresh(),
            )
          : _ProductDetailView(
              product: productState.product!,
              currentImageIndex: _currentImageIndex,
              selectedSize: _selectedSize,
              onImageChanged: (index) => setState(() => _currentImageIndex = index),
              onSizeSelected: (size) => setState(() => _selectedSize = size),
            ),
    );
  }
}

// Vista de carga
class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [CircularProgressIndicator(), SizedBox(height: 16), Text('Cargando producto...')],
      ),
    );
  }
}

// Vista de error
class _ErrorView extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const _ErrorView({required this.errorMessage, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 80, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(
              'Error al cargar el producto',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}

// Vista principal del detalle del producto
class _ProductDetailView extends StatelessWidget {
  final product;
  final int currentImageIndex;
  final String? selectedSize;
  final Function(int) onImageChanged;
  final Function(String) onSizeSelected;

  const _ProductDetailView({
    required this.product,
    required this.currentImageIndex,
    required this.selectedSize,
    required this.onImageChanged,
    required this.onSizeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return CustomScrollView(
      slivers: [
        // AppBar con imagen
        SliverAppBar(
          expandedHeight: size.height * 0.4,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: _ImageCarousel(
              images: product.images,
              currentIndex: currentImageIndex,
              onPageChanged: onImageChanged,
            ),
          ),
        ),

        // Contenido del producto
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título y precio
                _ProductHeader(product: product),
                const SizedBox(height: 20),

                // Stock y género
                _ProductInfo(product: product),
                const SizedBox(height: 24),

                // Selector de tallas
                _SizeSelector(
                  sizes: product.sizes,
                  selectedSize: selectedSize,
                  onSizeSelected: onSizeSelected,
                ),
                const SizedBox(height: 24),

                // Descripción
                _ProductDescription(description: product.description),
                const SizedBox(height: 24),

                // Tags
                if (product.tags.isNotEmpty) _ProductTags(tags: product.tags),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Carrusel de imágenes
class _ImageCarousel extends StatelessWidget {
  final List<String> images;
  final int currentIndex;
  final Function(int) onPageChanged;

  const _ImageCarousel({
    required this.images,
    required this.currentIndex,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return Container(
        color: Colors.grey[200],
        child: const Center(child: Icon(Icons.image_not_supported, size: 80, color: Colors.grey)),
      );
    }

    return Stack(
      children: [
        PageView.builder(
          itemCount: images.length,
          onPageChanged: onPageChanged,
          itemBuilder: (context, index) {
            return Image.network(
              images[index],
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[200],
                  child: const Center(
                    child: Icon(Icons.broken_image, size: 80, color: Colors.grey),
                  ),
                );
              },
            );
          },
        ),
        // Indicador de páginas
        if (images.length > 1)
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                images.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: currentIndex == index
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// Header con título y precio
class _ProductHeader extends StatelessWidget {
  final product;

  const _ProductHeader({required this.product});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.title,
                style: Theme.of(
                  context,
                ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                product.slug,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '\$${product.price}',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

// Información del producto (stock y género)
class _ProductInfo extends StatelessWidget {
  final product;

  const _ProductInfo({required this.product});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _InfoChip(
          icon: Icons.inventory_2_outlined,
          label: 'Stock: ${product.stock}',
          color: product.stock > 0 ? Colors.green : Colors.red,
        ),
        const SizedBox(width: 12),
        _InfoChip(
          icon: product.gender == 'men'
              ? Icons.man
              : product.gender == 'women'
              ? Icons.woman
              : Icons.wc,
          label: product.gender == 'men'
              ? 'Hombre'
              : product.gender == 'women'
              ? 'Mujer'
              : 'Unisex',
          color: Colors.blue,
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoChip({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

// Selector de tallas
class _SizeSelector extends StatelessWidget {
  final List<String> sizes;
  final String? selectedSize;
  final Function(String) onSizeSelected;

  const _SizeSelector({
    required this.sizes,
    required this.selectedSize,
    required this.onSizeSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (sizes.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Selecciona tu talla',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: sizes.map((size) {
            final isSelected = selectedSize == size;
            return GestureDetector(
              onTap: () => onSizeSelected(size),
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: isSelected ? Theme.of(context).primaryColor : Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? Theme.of(context).primaryColor : Colors.grey[300]!,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    size.toUpperCase(),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// Descripción del producto
class _ProductDescription extends StatelessWidget {
  final String description;

  const _ProductDescription({required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Descripción',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Text(
          description,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: Colors.grey[700], height: 1.6),
        ),
      ],
    );
  }
}

// Tags del producto
class _ProductTags extends StatelessWidget {
  final List<String> tags;

  const _ProductTags({required this.tags});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Etiquetas',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: tags.map((tag) {
            return Chip(
              label: Text(tag),
              backgroundColor: Colors.grey[200],
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            );
          }).toList(),
        ),
      ],
    );
  }
}
