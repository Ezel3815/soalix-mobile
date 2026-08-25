import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:upgrade/hive_constants.dart';
part 'answers_model.g.dart';


@JsonSerializable()
@HiveType(typeId: HiveConstants.answersType)
class AnswersModel {
  @JsonKey(name: "user_id")
  @HiveField(0)
  int? userId;
  @JsonKey(name: "card_id")
  @HiveField(1)
  int? cardId;
  @HiveField(2)
  String? answer;

  AnswersModel({
    this.answer,
    this.cardId,
    this.userId,
  });

  factory AnswersModel.fromJson(Map<String, dynamic> json) =>
      _$AnswersModelFromJson(json);

  Map<String, dynamic> toJson() => _$AnswersModelToJson(this);
}
