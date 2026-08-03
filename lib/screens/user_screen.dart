import 'package:flutter/material.dart';
import 'package:my_app/provider/user_provider.dart';
import 'package:my_app/screens/create_user_screen.dart';
import 'package:provider/provider.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<UserProvider>().getUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserProvider>();

    return Scaffold(
      //appBar: AppBar(title: const Text("Users")),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              itemCount: provider.users.length,
              itemBuilder: (context, index) {
                final user = provider.users[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        // Profile Image
                        Container(
                          width: 68,
                          height: 68,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.grey.shade200,
                              width: 2,
                            ),
                          ),
                          child: ClipOval(
                            child: Image.network(
                              user.avatar,
                              width: 68,
                              height: 68,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey.shade100,
                                  child: const Icon(
                                    Icons.person,
                                    size: 38,
                                    color: Colors.grey,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 26),
                        // User Information
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(
                                    Icons.email_outlined,
                                    size: 16,
                                    color: Colors.grey.shade600,
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      user.email,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              // Role Chip
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: user.role == "admin"
                                      ? Colors.deepPurple.shade50
                                      : Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  user.role.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: user.role == "admin"
                                        ? Colors.deepPurple
                                        : Colors.blue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        //const Icon(Icons.chevron_right, color: Colors.grey),
                      ],
                    ),
                  ),
                );

                // return Card(
                //   margin: const EdgeInsets.symmetric(
                //     horizontal: 12,
                //     vertical: 15,
                //   ),
                //   child: ListTile(
                //     leading: CircleAvatar(
                //       radius: 25,
                //       backgroundColor: Colors.grey.shade200,
                //       child: ClipOval(
                //         child: Image.network(
                //           user.avatar,
                //           width: 50,
                //           height: 50,
                //           fit: BoxFit.cover,
                //           errorBuilder: (context, error, stackTrace) {
                //             return const Icon(Icons.person, size: 40);
                //           },
                //         ),
                //       ),
                //     ),
                //     title: Text(user.name),
                //     subtitle: Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         Text(user.email),
                //         Text("Role: ${user.role}"),
                //         // Text("ID: ${user.id}"),
                //       ],
                //     ),
                //   ),
                // );
              },
            ),

      floatingActionButton: FloatingActionButton.extended(
        heroTag: "create_user",
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateUserScreen()),
          );
          if (mounted) {
            context.read<UserProvider>().getUsers();
          }
        },
        icon: const Icon(Icons.person_add),
        label: const Text("Add User"),
      ),
    );
  }
}
