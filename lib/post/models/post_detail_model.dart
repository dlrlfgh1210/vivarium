class PostDetailModel {
  final String id;
  final String category;
  final String title;
  final String content;
  final List<String> photoList;
  final String creatorUid;
  final int createdAt;

  PostDetailModel({
    required this.id,
    required this.category,
    required this.title,
    required this.content,
    required this.photoList,
    required this.creatorUid,
    required this.createdAt,
  });

  factory PostDetailModel.fromJson(Map<String, dynamic> json) {
    return PostDetailModel(
      id: json['id'] as String,
      category: json['category'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      photoList: List<String>.from(json['photoList'] as List),
      creatorUid: json['creatorUid'] as String,
      createdAt: json['createdAt'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'title': title,
      'content': content,
      'photoList': photoList,
      'creatorUid': creatorUid,
      'createdAt': createdAt,
    };
  }

  PostDetailModel copyWith({
    String? id,
    String? category,
    String? title,
    String? content,
    List<String>? photoList,
    String? creatorUid,
    int? createdAt,
  }) {
    return PostDetailModel(
      id: id ?? this.id,
      category: category ?? this.category,
      title: title ?? this.title,
      content: content ?? this.content,
      photoList: photoList ?? this.photoList,
      creatorUid: creatorUid ?? this.creatorUid,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
