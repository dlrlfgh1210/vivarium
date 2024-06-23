import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivarium/search/models/nature_model.dart';

class SearchRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<NatureModel>> getAllNatures(String category) async {
    final querySnapshot = await _db
        .collection('natures')
        .doc('mHVKYtLOEtPFkLRXenn2')
        .collection(category)
        .get();
    return querySnapshot.docs
        .map((doc) => NatureModel.fromFirestore(doc))
        .toList();
  }

  Future<List<NatureModel>> searchNatures(String category, String query) async {
    final querySnapshot = await _db
        .collection('natures')
        .doc('mHVKYtLOEtPFkLRXenn2')
        .collection(category)
        .where('title', isGreaterThanOrEqualTo: query)
        .where('title', isLessThanOrEqualTo: '$query\uF7FF')
        .get();
    return querySnapshot.docs
        .map((doc) => NatureModel.fromFirestore(doc))
        .toList();
  }
}

final searchRepo = Provider((ref) => SearchRepository());
