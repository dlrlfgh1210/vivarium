import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:riverpod/riverpod.dart';
import 'package:vivarium/post/models/post_model.dart';

class PostRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  UploadTask uploadImageFile(File image, int index, String uid) {
    final fileRef = _storage.ref().child(
        "/images/$uid/${DateTime.now().millisecondsSinceEpoch.toString()}_$index");

    return fileRef.putFile(image);
  }

  Future<void> createPost(PostModel data) async {
    await _db.collection("posts").add(data.toJson());
  }

  Future<void> deletePost(String postId) async {
    await _db.collection("posts").doc(postId).delete();
  }

  Future<void> updatePost(String postId, String newCategory, String newTitle,
      String newContent) async {
    await _db.collection("posts").doc(postId).update({
      "category": newCategory,
      "title": newTitle,
      "content": newContent,
    });
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchPosts() {
    final query =
        _db.collection("posts").orderBy("createdAt", descending: true);
    return query.get();
  }
}

final postRepo = Provider((ref) => PostRepository());
