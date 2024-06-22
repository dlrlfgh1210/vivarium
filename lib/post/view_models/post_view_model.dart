import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivarium/authentication/repos/authentication_repo.dart';
import 'package:vivarium/post/models/post_model.dart';
import 'package:vivarium/post/repos/post_repo.dart';

class PostViewModel extends AsyncNotifier<List<PostModel>> {
  late final PostRepository _postRepository;
  List<PostModel> _list = [];

  Future<List<PostModel>> _fetchPosts() async {
    // final currentUser = ref.read(authRepository).user;
    final posts = await _postRepository.fetchPosts();
    return posts;
  }

  Future<void> refetch() async {
    final post = await _fetchPosts();
    state = AsyncValue.data(post);
  }

  @override
  FutureOr<List<PostModel>> build() async {
    _postRepository = ref.read(postRepo);
    final currentUser = ref.read(authRepository).user;
    _list = await _postRepository.getFilteredPosts(currentUser!.uid);
    return _list;
  }

  Future<void> searchPosts(String query) async {
    final result = await _postRepository.searchPosts(query);
    _list = result;
    state = AsyncValue.data(_list);
  }

  Future<void> reportPost(String postId) async {
    final currentUser = ref.read(authRepository).user;
    if (currentUser != null) {
      await _postRepository.reportPost(postId, currentUser.uid);
      refetch();
    }
  }
}

final postProvider = AsyncNotifierProvider<PostViewModel, List<PostModel>>(
  () => PostViewModel(),
);
