import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button({super.key, this.onTap, required this.text});

  final void Function()? onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.shade400,
          ),
          borderRadius: BorderRadius.circular(
            10,
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
