class PostModel {
  final String id;
  final String category;
  final String title;
  final String content;
  final int createdAt;

  PostModel({
    required this.id,
    required this.category,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  PostModel.fromJson(
    Map<String, dynamic> json,
    String postId,
  )   : id = postId,
        category = json['category'],
        title = json['title'],
        content = json['content'],
        createdAt = json['createdAt'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'title': title,
      'content': content,
      'createdAt': createdAt,
    };
  }
}
