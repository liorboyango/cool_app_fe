// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: (json['id'] as num).toInt(),
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      role: json['role'] as String,
      email: json['email'] as String,
      gender: json['gender'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      linkedinUrl: json['linkedinUrl'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'role': instance.role,
      'email': instance.email,
      'gender': instance.gender,
      'phoneNumber': instance.phoneNumber,
      'linkedinUrl': instance.linkedinUrl,
    };