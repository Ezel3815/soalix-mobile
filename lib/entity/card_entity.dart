import 'package:hive/hive.dart';
import 'package:upgrade/entity/answers_entity.dart';
import 'package:upgrade/hive_constants.dart';
import 'package:upgrade/models/answers_model.dart';
part 'card_entity.g.dart';

@HiveType(typeId: HiveConstants.cardType)
class CardEntity {
  @HiveField(0)
  int order;
  @HiveField(1)
  int deckId;
  @HiveField(2)
  int id;
  @HiveField(3)
  dynamic data;
  @HiveField(4)
  String frontImageUrl;
  @HiveField(5)
  String backImageUrl;
  @HiveField(6)
  String documentUrl;
  @HiveField(7)
  String documentTitle;
  @HiveField(8)
  String type;
  @HiveField(9)
  String createdAt;
  @HiveField(10)
  String answer;
  @HiveField(11)
  List<AnswersModel>? answers;

  CardEntity({
    required this.type,
    required this.data,
    required this.answer,
    required this.id,
    required this.backImageUrl,
    required this.createdAt,
    required this.deckId,
    required this.documentTitle,
    required this.documentUrl,
    required this.frontImageUrl,
    required this.order,
     this.answers,
  });
}
