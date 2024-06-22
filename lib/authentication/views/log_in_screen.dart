import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vivarium/authentication/view_models/log_in_view_model.dart';
import 'package:vivarium/authentication/widgets/auth_container.dart';
import 'package:vivarium/authentication/views/sign_up_screen.dart';
import 'package:vivarium/authentication/widgets/change_color_button.dart';

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
        _formKey.currentState?.save();
        ref.read(logInProvider.notifier).logIn(
              formData["email"]!,
              formData["password"]!,
              context,
            );
      }
    }
  }

  void _onSignUpTap() {
    context.pushNamed(SignUpScreen.routeName);
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
          title: const Text(
            "내방에 자연",
            style: TextStyle(fontSize: 25, color: Colors.black),
          ),
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
                  authHint: '이메일을 입력하세요',
                  onSaved: (newValue) {
                    if (newValue != null) {
                      formData['email'] = newValue;
                    }
                  },
                  validator: (value) {
                    if (value != null && value.isEmpty) {
                      return "다시 입력하세요";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                AuthContainer(
                  secretAuth: true,
                  authHint: '비밀번호를 입력하세요',
                  onSaved: (newValue) {
                    if (newValue != null) {
                      formData['password'] = newValue;
                    }
                  },
                  validator: (value) {
                    if (value != null && value.isEmpty) {
                      return "다시 입력하세요";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: _onSubmitTap,
                  child: ChangeColorButton(
                    disabled: ref.watch(logInProvider).isLoading,
                    buttonName: '다음',
                    buttonSize: 1,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: _onSignUpTap,
                  child: const ChangeColorButton(
                    disabled: false,
                    buttonName: '계정 만들기',
                    buttonSize: 1,
                  ),
                ),
                // if (ref.watch(logInProvider).hasError)
                //   AuthErrorMessage(
                //     error: ref.watch(logInProvider).error,
                //   ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
