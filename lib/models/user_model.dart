import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  int? id;
  String? name;
  String? email;
  String? role;
  String? status;
  String? username;
  String? avatar_hair;
  String? avatar_hair_color;
  String? avatar_skin_color;
  String? avatar_clothing_color;
  bool? avatar_glasses;
  int? current_streak;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.role,
    this.status,
    this.username,
    this.avatar_hair,
    this.avatar_hair_color,
    this.avatar_skin_color,
    this.avatar_clothing_color,
    this.avatar_glasses,
    this.current_streak,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
