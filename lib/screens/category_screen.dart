import 'package:flutter/material.dart';
import 'package:my_app/provider/category_provider.dart';
import 'package:my_app/provider/new_product_provider.dart';
import 'package:my_app/screens/create_category_screen.dart';
import 'package:my_app/widgets/category_card.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<CategoryProvider>().getCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = context.watch<CategoryProvider>();
    final productProvider = context.watch<NewProductProvider>();

    return Scaffold(
      body: categoryProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: categoryProvider.categories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemBuilder: (context, index) {
                final category = categoryProvider.categories[index];

                final count = productProvider.products
                    .where((product) => product.category.id == category.id)
                    .length;

                return CategoryCard(category: category, productCount: count);
              },
            ),

      // Add Category Button
      floatingActionButton: FloatingActionButton.extended(
        heroTag: "create_category",

        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateCategoryScreen()),
          );

          // Refresh categories after returning
          if (mounted) {
            context.read<CategoryProvider>().getCategories();
          }
        },

        icon: const Icon(Icons.category_outlined),
        label: const Text("Add Category"),
      ),
    );
  }
}
