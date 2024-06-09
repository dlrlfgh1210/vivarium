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
    List<CommentModel> comments = await _repository.getComments(postId);
    state = AsyncValue.data(comments);
  }

  Future<void> addComment(CommentModel comment) async {
    await _repository.addComment(comment);
    state.whenData(
        (comments) => state = AsyncValue.data([...comments, comment]));
  }

  Future<void> addReply(String commentId, CommentModel reply) async {
    await _repository.addReply(commentId, reply);
  }

  Future<List<CommentModel>> getReplies(String commentId) async {
    return await _repository.getReplies(commentId);
  }
}

final commentProvider = StateNotifierProvider.family<CommentViewModel,
    AsyncValue<List<CommentModel>>, String>(
  (ref, postId) {
    final repository = ref.read(commentRepoProvider);
    return CommentViewModel(postId, repository);
  },
);

final bottomSheetVisibleProvider = StateProvider<bool>((ref) => true);
