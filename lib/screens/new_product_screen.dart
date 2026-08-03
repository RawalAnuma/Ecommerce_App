import 'package:flutter/material.dart';
import 'package:my_app/model/create_product_model.dart';
import 'package:my_app/provider/category_provider.dart';
import 'package:my_app/provider/new_product_provider.dart';
import 'package:provider/provider.dart';

class NewProductScreen extends StatefulWidget {
  const NewProductScreen({super.key});

  @override
  State<NewProductScreen> createState() => _NewProductScreenState();
}

class _NewProductScreenState extends State<NewProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageController = TextEditingController(
    text: 'https://images.unsplash.com/photo-1512436991641-6745cdb1723f',
  );
  int? _selectedCategoryId = 1;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<NewProductProvider>().getProducts();
        context.read<CategoryProvider>().getCategories();
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final provider = context.read<NewProductProvider>();

    final product = CreateProductModel(
      title: _titleController.text.trim(),
      price: int.tryParse(_priceController.text.trim()) ?? 0,
      description: _descriptionController.text.trim(),
      categoryId: _selectedCategoryId ?? 1,
      images: [
        _imageController.text.trim().isEmpty
            ? 'https://images.unsplash.com/photo-1512436991641-6745cdb1723f'
            : _imageController.text.trim(),
      ],
    );

    final createdProduct = await provider.createProduct(product);

    if (!mounted) {
      return;
    }

    if (createdProduct != null) {
      _formKey.currentState!.reset();
      _titleController.clear();
      _priceController.clear();
      _descriptionController.clear();
      _selectedCategoryId = 1;
      _imageController.text =
          'https://images.unsplash.com/photo-1512436991641-6745cdb1723f';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Created: ${createdProduct.title}')),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to create product')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NewProductProvider>();
    final categoryProvider = context.watch<CategoryProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Product'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEAF0FF),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.add_circle_outline,
                            color: Color(0xFF2563EB),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Add a new product',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Fill in the details and publish instantly.',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        prefixIcon: Icon(Icons.title),
                      ),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                          ? 'Please enter a title'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Price',
                        prefixIcon: Icon(Icons.attach_money),
                      ),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                          ? 'Please enter a price'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        prefixIcon: Icon(Icons.description_outlined),
                      ),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                          ? 'Please enter a description'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    categoryProvider.isLoading &&
                            categoryProvider.categories.isEmpty
                        ? const SizedBox(
                            height: 56,
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : ConstrainedBox(
                            constraints: const BoxConstraints(
                              minWidth: double.infinity,
                            ),
                            child: DropdownButtonFormField<int>(
                              isExpanded: true,
                              initialValue: _selectedCategoryId,
                              decoration: const InputDecoration(
                                labelText: 'Category',
                                prefixIcon: Icon(Icons.category_outlined),
                              ),
                              items: categoryProvider.categories
                                  .map(
                                    (category) => DropdownMenuItem<int>(
                                      value: category.id,
                                      child: Text(
                                        category.name,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedCategoryId = value;
                                });
                              },
                            ),
                          ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _imageController,
                      decoration: const InputDecoration(
                        labelText: 'Image URL',
                        prefixIcon: Icon(Icons.image_outlined),
                      ),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: provider.isLoading ? null : _submitForm,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        icon: provider.isLoading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.add_circle_outline),
                        label: Text(
                          provider.isLoading ? 'Creating...' : 'Create Product',
                        ),
                      ),
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
}
