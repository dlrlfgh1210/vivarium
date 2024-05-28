import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivarium/authentication/repos/authentication_repo.dart';
import 'package:vivarium/post/models/post_model.dart';
import 'package:vivarium/post/repos/post_repo.dart';
import 'package:vivarium/post/view_models/post_view_model.dart';
import 'package:vivarium/users/view_models/users_view_model.dart';

class CreatePostViewModel extends AsyncNotifier<void> {
  late final PostRepository _postRepository;

  @override
  FutureOr<void> build() {
    _postRepository = ref.read(postRepo);
  }

  Future<void> createSoocho(
    String category,
    String title,
    String content,
    List<File> photos,
    BuildContext context,
  ) async {
    final user = ref.read(authRepository).user;
    final userProfile = ref.read(usersProvider).value;
    if (user == null || userProfile == null) return;
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(
      () async {
        List<String> photoUrls = [];
        for (var photo in photos) {
          final task = await _postRepository.uploadImageFile(photo, user.uid);
          photoUrls.add(await task.ref.getDownloadURL());
        }

        await _postRepository.createPost(
          PostModel(
            id: '',
            category: category,
            title: title,
            content: content,
            photoList: photoUrls,
            creator: userProfile.name,
            creatorUid: user.uid,
            createdAt: DateTime.now().microsecondsSinceEpoch,
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
