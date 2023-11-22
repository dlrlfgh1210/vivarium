class PostModel {
  final String id;
  final String category;
  final String title;
  final String content;
  final int createdAt;
  final List<String>? photoList;

  PostModel({
    required this.id,
    required this.category,
    required this.title,
    required this.content,
    required this.createdAt,
    this.photoList,
  });

  PostModel.fromJson(
    Map<String, dynamic> json,
    String postId,
  )   : id = postId,
        category = json['category'],
        title = json['title'],
        content = json['content'],
        photoList = json['photoList'] != null
            ? List<String>.from(json['photoList'])
            : null,
        createdAt = json['createdAt'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'title': title,
      'content': content,
      'photoList': photoList,
      'createdAt': createdAt,
    };
  }
}
