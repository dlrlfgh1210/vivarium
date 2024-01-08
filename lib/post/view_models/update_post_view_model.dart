import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    List<File>? newPhoto,
  ) async {
    List<String> photoUrls = [];

    if (newPhoto != null && newPhoto.isNotEmpty) {
      try {
        final uploadTasks = await Future.wait(
          [
            for (int i = 0; i < newPhoto.length; i++)
              _postRepository.uploadImageFile(newPhoto[i], i, postId)
          ],
        );
        for (var task in uploadTasks) {
          final url = await task.ref.getDownloadURL();
          photoUrls.add(url);
        }
      } catch (e) {
        print('Error uploading images: $e');
        // 업로드 실패 시 예외 처리
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
