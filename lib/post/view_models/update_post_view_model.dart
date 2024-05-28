import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivarium/authentication/repos/authentication_repo.dart';
import 'package:vivarium/post/repos/post_repo.dart';
import 'package:vivarium/post/view_models/post_view_model.dart';

class UpdatePostViewModel extends AsyncNotifier<void> {
  late final FirebaseFirestore _db = FirebaseFirestore.instance;
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
    List<String> newPhotoPaths,
  ) async {
    final user = ref.read(authRepository).user;
    if (user == null) return;

    // 포스트를 가져와서 작성자를 확인합니다.
    final post = await _postRepository.getPost(postId);
    if (post.creatorUid != user.uid) {
      throw Exception("You are not authorized to update this post.");
    }

    List<String> photoUrls = [];
    for (var photoPath in newPhotoPaths) {
      if (photoPath.startsWith('http')) {
        // 기존 사진의 URL
        photoUrls.add(photoPath);
      } else {
        // 새로 추가된 사진 파일
        final file = File(photoPath);
        if (file.existsSync()) {
          final task = await _postRepository.uploadImageFile(file, user.uid);
          final url = await task.ref.getDownloadURL();
          photoUrls.add(url);
        }
      }
    }

    // Firestore에 업로드된 이미지의 URL을 포함하여 업데이트
    await _db.collection("posts").doc(postId).update({
      "category": newCategory,
      "title": newTitle,
      "content": newContent,
      "photoList": photoUrls, // 이미지의 URL 리스트
    });

    // 업데이트 이후에 postProvider를 리프레시
    await ref.read(postProvider.notifier).refetch();
  }
}

final updatePostProvider = AsyncNotifierProvider<UpdatePostViewModel, void>(
  () => UpdatePostViewModel(),
);
