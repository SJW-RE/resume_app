// lib/models/member.dart
class Member {
  final String uid;
  final String level; // 'free' 或 'premium'
  final DateTime? expireAt;

  Member({
    required this.uid,
    required this.level,
    this.expireAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'level': level,
      'expireAt': expireAt?.toIso8601String(),
    };
  }

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      uid: json['uid'] ?? '',
      level: json['level'] ?? 'free',
      expireAt: json['expireAt'] != null
          ? DateTime.parse(json['expireAt'])
          : null,
    );
  }

  // 判断是否为会员
  bool get isPremium => level == 'premium' && (expireAt == null || expireAt!.isAfter(DateTime.now()));
}