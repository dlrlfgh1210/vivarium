import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivarium/authentication/repos/authentication_repo.dart';
import 'package:vivarium/post/models/comment_model.dart';
import 'package:vivarium/post/repos/comment_repo.dart';

class CommentViewModel extends StateNotifier<AsyncValue<List<CommentModel>>> {
  final String postId;
  final CommentRepository _repository;
  final Ref ref;

  CommentViewModel(this.postId, this._repository, this.ref)
      : super(const AsyncValue.loading()) {
    loadComments();
  }

  Future<void> loadComments() async {
    final currentUser = ref.read(authRepository).user;
    final comments = await _repository.getComments(postId);
    if (currentUser != null) {
      state = AsyncValue.data(comments
          .map((comment) {
            final filteredReplies = comment.replies
                .where((reply) => !reply.reportedBy.contains(currentUser.uid))
                .toList();
            return comment.copyWith(replies: filteredReplies);
          })
          .where((comment) => !comment.reportedBy.contains(currentUser.uid))
          .toList());
    } else {
      state = AsyncValue.data(comments);
    }
  }

  Future<void> reportComment(String commentId) async {
    final currentUser = ref.read(authRepository).user;
    if (currentUser == null) return;

    await _repository.reportComment(commentId, currentUser.uid);
    loadComments();
  }

  Future<void> reportReply(String commentId, int replyCreatedAt) async {
    final currentUser = ref.read(authRepository).user;
    if (currentUser == null) return;

    await _repository.reportReply(commentId, replyCreatedAt, currentUser.uid);
    loadComments();
  }

  Future<void> addComment(CommentModel comment) async {
    await _repository.addComment(comment);
    state.whenData(
        (comments) => state = AsyncValue.data([...comments, comment]));
  }

  Future<void> addReply(String commentId, CommentModel reply) async {
    await _repository.addReply(commentId, reply);
    loadComments();
  }

  Future<List<CommentModel>> getReplies(String commentId) async {
    return await _repository.getReplies(commentId);
  }
}

final commentProvider = StateNotifierProvider.family<CommentViewModel,
    AsyncValue<List<CommentModel>>, String>(
  (ref, postId) {
    final repository = ref.read(commentRepoProvider);
    return CommentViewModel(postId, repository, ref);
  },
);

final bottomSheetVisibleProvider = StateProvider<bool>((ref) => true);
