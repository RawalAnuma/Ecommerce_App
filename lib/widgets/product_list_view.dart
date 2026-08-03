import 'package:flutter/material.dart';
import 'package:my_app/provider/new_product_provider.dart';
import 'package:provider/provider.dart';
import 'new_product_card.dart';


class ProductListView extends StatelessWidget {
  const ProductListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NewProductProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.66,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: provider.products.length,
          itemBuilder: (context, index) {
            return NewProductCard(product: provider.products[index]);
          },
        );
      },
    );
  }
}
