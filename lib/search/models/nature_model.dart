import 'package:cloud_firestore/cloud_firestore.dart';

class Nature {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String category;

  Nature({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.category,
  });

  factory Nature.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Nature(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      category: data['category'] ?? '',
    );
  }
}
