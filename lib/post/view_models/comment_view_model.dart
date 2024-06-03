import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivarium/post/models/comment_model.dart';
import 'package:vivarium/post/repos/comment_repo.dart';

class CommentViewModel extends StateNotifier<AsyncValue<List<CommentModel>>> {
  final String postId;
  final CommentRepository _repository;

  CommentViewModel(this.postId, this._repository)
      : super(const AsyncValue.loading()) {
    loadComments();
  }

  Future<void> loadComments() async {
    try {
      List<CommentModel> comments = await _repository.getComments(postId);
      state = AsyncValue.data(comments);
    } catch (e) {}
  }

  Future<void> addComment(CommentModel comment) async {
    try {
      await _repository.addComment(comment);
      state.whenData(
          (comments) => state = AsyncValue.data([...comments, comment]));
    } catch (e) {}
  }
}

final commentProvider = StateNotifierProvider.family<CommentViewModel,
    AsyncValue<List<CommentModel>>, String>(
  (ref, postId) {
    final repository = ref.read(commentRepoProvider);
    return CommentViewModel(postId, repository);
  },
);
