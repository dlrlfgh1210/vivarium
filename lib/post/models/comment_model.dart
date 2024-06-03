class CommentModel {
  final String id;
  final String postId;
  final String content;
  final String creatorUid;
  final int createdAt;

  CommentModel({
    required this.id,
    required this.postId,
    required this.content,
    required this.creatorUid,
    required this.createdAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] as String,
      postId: json['postId'] as String,
      content: json['content'] as String,
      creatorUid: json['creatorUid'] as String,
      createdAt: json['createdAt'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postId': postId,
      'content': content,
      'creatorUid': creatorUid,
      'createdAt': createdAt,
    };
  }

  CommentModel copyWith({
    String? id,
    String? postId,
    String? content,
    String? creatorUid,
    int? createdAt,
  }) {
    return CommentModel(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      content: content ?? this.content,
      creatorUid: creatorUid ?? this.creatorUid,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
