import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vivarium/authentication/view_models/sign_up_view_model.dart';
import 'package:vivarium/authentication/widgets/auth_container.dart';
import 'package:vivarium/authentication/views/log_in_screen.dart';
import 'package:vivarium/authentication/widgets/change_color_button.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  static const routeName = "SignUp";
  static const routeURL = "/SignUp";
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Map<String, String> formData = {};

  void _onCreateTap() async {
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState?.save();

        ref
            .read(signUpProvider.notifier)
            .signUp(formData["email"]!, formData["password"]!, context);
      }
    }
  }

  void _onLogInTap() {
    context.goNamed(LogInScreen.routeName);
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
          title: const Text("내방에 자연"),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 36,
            vertical: 40,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                const Text(
                  "회원가입",
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
                  onTap: _onCreateTap,
                  child: ChangeColorButton(
                    disabled: ref.watch(signUpProvider).isLoading,
                    buttonName: '계정 만들기',
                    buttonSize: 1,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: _onLogInTap,
                  child: const ChangeColorButton(
                    disabled: false,
                    buttonName: '로그인',
                    buttonSize: 1,
                  ),
                ),
                // if (ref.watch(signUpProvider).hasError)
                //   AuthErrorMessage(
                //     error: ref.watch(signUpProvider).error,
                //   ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
