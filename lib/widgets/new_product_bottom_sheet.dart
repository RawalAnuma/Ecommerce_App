import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:my_app/model/new_product_model.dart';
import 'package:my_app/provider/new_product_provider.dart';
import 'package:provider/provider.dart';

class NewProductBottomSheet extends StatelessWidget {
  final NewProductModel product;

  const NewProductBottomSheet({super.key, required this.product});

  static Future<void> show(BuildContext context, NewProductModel product) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => NewProductBottomSheet(product: product),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.68,
      minChildSize: 0.45,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 48,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: AspectRatio(
                      aspectRatio: 1.2,
                      child: CarouselSlider.builder(
                        itemCount: product.images.length,
                        itemBuilder: (context, index, realIndex) {
                          return Image.network(
                            product.images[index],
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: const Color(0xFFF1F3F5),
                                alignment: Alignment.center,
                                child: const Icon(
                                  Icons.image_not_supported_outlined,
                                  color: Colors.black38,
                                  size: 36,
                                ),
                              );
                            },
                          );
                        },
                        options: CarouselOptions(
                          height: double.infinity,
                          viewportFraction: 1.0,
                          enableInfiniteScroll: product.images.length > 1,
                          autoPlay: product.images.length > 1,
                          autoPlayInterval: const Duration(seconds: 3),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          product.title,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      // Row(
                      //   children: [
                      //     const Icon(Icons.star, color: Colors.amber, size: 18),
                      //     const SizedBox(width: 4),
                      //     Text(
                      //       product.rating.toStringAsFixed(1),
                      //       style: const TextStyle(fontWeight: FontWeight.w700),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.category.name,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF2563EB),
                        ),
                      ),
                      // if (product.oldPrice != null) ...[
                      //   const SizedBox(width: 12),
                      //   Text(
                      //     '\$${product.oldPrice!.toStringAsFixed(2)}',
                      //     style: const TextStyle(
                      //       fontSize: 16,
                      //       color: Colors.grey,
                      //       decoration: TextDecoration.lineThrough,
                      //     ),
                      //   ),
                      // ],
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    product.description,
                    style: TextStyle(fontSize: 14, height: 1.5),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text('Close'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton(
                          onPressed: () {
                            final messenger = ScaffoldMessenger.of(context);
                            context.read<NewProductProvider>().addToCart(
                              product,
                            );

                            Navigator.pop(context);

                            messenger.showSnackBar(
                              SnackBar(
                                content: Text("${product.title}added to cart"),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text('Add to cart'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
