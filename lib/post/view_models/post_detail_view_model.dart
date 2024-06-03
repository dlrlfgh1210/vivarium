import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivarium/post/models/post_detail_model.dart';
import 'package:vivarium/post/repos/post_detail_repo.dart';

class PostDetailViewModel extends StateNotifier<AsyncValue<PostDetailModel>> {
  final String postId;
  late final PostDetailRepository _repository;

  PostDetailViewModel(this.postId, this._repository)
      : super(const AsyncValue.loading()) {
    loadPostDetail();
  }

  Future<void> loadPostDetail() async {
    try {
      final detail = await _repository.getPostDetail(postId);
      state = AsyncValue.data(detail);
    } catch (e) {}
  }
}

final postDetailProvider = StateNotifierProvider.family<PostDetailViewModel,
    AsyncValue<PostDetailModel>, String>(
  (ref, postId) {
    final repository = ref.read(postDetailRepoProvider);
    return PostDetailViewModel(postId, repository);
  },
);
