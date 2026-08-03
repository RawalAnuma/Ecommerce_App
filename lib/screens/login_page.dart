import 'package:flutter/material.dart';
import 'package:my_app/common/custom_text_form_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 55),
              Text(
                "Welcome back",
                style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 15),

              Text(
                "Sign in to continue your curated shopping experience.",
                style: TextStyle(
                  color: const Color.fromARGB(255, 83, 83, 83),
                  fontSize: 18,
                ),
              ),

              SizedBox(height: 40),

              Text(
                "Email Address",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),

              CustomTextFormField(
                icon: Icons.email,
                hintText: "Enter email",
                controller: emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Email is required";
                  }
                  if (!value.contains("@")) {
                    return "Enter a valid email with @";
                  }
                  return null;
                },
              ),

              SizedBox(height: 22),

              Text(
                "Password",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),

              CustomTextFormField(
                icon: Icons.lock,
                hintText: "Enter password",
                controller: passwordController,
                isPassword: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Password is required";
                  }
                  if (value.length < 6) {
                    return "Password must be of 6 characters";
                  }
                  return null;
                },
              ),

              SizedBox(height: 35),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 43, 106, 223),
                    foregroundColor: Colors.white,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      print("Login Successful!");
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 14),

                      Icon(Icons.arrow_forward, size: 24),
                    ],
                  ),
                ),
              ),

              // SizedBox(height: 15),

              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Text(
              //       "Don't have an account?",
              //       style: TextStyle(
              //         color: const Color.fromARGB(255, 121, 120, 120),
              //       ),
              //     ),
              //     TextButton(
              //       onPressed: () {},
              //       child: Text("Create a new account"),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
