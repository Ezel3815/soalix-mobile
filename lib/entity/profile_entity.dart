class ProfileEntity {
  final int id;
  final String name;
  final String email;
  final String? username;
  final String? avatarHair;
  final String? avatarHairColor;
  final String? avatarSkinColor;
  final String? avatarClothingColor;
  final bool avatarGlasses;
  final int currentStreak;
  final int followersCount;
  final int followingCount;
  final bool isFollowing;
  final bool isFriend;
  final DateTime? createdAt;

  ProfileEntity({
    required this.id,
    required this.name,
    required this.email,
    this.username,
    this.avatarHair,
    this.avatarHairColor,
    this.avatarSkinColor,
    this.avatarClothingColor,
    required this.avatarGlasses,
    required this.currentStreak,
    required this.followersCount,
    required this.followingCount,
    required this.isFollowing,
    required this.isFriend,
    this.createdAt,
  });

  factory ProfileEntity.fromJson(Map<String, dynamic> json) {
    return ProfileEntity(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      username: json['username'],
      avatarHair: json['avatar_hair'],
      avatarHairColor: json['avatar_hair_color'],
      avatarSkinColor: json['avatar_skin_color'],
      avatarClothingColor: json['avatar_clothing_color'],
      avatarGlasses: json['avatar_glasses'] ?? false,
      currentStreak: json['current_streak'] ?? 0,
      followersCount: json['followersCount'] ?? 0,
      followingCount: json['followingCount'] ?? 0,
      isFollowing: json['isFollowing'] ?? false,
      isFriend: json['isFriend'] ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
    );
  }

  /// Returns the profile photo URL if one has been uploaded (stored in
  /// avatar_hair, reusing the existing media upload system), otherwise null.
  String? get avatarPhotoName => avatarHair;
}
