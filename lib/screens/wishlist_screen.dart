import 'package:flutter/material.dart';
import 'package:my_app/provider/new_product_provider.dart';
import 'package:my_app/provider/product_provider.dart';
import 'package:my_app/widgets/new_product_card.dart';
import 'package:my_app/widgets/product_card.dart';
import 'package:provider/provider.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NewProductProvider>(
      builder: (context, provider, child) {
        final wishlistItems = provider.wishlist;

        if (wishlistItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.favorite_outline, size: 48),
                SizedBox(height: 12),
                Text("Wishlist is empty"),
              ],
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.66,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: wishlistItems.length,
          itemBuilder: (context, index) {
            return NewProductCard(product: wishlistItems[index]);
          },
        );
      },
    );
  }
}
