// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personal_info.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PersonalInfoAdapter extends TypeAdapter<PersonalInfo> {
  @override
  final int typeId = 5;

  @override
  PersonalInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PersonalInfo(
      fullName: fields[0] as String,
      phone: fields[1] as String,
      email: fields[2] as String,
      jobTitle: fields[3] as String,
      expectedCity: fields[4] as String,
      salaryExpectation: fields[5] as String,
      availableDate: fields[6] as String,
      birthDate: fields[9] as String?,
      birthPlace: fields[10] as String?,
      politicalStatus: fields[11] as String?,
      gender: fields[12] as String?,
      nation: fields[13] as String?,
      avatarImage: fields[7] as Uint8List?,
    );
  }

  @override
  void write(BinaryWriter writer, PersonalInfo obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.fullName)
      ..writeByte(1)
      ..write(obj.phone)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.jobTitle)
      ..writeByte(4)
      ..write(obj.expectedCity)
      ..writeByte(5)
      ..write(obj.salaryExpectation)
      ..writeByte(6)
      ..write(obj.availableDate)
      ..writeByte(9)
      ..write(obj.birthDate)
      ..writeByte(10)
      ..write(obj.birthPlace)
      ..writeByte(11)
      ..write(obj.politicalStatus)
      ..writeByte(12)
      ..write(obj.gender)
      ..writeByte(13)
      ..write(obj.nation)
      ..writeByte(7)
      ..write(obj.avatarImage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PersonalInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PersonalInfo _$PersonalInfoFromJson(Map<String, dynamic> json) => PersonalInfo(
      fullName: json['fullName'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      jobTitle: json['jobTitle'] as String,
      expectedCity: json['expectedCity'] as String? ?? '',
      salaryExpectation: json['salaryExpectation'] as String? ?? '',
      availableDate: json['availableDate'] as String? ?? '',
      birthDate: json['birthDate'] as String?,
      birthPlace: json['birthPlace'] as String?,
      politicalStatus: json['politicalStatus'] as String?,
      gender: json['gender'] as String?,
      nation: json['nation'] as String?,
      avatarImage:
          PersonalInfo._avatarImageFromJson(json['avatarImage'] as String?),
    );

Map<String, dynamic> _$PersonalInfoToJson(PersonalInfo instance) =>
    <String, dynamic>{
      'fullName': instance.fullName,
      'phone': instance.phone,
      'email': instance.email,
      'jobTitle': instance.jobTitle,
      'expectedCity': instance.expectedCity,
      'salaryExpectation': instance.salaryExpectation,
      'availableDate': instance.availableDate,
      'birthDate': instance.birthDate,
      'birthPlace': instance.birthPlace,
      'politicalStatus': instance.politicalStatus,
      'gender': instance.gender,
      'nation': instance.nation,
      'avatarImage': PersonalInfo._avatarImageToJson(instance.avatarImage),
    };
