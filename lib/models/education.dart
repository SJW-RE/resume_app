import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';

part 'education.g.dart';

@HiveType(typeId: 2)
@JsonSerializable()
class Education {
  @HiveField(0)
  String school;

  @HiveField(1)
  String degree;

  @HiveField(2)
  DateTime startDate;

  @HiveField(3)
  DateTime? endDate; // null 表示至今

  @HiveField(4)
  String description;

   @HiveField(5)  // ← 新增
  String major;  // ← 新增：专业

  Education({
    required this.school,
    required this.degree,
    required this.startDate,
    this.endDate,
    required this.description,
    this.major = '',  // ← 新增，默认空字符串
  });

  factory Education.fromJson(Map<String, dynamic> json) =>
      _$EducationFromJson(json);
  Map<String, dynamic> toJson() => _$EducationToJson(this);
}
