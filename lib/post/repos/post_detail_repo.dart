import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivarium/post/models/post_detail_model.dart';

class PostDetailRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<PostDetailModel> getPostDetail(String postId) async {
    final doc = await _db.collection('posts').doc(postId).get();
    final data = doc.data()!;
    return PostDetailModel.fromJson(data).copyWith(id: doc.id);
  }
}

final postDetailRepoProvider = Provider((ref) => PostDetailRepository());
