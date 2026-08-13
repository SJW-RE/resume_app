import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';

part 'work_experience.g.dart';

@HiveType(typeId: 1)
@JsonSerializable()
class WorkExperience {
  @HiveField(0)
  String company;

  @HiveField(1)
  String position;

  @HiveField(2)
  DateTime startDate;

  @HiveField(3)
  DateTime? endDate; // null 表示至今

  @HiveField(4)
  String description;

  @HiveField(5)
  List<String> achievements;

  WorkExperience({
    required this.company,
    required this.position,
    required this.startDate,
    this.endDate,
    required this.description,
    required this.achievements,
  });

  factory WorkExperience.fromJson(Map<String, dynamic> json) =>
      _$WorkExperienceFromJson(json);
  Map<String, dynamic> toJson() => _$WorkExperienceToJson(this);
}
