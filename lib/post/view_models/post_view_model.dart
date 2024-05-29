import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivarium/post/models/post_model.dart';
import 'package:vivarium/post/repos/post_repo.dart';

class PostViewModel extends AsyncNotifier<List<PostModel>> {
  late final PostRepository _postRepository;
  List<PostModel> _list = [];
  int? lastItemCreatedAt;

  Future<List<PostModel>> _fetchPosts({int? lastItemCreatedAt}) async {
    final posts = await _postRepository.fetchPosts(
      lastItemCreatedAt: lastItemCreatedAt ?? this.lastItemCreatedAt,
    );
    return posts;
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

  Future<void> searchPosts(String query) async {
    final result = await _postRepository.searchPosts(query);
    _list = result;
    state = AsyncValue.data(_list);
  }
}

final postProvider = AsyncNotifierProvider<PostViewModel, List<PostModel>>(
  () => PostViewModel(),
);
