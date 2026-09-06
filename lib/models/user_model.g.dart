// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      email: json['email'] as String?,
      role: json['role'] as String?,
      status: json['status'] as String?,
      username: json['username'] as String?,
      avatar_hair: json['avatar_hair'] as String?,
      avatar_hair_color: json['avatar_hair_color'] as String?,
      avatar_skin_color: json['avatar_skin_color'] as String?,
      avatar_clothing_color: json['avatar_clothing_color'] as String?,
      avatar_glasses: json['avatar_glasses'] as bool?,
      current_streak: (json['current_streak'] as num?)?.toInt(),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'role': instance.role,
      'status': instance.status,
      'username': instance.username,
      'avatar_hair': instance.avatar_hair,
      'avatar_hair_color': instance.avatar_hair_color,
      'avatar_skin_color': instance.avatar_skin_color,
      'avatar_clothing_color': instance.avatar_clothing_color,
      'avatar_glasses': instance.avatar_glasses,
      'current_streak': instance.current_streak,
    };
