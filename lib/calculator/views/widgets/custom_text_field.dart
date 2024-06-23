import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: InputBorder.none,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        labelText: labelText,
        labelStyle: const TextStyle(fontSize: 15),
      ),
      keyboardType: TextInputType.number,
    );
  }
}
