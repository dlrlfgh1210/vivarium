import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivarium/post/models/post_model.dart';
import 'package:vivarium/post/repos/post_repo.dart';

class PostViewModel extends AsyncNotifier<List<PostModel>> {
  late final PostRepository _postRepository;
  List<PostModel> _list = [];

  Future<List<PostModel>> _fetchPosts() async {
    final posts = await _postRepository.fetchPosts();
    return posts.docs
        .map(
          (doc) => PostModel.fromJson(
            doc.data(),
            doc.id,
          ),
        )
        .toList();
  }

  Future<void> refetch() async {
    final post = await _fetchPosts();
    state = AsyncValue.data(post);
  }

  @override
  FutureOr<List<PostModel>> build() async {
    _postRepository = ref.read(postRepo);
    _list = await _fetchPosts();
    return _list;
  }
}

final postProvider = AsyncNotifierProvider<PostViewModel, List<PostModel>>(
  () => PostViewModel(),
);
