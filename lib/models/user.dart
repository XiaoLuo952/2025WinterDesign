class User {
  final int userId;
  final String phone;
  final String? nickname;
  final String? avatar;
  final String? bio;
  final String? gender;
  final String? birthday;
  final String? location;
  final int followersCount;
  final int followingCount;
  final int likesCount;

  User({
    required this.userId,
    required this.phone,
    this.nickname,
    this.avatar,
    this.bio,
    this.gender,
    this.birthday,
    this.location,
    this.followersCount = 0,
    this.followingCount = 0,
    this.likesCount = 0,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'] as int,
      phone: json['phone'] ?? '',
      nickname: json['nickname'] as String?,
      avatar: json['avatar'] as String?,
      bio: json['bio'] as String?,
      gender: json['gender'] as String?,
      birthday: json['birthday'] as String?,
      location: json['location'] as String?,
      followersCount: json['followersCount'] as int? ?? 0,
      followingCount: json['followingCount'] as int? ?? 0,
      likesCount: json['likesCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'phone': phone,
      'nickname': nickname,
      'avatar': avatar,
      'bio': bio,
      'gender': gender,
      'birthday': birthday,
      'location': location,
      'followersCount': followersCount,
      'followingCount': followingCount,
      'likesCount': likesCount,
    };
  }
} 