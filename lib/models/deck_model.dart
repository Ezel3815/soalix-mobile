import 'package:json_annotation/json_annotation.dart';
import 'package:upgrade/models/card_model.dart';

part 'deck_model.g.dart';

@JsonSerializable()
class DeckModel {
  int? id;
  String? title;
  @JsonKey(name: "parent_id")
  int? parentId;
  @JsonKey(name: "by_admin")
  bool? byAdmin;
  String? type;
  @JsonKey(name: "created_at")
  String? createdAt;
  bool? public;
  List<CardModel>? cards;
  List<DeckModel>? children;
  bool? editable;
  bool? sharable;
  bool? locked;

  DeckModel({
    this.createdAt,
    this.id,
    this.type,
    this.title,
    this.byAdmin,
    this.cards,
    this.children,
    this.editable,
    this.parentId,
    this.public,
    this.sharable,
  });

  factory DeckModel.fromJson(Map<String, dynamic> json) =>
      _$DeckModelFromJson(json);

  Map<String, dynamic> toJson() => _$DeckModelToJson(this);
}
