class UserProfileModel {
  final String uid;
  final String email;
  final String name;
  final bool hasAvatar;

  UserProfileModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.hasAvatar,
  });

  UserProfileModel.empty()
      : uid = "",
        email = "",
        name = "",
        hasAvatar = false;

  UserProfileModel.fromJson(Map<String, dynamic> json)
      : uid = json["uid"],
        email = json["email"],
        name = json["name"],
        hasAvatar = json["hasAvatar"] ?? false;

  Map<String, String> toJson() {
    return {
      "uid": uid,
      "email": email,
      "name": name,
    };
  }

  UserProfileModel copyWith({
    String? uid,
    String? email,
    String? name,
    bool? hasAvatar,
  }) {
    return UserProfileModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      hasAvatar: hasAvatar ?? this.hasAvatar,
    );
  }
}
