import 'package:flutter/material.dart';

class AuthContainer extends StatelessWidget {
  final String authHint;
  final dynamic onSaved;
  final dynamic secretAuth;
  final dynamic validator;
  const AuthContainer({
    super.key,
    required this.authHint,
    this.onSaved,
    this.secretAuth,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10),
      width: 300,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        border: Border.all(
          color: Colors.black,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextFormField(
        obscureText: secretAuth,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintText: authHint,
          border: InputBorder.none,
        ),
        onSaved: onSaved,
        validator: validator,
      ),
    );
  }
}
