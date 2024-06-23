import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vivarium/search/models/nature_model.dart';

final natureProvider =
    StateNotifierProvider<NatureNotifier, List<NatureModel>>((ref) {
  return NatureNotifier();
});

class NatureNotifier extends StateNotifier<List<NatureModel>> {
  NatureNotifier() : super([]);

  Future<void> fetchNatures(String category) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('natures')
          .doc('mHVKYtLOEtPFkLRXenn2')
          .collection(category)
          .where('category', isEqualTo: category)
          .get();
      state =
          snapshot.docs.map((doc) => NatureModel.fromFirestore(doc)).toList();
    } catch (e) {
      state = [];
    }
  }
}
