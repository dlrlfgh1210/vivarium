import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:riverpod/riverpod.dart';
import 'package:vivarium/post/models/post_model.dart';

class PostRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  UploadTask uploadImageFile(File image, String uid) {
    final fileRef = _storage.ref().child(
          '/images/$uid/${DateTime.now().millisecondsSinceEpoch.toString()}',
        );
    return fileRef.putFile(image, SettableMetadata(contentType: "image/jpeg"));
  }

  Future<void> createPost(PostModel data) async {
    await _db.collection("posts").add(data.toJson());
  }

  Future<List<PostModel>> fetchPosts({int? lastItemCreatedAt}) async {
    final query =
        _db.collection("posts").orderBy("createdAt", descending: true);
    final querySnapshot = lastItemCreatedAt == null
        ? await query.get()
        : await query.startAfter([lastItemCreatedAt]).get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      return PostModel.fromJson(data).copyWith(id: doc.id);
    }).toList();
  }

  Future<void> deletePost(String postId) async {
    assert(postId.isNotEmpty, 'postId must be a non-empty string');
    await _db.collection("posts").doc(postId).delete();
  }

  Future<void> updatePost(
    String postId,
    String newCategory,
    String newTitle,
    String newContent,
    List<File>? newPhoto,
  ) async {
    List<String> photoUrls = [];
    if (newPhoto != null) {
      for (var photo in newPhoto) {
        final task = await uploadImageFile(photo, postId);
        photoUrls.add(await task.ref.getDownloadURL());
      }
    }

    await _db.collection("posts").doc(postId).update({
      "category": newCategory,
      "title": newTitle,
      "content": newContent,
      "photoList": photoUrls,
    });
  }

  Future<PostModel> getPost(String postId) async {
    assert(postId.isNotEmpty, 'postId must be a non-empty string');
    final doc = await _db.collection("posts").doc(postId).get();
    return PostModel.fromJson(doc.data()!).copyWith(id: doc.id);
  }

  Future<List<PostModel>> searchPosts(String query) async {
    final categoryQuery = _db
        .collection("posts")
        .where('category', isGreaterThanOrEqualTo: query)
        .where('category', isLessThanOrEqualTo: '$query\uF7FF')
        .get();

    final titleQuery = _db
        .collection("posts")
        .where('title', isGreaterThanOrEqualTo: query)
        .where('title', isLessThanOrEqualTo: '$query\uF7FF')
        .get();

    final contentQuery = _db
        .collection("posts")
        .where('content', isGreaterThanOrEqualTo: query)
        .where('content', isLessThanOrEqualTo: '$query\uF7FF')
        .get();

    final results =
        await Future.wait([categoryQuery, titleQuery, contentQuery]);
    final allDocs =
        results.expand((querySnapshot) => querySnapshot.docs).toList();
    final uniqueDocs = {for (var doc in allDocs) doc.id: doc}.values.toList();

    return uniqueDocs.map((doc) {
      final data = doc.data();
      return PostModel.fromJson(data).copyWith(id: doc.id);
    }).toList();
  }
}

final postRepo = Provider((ref) => PostRepository());
