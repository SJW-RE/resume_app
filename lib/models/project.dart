import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';

part 'project.g.dart';

@HiveType(typeId: 4)
@JsonSerializable()
class Project {
  @HiveField(0)
  String name;

  @HiveField(1)
  String role;

  @HiveField(2)
  String description;

  @HiveField(3)
  List<String> technologies;

  @HiveField(4)
  DateTime? startDate;

  @HiveField(5)
  DateTime? endDate;

  Project({
    required this.name,
    required this.role,
    required this.description,
    required this.technologies,
    this.startDate,
    this.endDate,
  });

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);
  Map<String, dynamic> toJson() => _$ProjectToJson(this);
}
