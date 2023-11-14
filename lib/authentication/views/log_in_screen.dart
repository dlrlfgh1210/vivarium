import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vivarium/authentication/view_models/log_in_view_model.dart';
import 'package:vivarium/authentication/views/auth_container.dart';
import 'package:vivarium/authentication/views/sign_up_screen.dart';
import 'package:vivarium/change_color_button.dart';

class LogInScreen extends ConsumerStatefulWidget {
  static const routeName = "LogIn";
  static const routeURL = "/LogIn";
  const LogInScreen({super.key});

  @override
  ConsumerState<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends ConsumerState<LogInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Map<String, String> formData = {};

  void _onSubmitTap() {
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        ref.read(logInProvider.notifier).logIn(
              formData["email"]!,
              formData["password"]!,
              context,
            );
      }
    }
  }

  void _onSignUpTap() {
    context.goNamed(SignUpScreen.routeName);
  }

  void _onScaffoldTap() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onScaffoldTap,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          title: const Text("🌿Soocho🌿"),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 36,
            vertical: 30,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                const Text(
                  "Welcome!",
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                AuthContainer(
                  secretAuth: false,
                  authHint: 'Email',
                  saveValue: (newValue) {
                    if (newValue != null) {
                      formData['email'] = newValue;
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                AuthContainer(
                  secretAuth: true,
                  authHint: 'Password',
                  saveValue: (newValue) {
                    if (newValue != null) {
                      formData['password'] = newValue;
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: _onSubmitTap,
                  child: ChangeColorButton(
                    disabled: ref.watch(logInProvider).isLoading,
                    buttonName: 'Enter',
                    buttonSize: 1,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: _onSignUpTap,
                  child: const ChangeColorButton(
                    disabled: false,
                    buttonName: 'Create an account',
                    buttonSize: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
