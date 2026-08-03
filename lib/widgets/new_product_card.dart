import 'package:flutter/material.dart';
import 'package:my_app/widgets/new_product_bottom_sheet.dart';
import 'package:provider/provider.dart';

import '../model/new_product_model.dart';
import '../provider/new_product_provider.dart';

class NewProductCard extends StatelessWidget {
  final NewProductModel product;

  const NewProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<NewProductProvider>();
    final isWishlisted = productProvider.isInWishlist(product.id);

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => NewProductBottomSheet.show(context, product),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(18),
                    ),
                    child: SizedBox.expand(
                      child: Image.network(
                        product.images.first,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: const Color(0xFFF1F3F5),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.image_not_supported_outlined,
                              color: Colors.black38,
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  // Wishlist Button
                  Positioned(
                    top: 10,
                    right: 10,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.white.withValues(alpha: 0.95),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        iconSize: 18,
                        onPressed: () {
                          context.read<NewProductProvider>().toggleWishlist(
                            product,
                          );
                        },
                        icon: Icon(
                          isWishlisted ? Icons.favorite : Icons.favorite_border,
                          color: isWishlisted ? Colors.red : Colors.black87,
                        ),
                      ),
                    ),
                  ),

                  // Add to Cart Button
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: Material(
                      color: const Color(0xFF2563EB),
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          context.read<NewProductProvider>().addToCart(product);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("${product.title} added to cart"),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(Icons.add, color: Colors.white, size: 18),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.category.name,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "\$${product.price}",
                    style: const TextStyle(
                      color: Color(0xFF2563EB),
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
