import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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

  File? _pickedImage;
  bool _isUploadingImage = false;

  Future<void> _pickImageFromGallery() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (picked != null) {
      setState(() {
        _pickedImage = File(picked.path);
      });
    }
  }

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
    var imageUrl = _imageController.text.trim();

    if (_pickedImage != null) {
      setState(() => _isUploadingImage = true);
      
      final uploadedUrl = await provider.uploadImage(_pickedImage!);
      if (!mounted) {
        return;
      }
      setState(() => _isUploadingImage = false);

      if (uploadedUrl == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to upload image')));
        return;
      }
      imageUrl = uploadedUrl;
    }

    final category = await provider.createCategory(
      name: _nameController.text.trim(),
      image: imageUrl,
    );

    if (!mounted) {
      return;
    }

    if (category != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${category.name} created successfully.")),
      );

      // Go back to CategoryScreen
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to create category.")),
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
                        prefixIcon: Icon(Icons.category_outlined),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
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
                        prefixIcon: Icon(Icons.image_outlined),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Enter image URL";
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 12),
                    Row(
                      children: [
                        if (_pickedImage != null) ...[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              _pickedImage!,
                              width: 56,
                              height: 56,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 12),
                        ],
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _pickImageFromGallery,
                            icon: const Icon(Icons.photo_library_outlined),
                            label: Text(
                              _pickedImage == null
                                  ? 'Pick image from gallery'
                                  : 'Change picked image',
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    // Create Button
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: provider.isLoading || _isUploadingImage
                            ? null
                            : _submit,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        icon: provider.isLoading || _isUploadingImage
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.add),

                        label: Text(
                          _isUploadingImage
                              ? 'Uploading image ...'
                              : provider.isLoading
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
