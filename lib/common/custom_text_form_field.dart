import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final IconData icon;
  final String hintText;
  final bool isPassword;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  const CustomTextFormField({
    super.key,
    required this.icon,
    required this.hintText,
    this.isPassword = false,
    required this.controller,
    this.validator,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool obscureText = false;

  @override
  void initState() {
    super.initState();
    obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: widget.validator,
      controller: widget.controller,
      obscureText: widget.isPassword,

      style: const TextStyle(
        fontSize: 20,
        color: Color(0xFF747987),
        fontWeight: FontWeight.w400,
      ),

      //cursorColor: const Color(0xFF2864E8),
      decoration: InputDecoration(
        hintText: widget.hintText,

        hintStyle: const TextStyle(fontSize: 20, color: Color(0xFF747987)),

        filled: true,
        fillColor: const Color(0xFFF1F4F5),

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),

        // Icon on the RIGHT
        suffixIcon: widget.isPassword
            ? IconButton(
                onPressed: () {
                  setState(() {
                    obscureText = !obscureText;
                  });
                },
                icon: Icon(
                  obscureText
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 23,
                  color: const Color(0xFF747987),
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(right: 18),
                child: Icon(
                  widget.icon,
                  size: 23,
                  color: const Color(0xFF747987),
                ),
              ),

        suffixIconConstraints: const BoxConstraints(
          minWidth: 55,
          minHeight: 55,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE1E5E9), width: 1),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE1E5E9), width: 1),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2864E8), width: 1.5),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
      ),
    );
  }
}
