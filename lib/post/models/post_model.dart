class PostModel {
  final String id;
  final String category;
  final String title;
  final String content;
  final String creatorUid;
  final String creator;
  final int createdAt;
  final List<String> photoList;

  const PostModel({
    required this.id,
    required this.category,
    required this.title,
    required this.content,
    required this.creatorUid,
    required this.creator,
    required this.createdAt,
    required this.photoList,
  });

  PostModel.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? '',
        category = json['category'],
        title = json['title'],
        content = json['content'],
        photoList = List<String>.from(json["photoList"]),
        creatorUid = json["creatorUid"],
        creator = json["creator"],
        createdAt = json['createdAt'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'title': title,
      'content': content,
      'photoList': photoList,
      "creatorUid": creatorUid,
      "creator": creator,
      'createdAt': createdAt,
    };
  }

  PostModel copyWith({
    String? id,
    String? category,
    String? title,
    String? content,
    String? creatorUid,
    String? creator,
    int? createdAt,
    List<String>? photoList,
  }) {
    return PostModel(
      id: id ?? this.id,
      category: category ?? this.category,
      title: title ?? this.title,
      content: content ?? this.content,
      creatorUid: creatorUid ?? this.creatorUid,
      creator: creator ?? this.creator,
      createdAt: createdAt ?? this.createdAt,
      photoList: photoList ?? this.photoList,
    );
  }
}
