class CommentModel {
  final String id;
  final String postId;
  final String content;
  final String creatorUid;
  final String creatorEmail;
  final String creatorAvatarUrl;
  final int createdAt;
  final List<CommentModel> replies;
  final List<String> reportedBy; // 신고한 사용자 ID 목록 추가

  CommentModel({
    required this.id,
    required this.postId,
    required this.content,
    required this.creatorUid,
    required this.creatorEmail,
    required this.creatorAvatarUrl,
    required this.createdAt,
    this.replies = const [],
    this.reportedBy = const [],
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
      replies: (json['replies'] as List<dynamic>?)
              ?.map((reply) =>
                  CommentModel.fromJson(reply as Map<String, dynamic>))
              .toList() ??
          [],
      reportedBy: List<String>.from(json['reportedBy'] ?? []),
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
      'replies': replies.map((reply) => reply.toJson()).toList(),
      'reportedBy': reportedBy,
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
    List<CommentModel>? replies,
    List<String>? reportedBy,
  }) {
    return CommentModel(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      content: content ?? this.content,
      creatorUid: creatorUid ?? this.creatorUid,
      creatorEmail: creatorEmail ?? this.creatorEmail,
      creatorAvatarUrl: creatorAvatarUrl ?? this.creatorAvatarUrl,
      createdAt: createdAt ?? this.createdAt,
      replies: replies ?? this.replies,
      reportedBy: reportedBy ?? this.reportedBy,
    );
  }
}
