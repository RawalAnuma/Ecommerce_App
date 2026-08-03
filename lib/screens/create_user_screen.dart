import 'package:flutter/material.dart';
import 'package:my_app/model/create_user_model.dart';
import 'package:my_app/provider/user_provider.dart';
import 'package:provider/provider.dart';

class CreateUserScreen extends StatefulWidget {
  const CreateUserScreen({super.key});

  @override
  State<CreateUserScreen> createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _avatarController = TextEditingController(
    text: "https://i.pravatar.cc/300",
  );

  String _selectedRole = "customer";

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<UserProvider>().getUsers();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _avatarController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<UserProvider>();

    final user = CreateUserModel(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      avatar: _avatarController.text.trim(),
      role: _selectedRole,
    );

    final created = await provider.createUser(user);

    if (!mounted) return;

    if (created != null) {
      _formKey.currentState!.reset();

      _nameController.clear();
      _emailController.clear();
      _passwordController.clear();

      _avatarController.text = "https://i.pravatar.cc/300";

      setState(() {
        _selectedRole = "customer";
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${created.name} created successfully."),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to create user."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Create User"),
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
                  )
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Text(
                      "Create New User",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 25),

                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: "Name",
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) =>
                          value == null || value.isEmpty
                              ? "Enter name"
                              : null,
                    ),

                    const SizedBox(height: 15),

                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        prefixIcon: Icon(Icons.email),
                      ),
                      validator: (value) =>
                          value == null || value.isEmpty
                              ? "Enter email"
                              : null,
                    ),

                    const SizedBox(height: 15),

                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Password",
                        prefixIcon: Icon(Icons.lock),
                      ),
                      validator: (value) =>
                          value == null || value.length < 6
                              ? "Minimum 6 characters"
                              : null,
                    ),

                    const SizedBox(height: 15),

                    TextFormField(
                      controller: _avatarController,
                      decoration: const InputDecoration(
                        labelText: "Avatar URL",
                        prefixIcon: Icon(Icons.image),
                      ),
                    ),

                    const SizedBox(height: 15),

                    DropdownButtonFormField<String>(
                      value: _selectedRole,
                      decoration: const InputDecoration(
                        labelText: "Role",
                        prefixIcon: Icon(Icons.admin_panel_settings),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: "customer",
                          child: Text("Customer"),
                        ),
                        DropdownMenuItem(
                          value: "admin",
                          child: Text("Admin"),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedRole = value!;
                        });
                      },
                    ),

                    const SizedBox(height: 25),

                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: provider.isLoading ? null : _submit,
                        icon: provider.isLoading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.person_add),
                        label: Text(
                          provider.isLoading
                              ? "Creating..."
                              : "Create User",
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