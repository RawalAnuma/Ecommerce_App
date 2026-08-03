import 'package:flutter/material.dart';
import 'package:my_app/model/category_model.dart';

class CategoryCard extends StatelessWidget {
  final CategoryModel category;
  final int productCount;

  const CategoryCard({
    super.key,
    required this.category,
    required this.productCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 220, 220, 220),

        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 22,
            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Padding(
        padding: const EdgeInsetsGeometry.all(14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircleAvatar(
              radius: 55,
              backgroundColor: Colors.grey.shade100,
              child: ClipOval(
                child: Image.network(
                  category.image,
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) {
                    return const Icon(
                      Icons.category,
                      size: 45,
                      color: Colors.grey,
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 8),

            Text(
              category.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 6),

            Text(
              "$productCount Items",
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
