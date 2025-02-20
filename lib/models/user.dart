class User {
  final int id;
  final String phone;
  final String? nickname;
  final String? avatar;

  User({
    required this.id,
    required this.phone,
    this.nickname,
    this.avatar,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      phone: json['phone'] as String,
      nickname: json['nickname'] as String?,
      avatar: json['avatar'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
      'nickname': nickname,
      'avatar': avatar,
    };
  }
} 