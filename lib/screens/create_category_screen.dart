import 'package:flutter/material.dart';
import 'package:my_app/provider/category_provider.dart';
import 'package:provider/provider.dart';

class CreateCategoryScreen extends StatefulWidget {
  const CreateCategoryScreen({super.key});

  @override
  State<CreateCategoryScreen> createState() => _CreateCategoryScreenState();
}

class _CreateCategoryScreenState extends State<CreateCategoryScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();

  final _imageController = TextEditingController(
    text: "https://placehold.co/600x400",
  );

  @override
  void dispose() {
    _nameController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final provider = context.read<CategoryProvider>();

    final category = await provider.createCategory(
      name: _nameController.text.trim(),
      image: _imageController.text.trim(),
    );

    if (!mounted) {
      return;
    }

    if (category != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "${category.name} created successfully.",
          ),
        ),
      );

      // Go back to CategoryScreen
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Failed to create category.",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CategoryProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Category"),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
      ),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .06),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),

              child: Form(
                key: _formKey,

                child: Column(
                  children: [
                    const Text(
                      "Create New Category",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Category Name
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: "Category Name",
                        prefixIcon: Icon(
                          Icons.category_outlined,
                        ),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty) {
                          return "Enter category name";
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 15),

                    // Image URL
                    TextFormField(
                      controller: _imageController,
                      keyboardType: TextInputType.url,
                      decoration: const InputDecoration(
                        labelText: "Image URL",
                        prefixIcon: Icon(
                          Icons.image_outlined,
                        ),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty) {
                          return "Enter image URL";
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 25),

                    // Create Button
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: provider.isLoading
                            ? null
                            : _submit,

                        icon: provider.isLoading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(
                                Icons.add,
                              ),

                        label: Text(
                          provider.isLoading
                              ? "Creating..."
                              : "Create Category",
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