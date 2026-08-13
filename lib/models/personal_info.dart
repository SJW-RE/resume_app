import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';
import 'dart:typed_data';
import 'dart:convert';

part 'personal_info.g.dart';

@HiveType(typeId: 5)
@JsonSerializable()
class PersonalInfo {
  @HiveField(0)
  String fullName;

  @HiveField(1)
  String phone;

  @HiveField(2)
  String email;

  @HiveField(3)
  String jobTitle;

  @HiveField(4)
  String expectedCity;

  @HiveField(5)
  String salaryExpectation;

  @HiveField(6)
  String availableDate;

  // ---- 新增字段 ----
  @HiveField(9)
  String? birthDate; // 出生年月

  @HiveField(10)
  String? birthPlace; // 籍贯

  @HiveField(11)
  String? politicalStatus; // 政治面貌

  @HiveField(12)
  String? gender; // 性别

  @HiveField(13)
  String? nation; // 民族

  @HiveField(7)
  @JsonKey(fromJson: _avatarImageFromJson, toJson: _avatarImageToJson)
  Uint8List? avatarImage;

  PersonalInfo({
    required this.fullName,
    required this.phone,
    required this.email,
    required this.jobTitle,
    this.expectedCity = '', // 改为可选 + 默认空
    this.salaryExpectation = '', // 同上
    this.availableDate = '', // 同上
    this.birthDate,
    this.birthPlace,
    this.politicalStatus,
    this.gender,
    this.nation,
    this.avatarImage,
  });

  factory PersonalInfo.fromJson(Map<String, dynamic> json) =>
      _$PersonalInfoFromJson(json);
  Map<String, dynamic> toJson() => _$PersonalInfoToJson(this);

  static Uint8List? _avatarImageFromJson(String? base64String) {
    if (base64String == null || base64String.isEmpty) return null;
    return base64Decode(base64String);
  }

  static String? _avatarImageToJson(Uint8List? image) {
    if (image == null || image.isEmpty) return null;
    return base64Encode(image);
  }

  PersonalInfo copyWith({
    String? fullName,
    String? phone,
    String? email,
    String? jobTitle,
    String? expectedCity,
    String? salaryExpectation,
    String? availableDate,
    String? birthDate,
    String? birthPlace,
    String? politicalStatus,
    String? gender,
    String? nation,
    Uint8List? avatarImage,
  }) {
    return PersonalInfo(
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      jobTitle: jobTitle ?? this.jobTitle,
      expectedCity: expectedCity ?? this.expectedCity,
      salaryExpectation: salaryExpectation ?? this.salaryExpectation,
      availableDate: availableDate ?? this.availableDate,
      birthDate: birthDate ?? this.birthDate,
      birthPlace: birthPlace ?? this.birthPlace,
      politicalStatus: politicalStatus ?? this.politicalStatus,
      gender: gender ?? this.gender,
      nation: nation ?? this.nation,
      avatarImage: avatarImage ?? this.avatarImage,
    );
  }
}
