import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivarium/post/models/comment_model.dart';

class CommentRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addComment(CommentModel comment) async {
    await _db.collection('comments').add(comment.toJson());
  }

  Future<void> addReply(String commentId, CommentModel reply) async {
    await _db.collection('comments').doc(commentId).update({
      'replies': FieldValue.arrayUnion([reply.toJson()])
    });
  }

  Future<List<CommentModel>> getComments(String postId) async {
    final querySnapshot = await _db
        .collection('comments')
        .where('postId', isEqualTo: postId)
        .orderBy('createdAt', descending: true)
        .get();
    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      return CommentModel.fromJson(data).copyWith(id: doc.id);
    }).toList();
  }

  Future<List<CommentModel>> getReplies(String commentId) async {
    final docSnapshot = await _db.collection('comments').doc(commentId).get();
    final data = docSnapshot.data();
    if (data != null && data['replies'] != null) {
      return (data['replies'] as List<dynamic>)
          .map((reply) => CommentModel.fromJson(reply))
          .toList();
    } else {
      return [];
    }
  }

  Future<void> reportComment(String commentId, String userId) async {
    final docRef = _db.collection('comments').doc(commentId);
    await docRef.update({
      'reportedBy': FieldValue.arrayUnion([userId])
    });
  }
}

final commentRepoProvider = Provider((ref) => CommentRepository());
