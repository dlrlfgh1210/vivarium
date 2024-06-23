import 'package:cloud_firestore/cloud_firestore.dart';

class NatureModel {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String category;

  NatureModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.category,
  });

  factory NatureModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return NatureModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      category: data['category'] ?? '',
    );
  }
}
