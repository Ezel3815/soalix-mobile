import 'package:json_annotation/json_annotation.dart';
import 'package:upgrade/models/answers_model.dart';

part 'card_model.g.dart';

@JsonSerializable()
class CardModel {
  int? order;
  @JsonKey(name: "deck_id")
  int? deckId;
  int? id;
  dynamic data;
  @JsonKey(name: "front_image_name")
  String? frontImageUrl;
  @JsonKey(name: "back_image_name")
  String? backImageUrl;
  @JsonKey(name: "document_name")
  String? documentUrl;
  @JsonKey(name: "document_title")
  String? documentTitle;
  String? type;
  @JsonKey(name: "created_at")
  String? createdAt;
  String? answer;
  List<AnswersModel>? answers;

  CardModel({
    this.type,
    this.data,
    this.answer,
    this.id,
    this.backImageUrl,
    this.createdAt,
    this.deckId,
    this.documentTitle,
    this.documentUrl,
    this.frontImageUrl,
    this.order,
    this.answers,
  });

  factory CardModel.fromJson(Map<String, dynamic> json) =>
      _$CardModelFromJson(json);

  Map<String, dynamic> toJson() => _$CardModelToJson(this);
}
