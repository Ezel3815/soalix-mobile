import 'package:upgrade/entity/answers_entity.dart';
import 'package:upgrade/entity/card_entity.dart';
import 'package:upgrade/entity/deck_entity.dart';
import 'package:upgrade/entity/document_entity.dart';
import 'package:upgrade/entity/shape_creator_entity.dart';
import 'package:upgrade/entity/user_entity.dart';
import 'package:upgrade/models/answers_model.dart';
import 'package:upgrade/models/card_model.dart';
import 'package:upgrade/models/deck_model.dart';
import 'package:upgrade/models/document_model.dart';
import 'package:upgrade/models/shape_creator_model.dart';
import 'package:upgrade/models/user_model.dart';

extension DeckMapper on DeckModel? {
  DeckEntity toDomain() {
    return DeckEntity(
      createdAt: this?.createdAt ?? "",
      id: this?.id ?? 0,
      type: this?.type ?? "",
      title: this?.title ?? "",
      byAdmin: this?.byAdmin ?? false,
      cards: this?.cards?.map((e) => e.toDomain()).toList() ?? [],
      children: this?.children?.map((e) => e.toDomain()).toList() ?? [],
      editable: this?.editable ?? false,
      parentId: this?.parentId ?? 0,
      public: this?.public ?? false,
      sharable: this?.sharable ?? false,
      locked: this?.locked ?? false,
    );
  }
}

extension CardMapper on CardModel? {
  CardEntity toDomain() {
    return CardEntity(
      type: this?.type ?? "",
      data: this?.data,
      answer: this?.answer ?? "",
      id: this?.id ?? 0,
      backImageUrl: this?.backImageUrl ?? "",
      createdAt: this?.createdAt ?? "",
      deckId: this?.deckId ?? 0,
      documentTitle: this?.documentTitle ?? "",
      documentUrl: this?.documentUrl ?? "",
      frontImageUrl: this?.frontImageUrl ?? "",
      order: this?.order ?? 0,
      answers: this?.answers ?? [],
    );
  }
}

extension ShapeCreatorMapper on ShapeCreatorModel? {
  ShapeCreatorEntity toDomain() {
    return ShapeCreatorEntity(
      image: this?.image ?? "",
      imageData: this?.imageData?.toDomain() ??
          ShapeCreatorImageDataModel().toDomain(),
      shapes: this?.shapes?.map((e) => e.toDomain()).toList() ?? [],
    );
  }
}

extension ShapeCreatorImageDataMapper on ShapeCreatorImageDataModel? {
  ShapeCreatorImageDataEntity toDomain() {
    return ShapeCreatorImageDataEntity(
      width: this?.width ?? 0,
      height: this?.height ?? 0,
    );
  }
}

extension ShapeCreatorShapesMapper on ShapeCreatorShapesModel? {
  ShapeCreatorShapesEntity toDomain() {
    return ShapeCreatorShapesEntity(
      type: this?.type ?? "",
      text: this?.text ?? "",
      position:
          this?.position?.toDomain() ?? ShapeCreatorPositionModel().toDomain(),
      width: this?.width ?? 0,
      height: this?.height ?? 0,
    );
  }
}

extension ShapeCreatorPositionMapper on ShapeCreatorPositionModel? {
  ShapeCreatorPositionEntity toDomain() {
    return ShapeCreatorPositionEntity(
      x: this?.x ?? 0,
      y: this?.y ?? 0,
    );
  }
}

extension DocumentMapper on DocumentModel? {
  DocumentEntity toDomain() {
    return DocumentEntity(
      title: this?.title ?? "",
      name: this?.name ?? "",
    );
  }
}

extension UserMapper on UserModel? {
  UserEntity toDomain() {
    return UserEntity(
      id: this?.id ?? 0,
      name: this?.name ?? "",
      email: this?.email ?? "",
      role: this?.role ?? "",
      status: this?.status ?? "",
    );
  }
}

extension AnswersMapper on AnswersModel? {
  AnswersEntity toDomain() {
    return AnswersEntity(
      answer: this?.answer ?? '',
      cardId: this?.cardId ?? 0,
      userId: this?.userId ?? 0,
    );
  }
}
