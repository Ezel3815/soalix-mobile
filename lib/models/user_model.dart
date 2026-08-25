import 'package:json_annotation/json_annotation.dart';
part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  int? id;
  String? name;
  String? email;
  String? role;
  String? status;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.role,
    this.status,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
