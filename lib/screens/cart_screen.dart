import 'package:flutter/material.dart';
import 'package:my_app/provider/new_product_provider.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NewProductProvider>(
      builder: (context, provider, child) {
        if (provider.cart.isEmpty) {
          return const Center(child: Text("Cart is empty"));
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: provider.cart.length,
                itemBuilder: (context, index) {
                  final item = provider.cart[index];

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Product Image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              item.product.images.first,
                              width: 90,
                              height: 90,
                              fit: BoxFit.cover,
                            ),
                          ),

                          const SizedBox(width: 15),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.product.title,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),

                                const SizedBox(height: 8),

                                Text(
                                  "\$${item.product.price}",
                                  style: const TextStyle(
                                    fontSize: 17,
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),

                                const SizedBox(height: 12),

                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        provider.decreaseQuantity(
                                          item.product.id,
                                        );
                                      },
                                      borderRadius: BorderRadius.circular(20),
                                      child: Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                            255,
                                            196,
                                            195,
                                            195,
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.remove,
                                          size: 20,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(width: 15),

                                    Text(
                                      item.quantity.toString(),
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(width: 15),

                                    InkWell(
                                      onTap: () {
                                        provider.increaseQuantity(
                                          item.product.id,
                                        );
                                      },
                                      borderRadius: BorderRadius.circular(20),
                                      child: Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.shade100,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(Icons.add, size: 20),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Delete Button
                          IconButton(
                            onPressed: () {
                              provider.removeFromCart(item.product.id);
                            },
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                              size: 28,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsetsGeometry.all(16),
              child: Text(
                "Total Price: \$${provider.totalPrice.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
