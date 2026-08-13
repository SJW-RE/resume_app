import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';

part 'skill.g.dart';

@HiveType(typeId: 3)
@JsonSerializable()
class Skill {
  @HiveField(0)
  String name;

  @HiveField(1)
  int proficiency; // 1-5 等级

  Skill({required this.name, this.proficiency = 3});

  factory Skill.fromJson(Map<String, dynamic> json) => _$SkillFromJson(json);
  Map<String, dynamic> toJson() => _$SkillToJson(this);
}
