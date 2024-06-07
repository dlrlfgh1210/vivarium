class CommentModel {
  final String id;
  final String postId;
  final String content;
  final String creatorUid;
  final String creatorEmail;
  final String creatorAvatarUrl;
  final int createdAt;

  CommentModel({
    required this.id,
    required this.postId,
    required this.content,
    required this.creatorUid,
    required this.creatorEmail,
    required this.creatorAvatarUrl,
    required this.createdAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] as String,
      postId: json['postId'] as String,
      content: json['content'] as String,
      creatorUid: json['creatorUid'] as String,
      creatorEmail: json['creatorEmail'] as String? ?? '',
      creatorAvatarUrl: json['creatorAvatarUrl'] as String? ?? '',
      createdAt: json['createdAt'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postId': postId,
      'content': content,
      'creatorUid': creatorUid,
      'creatorEmail': creatorEmail,
      'creatorAvatarUrl': creatorAvatarUrl,
      'createdAt': createdAt,
    };
  }

  CommentModel copyWith({
    String? id,
    String? postId,
    String? content,
    String? creatorUid,
    String? creatorEmail,
    String? creatorAvatarUrl,
    int? createdAt,
  }) {
    return CommentModel(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      content: content ?? this.content,
      creatorUid: creatorUid ?? this.creatorUid,
      creatorEmail: creatorEmail ?? this.creatorEmail,
      creatorAvatarUrl: creatorAvatarUrl ?? this.creatorAvatarUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
