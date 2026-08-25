import 'package:hive/hive.dart';
import 'package:upgrade/entity/card_entity.dart';
import 'package:upgrade/hive_constants.dart';
part 'deck_entity.g.dart';

@HiveType(typeId: HiveConstants.deckType)
class DeckEntity {
  @HiveField(0)
  int id;
  @HiveField(1)
  String title;
  @HiveField(2)
  int parentId;
  @HiveField(3)
  bool byAdmin;
  @HiveField(4)
  String type;
  @HiveField(5)
  String createdAt;
  @HiveField(6)
  bool public;
  @HiveField(7)
  List<CardEntity> cards;
  @HiveField(8)
  List<DeckEntity> children;
  @HiveField(9)
  bool editable;
  @HiveField(10)
  bool sharable;
  @HiveField(11)
  bool locked;

  DeckEntity({
    required this.createdAt,
    required this.id,
    required this.type,
    required this.title,
    required this.byAdmin,
    required this.cards,
    required this.children,
    required this.editable,
    required this.parentId,
    required this.public,
    required this.sharable,
    required this.locked,
  });
}
