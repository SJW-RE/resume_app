// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'education.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EducationAdapter extends TypeAdapter<Education> {
  @override
  final int typeId = 2;

  @override
  Education read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Education(
      school: fields[0] as String,
      degree: fields[1] as String,
      startDate: fields[2] as DateTime,
      endDate: fields[3] as DateTime?,
      description: fields[4] as String,
      major: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Education obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.school)
      ..writeByte(1)
      ..write(obj.degree)
      ..writeByte(2)
      ..write(obj.startDate)
      ..writeByte(3)
      ..write(obj.endDate)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.major);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EducationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Education _$EducationFromJson(Map<String, dynamic> json) => Education(
      school: json['school'] as String,
      degree: json['degree'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      description: json['description'] as String,
      major: json['major'] as String? ?? '',
    );

Map<String, dynamic> _$EducationToJson(Education instance) => <String, dynamic>{
      'school': instance.school,
      'degree': instance.degree,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'description': instance.description,
      'major': instance.major,
    };
