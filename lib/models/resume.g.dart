// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resume.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ResumeAdapter extends TypeAdapter<Resume> {
  @override
  final int typeId = 6;

  @override
  Resume read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Resume(
      id: fields[0] as String,
      name: fields[1] as String,
      updatedAt: fields[2] as DateTime,
      personal: fields[3] as PersonalInfo,
      workExperiences: (fields[4] as List).cast<WorkExperience>(),
      educations: (fields[5] as List).cast<Education>(),
      skills: (fields[6] as List).cast<Skill>(),
      projects: (fields[7] as List).cast<Project>(),
      summary: fields[10] as String,
      honors: (fields[8] as List).cast<String>(),
      languages: (fields[9] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Resume obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.updatedAt)
      ..writeByte(3)
      ..write(obj.personal)
      ..writeByte(4)
      ..write(obj.workExperiences)
      ..writeByte(5)
      ..write(obj.educations)
      ..writeByte(6)
      ..write(obj.skills)
      ..writeByte(7)
      ..write(obj.projects)
      ..writeByte(8)
      ..write(obj.honors)
      ..writeByte(9)
      ..write(obj.languages)
      ..writeByte(10)
      ..write(obj.summary);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResumeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Resume _$ResumeFromJson(Map<String, dynamic> json) => Resume(
      id: json['id'] as String,
      name: json['name'] as String,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      personal: PersonalInfo.fromJson(json['personal'] as Map<String, dynamic>),
      workExperiences: (json['workExperiences'] as List<dynamic>)
          .map((e) => WorkExperience.fromJson(e as Map<String, dynamic>))
          .toList(),
      educations: (json['educations'] as List<dynamic>)
          .map((e) => Education.fromJson(e as Map<String, dynamic>))
          .toList(),
      skills: (json['skills'] as List<dynamic>)
          .map((e) => Skill.fromJson(e as Map<String, dynamic>))
          .toList(),
      projects: (json['projects'] as List<dynamic>)
          .map((e) => Project.fromJson(e as Map<String, dynamic>))
          .toList(),
      summary: json['summary'] as String,
      honors: (json['honors'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      languages: (json['languages'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ResumeToJson(Resume instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'updatedAt': instance.updatedAt.toIso8601String(),
      'personal': instance.personal.toJson(),
      'workExperiences':
          instance.workExperiences.map((e) => e.toJson()).toList(),
      'educations': instance.educations.map((e) => e.toJson()).toList(),
      'skills': instance.skills.map((e) => e.toJson()).toList(),
      'projects': instance.projects.map((e) => e.toJson()).toList(),
      'honors': instance.honors,
      'languages': instance.languages,
      'summary': instance.summary,
    };
