import 'package:flutter/material.dart';
import 'package:teslo_app/domain/entities/product.dart';
import 'package:teslo_app/presentation/features/products/widgets/product_image_carousel.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;

  const ProductCard({super.key, required this.product, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del producto con carrusel
            Expanded(
              flex: 3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: ProductImageCarousel(
                      images: product.images,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    ),
                  ),

                  // Overlay gris para productos agotados
                  if (product.stock == 0)
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      child: Container(color: Colors.grey.withOpacity(0.3)),
                    ),

                  // Cinta horizontal "AGOTADO" para productos sin stock
                  if (product.stock == 0)
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: Center(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Text(
                            'AGOTADO',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 3,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Información del producto
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Título
                    Text(
                      product.title,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 2),

                    // Género
                    Row(
                      children: [
                        Icon(_getGenderIcon(product.gender), size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 3),
                        Text(
                          _getGenderLabel(product.gender),
                          style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                        ),
                      ],
                    ),

                    const Spacer(),

                    // Precio
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[400]),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getGenderIcon(String gender) {
    switch (gender.toLowerCase()) {
      case 'men':
        return Icons.man;
      case 'women':
        return Icons.woman;
      case 'kid':
        return Icons.child_care;
      case 'unisex':
        return Icons.people;
      default:
        return Icons.person;
    }
  }

  String _getGenderLabel(String gender) {
    switch (gender.toLowerCase()) {
      case 'men':
        return 'Hombre';
      case 'women':
        return 'Mujer';
      case 'kid':
        return 'Niño';
      case 'unisex':
        return 'Unisex';
      default:
        return gender;
    }
  }
}
