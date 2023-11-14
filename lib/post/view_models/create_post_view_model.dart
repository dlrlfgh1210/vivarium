import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivarium/authentication/repos/authentication_repo.dart';
import 'package:vivarium/post/models/post_model.dart';
import 'package:vivarium/post/repos/post_repo.dart';
import 'package:vivarium/post/view_models/post_view_model.dart';

class CreatePostViewModel extends AsyncNotifier<void> {
  late final AuthenticationRepository _authenticationRepository;
  late final PostRepository _postRepository;

  @override
  FutureOr<void> build() {
    _authenticationRepository = ref.read(authRepo);
    _postRepository = ref.read(postRepo);
  }

  Future<void> createSoocho(
    String category,
    String title,
    String content,
    BuildContext context,
  ) async {
    final uid = _authenticationRepository.user!.uid;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () async {
        await _postRepository.createPost(
          PostModel(
            id: '',
            category: category,
            title: title,
            content: content,
            createdAt: DateTime.now().millisecondsSinceEpoch,
          ),
        );
        await ref.read(postProvider.notifier).refetch();
      },
    );
  }
}

final createPostProvider = AsyncNotifierProvider<CreatePostViewModel, void>(
  () => CreatePostViewModel(),
);
