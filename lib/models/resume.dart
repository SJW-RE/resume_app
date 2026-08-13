import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';
import 'personal_info.dart'; // ← 导入 PersonalInfo
// import 其他模型类（WorkExperience、Education、Skill、Project）
import 'work_experience.dart';
import 'education.dart';
import 'skill.dart';
import 'project.dart';

part 'resume.g.dart';

@HiveType(typeId: 6) // typeId 不能与其他类重复（PersonalInfo 是 5）
@JsonSerializable(explicitToJson: true)
class Resume {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  DateTime updatedAt;

  @HiveField(3)
  PersonalInfo personal; // ← 直接使用导入的 PersonalInfo

  @HiveField(4)
  List<WorkExperience> workExperiences;

  @HiveField(5)
  List<Education> educations;

  @HiveField(6)
  List<Skill> skills;

  @HiveField(7)
  List<Project> projects;

  @HiveField(8)
  List<String> honors;

  @HiveField(9)
  List<String> languages;

  @HiveField(10)
  String summary;

  Resume({
    required this.id,
    required this.name,
    required this.updatedAt,
    required this.personal,
    required this.workExperiences,
    required this.educations,
    required this.skills,
    required this.projects,
    required this.summary,
    this.honors = const [],
    this.languages = const [],
  });

  factory Resume.fromJson(Map<String, dynamic> json) => _$ResumeFromJson(json);
  Map<String, dynamic> toJson() => _$ResumeToJson(this);

  Resume copyWith({
    String? id,
    String? name,
    DateTime? updatedAt,
    PersonalInfo? personal,
    List<WorkExperience>? workExperiences,
    List<Education>? educations,
    List<Skill>? skills,
    List<Project>? projects,
    List<String>? honors,
    List<String>? languages,
    String? summary,
  }) {
    return Resume(
      id: id ?? this.id,
      name: name ?? this.name,
      updatedAt: updatedAt ?? this.updatedAt,
      personal: personal ?? this.personal,
      workExperiences: workExperiences ?? this.workExperiences,
      educations: educations ?? this.educations,
      skills: skills ?? this.skills,
      projects: projects ?? this.projects,
      summary: summary ?? this.summary,
      honors: honors ?? this.honors,
      languages: languages ?? this.languages,
    );
  }
}