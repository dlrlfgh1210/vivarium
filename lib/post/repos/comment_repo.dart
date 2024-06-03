import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivarium/post/models/comment_model.dart';

class CommentRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addComment(CommentModel comment) async {
    await _db.collection('comments').add(comment.toJson());
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
}

final commentRepoProvider = Provider((ref) => CommentRepository());
