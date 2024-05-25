import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vivarium/authentication/repos/authentication_repo.dart';
import 'package:vivarium/authentication/widgets/firebase_error_snack.dart';
import 'package:vivarium/users/view_models/users_view_model.dart';

class SignUpViewModel extends AsyncNotifier<void> {
  late final AuthenticationRepository _authRepository;
  @override
  FutureOr<void> build() {
    _authRepository = ref.read(authRepository);
  }

  Future<void> signUp(
    String email,
    String password,
    BuildContext context,
  ) async {
    state = const AsyncValue.loading();
    final users = ref.read(usersProvider.notifier);

    state = await AsyncValue.guard(() async {
      final userCredentials = await _authRepository.signUp(email, password);
      await users.createProfile(userCredentials);
    });
    if (state.hasError) {
      showFirebaseErrorSnack(context, state.error);
    } else {
      context.go("/home");
    }
  }
}

final signUpForm = StateProvider((ref) => {});
final signUpProvider = AsyncNotifierProvider<SignUpViewModel, void>(
  () => SignUpViewModel(),
);
