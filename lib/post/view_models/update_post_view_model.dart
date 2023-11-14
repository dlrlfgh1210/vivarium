import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivarium/post/repos/post_repo.dart';
import 'package:vivarium/post/view_models/post_view_model.dart';

class UpdatePostViewModel extends AsyncNotifier<void> {
  late final PostRepository _postRepository;

  @override
  FutureOr<void> build() {
    _postRepository = ref.read(postRepo);
  }

  Future<void> updatePost(
    String postId,
    String newCategory,
    String newTitle,
    String newContent,
  ) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () async {
        await _postRepository.updatePost(
          postId,
          newCategory,
          newTitle,
          newContent,
        );
        await ref.read(postProvider.notifier).refetch();
      },
    );
  }
}

final updatePostProvider = AsyncNotifierProvider<UpdatePostViewModel, void>(
  () => UpdatePostViewModel(),
);
