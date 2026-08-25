import 'package:hive/hive.dart';
import 'package:upgrade/hive_constants.dart';
part 'document_entity.g.dart';

@HiveType(typeId: HiveConstants.documentType)
class DocumentEntity {
  @HiveField(0)
  String name;
  @HiveField(1)
  String title;

  DocumentEntity({
    required this.title,
    required this.name,
  });
}
