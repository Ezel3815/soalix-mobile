import 'package:json_annotation/json_annotation.dart';
part 'document_model.g.dart';

@JsonSerializable()
class DocumentModel {
  String? name;
  String? title;

  DocumentModel({
    this.title,
    this.name,
  });

  factory DocumentModel.fromJson(Map<String, dynamic> json) =>
      _$DocumentModelFromJson(json);

  Map<String, dynamic> toJson() => _$DocumentModelToJson(this);
}
