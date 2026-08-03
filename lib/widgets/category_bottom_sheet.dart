import 'package:flutter/material.dart';
import 'package:my_app/model/category_model.dart';
import 'package:my_app/provider/category_provider.dart';
import 'package:provider/provider.dart';

class CategoryBottomSheet extends StatelessWidget {
  final CategoryModel category;

  const CategoryBottomSheet({
    super.key,
    required this.category,
  });

  static Future<void> show(
    BuildContext context,
    CategoryModel category,
  ) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CategoryBottomSheet(
        category: category,
      ),
    );
  }

  Future<void> _showEditDialog(BuildContext context) async {
    final provider = context.read<CategoryProvider>();

    final nameController = TextEditingController(
      text: category.name,
    );

    final imageController = TextEditingController(
      text: category.image,
    );

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit category'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Category name',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: imageController,
              decoration: const InputDecoration(
                labelText: 'Image URL',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext, false);
            },
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext, true);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) {
      return;
    }

    final success = await provider.updateCategory(
      category.id,
      name: nameController.text.trim(),
      image: imageController.text.trim(),
    );

    if (!context.mounted) {
      return;
    }

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Category updated'
              : 'Failed to update category',
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final provider = context.read<CategoryProvider>();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete category'),
        content: Text(
          'Delete "${category.name}"? This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext, false);
            },
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext, true);
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) {
      return;
    }

    final success = await provider.deleteCategory(
      category.id,
    );

    if (!context.mounted) {
      return;
    }

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Category deleted'
              : 'Failed to delete category',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      minChildSize: 0.40,
      maxChildSize: 0.85,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(28),
            ),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                12,
                20,
                24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Drag handle
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

                  // Category Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: AspectRatio(
                      aspectRatio: 1.5,
                      child: Image.network(
                        category.image,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (
                          context,
                          error,
                          stackTrace,
                        ) {
                          return Container(
                            color: const Color(0xFFF1F3F5),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.image_not_supported_outlined,
                              color: Colors.black38,
                              size: 42,
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Category Name
                  Text(
                    category.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Category Slug
                  Text(
                    category.slug,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Edit + Delete
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            _showEditDialog(context);
                          },
                          icon: const Icon(
                            Icons.edit_outlined,
                          ),
                          label: const Text('Edit'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            _confirmDelete(context);
                          },
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                          label: const Text(
                            'Delete',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              vertical: 14,
                            ),
                            side: const BorderSide(
                              color: Colors.red,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Close
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text('Close'),
                    ),
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