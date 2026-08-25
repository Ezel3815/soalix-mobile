import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:upgrade/controllers/api_controller.dart';
import 'package:upgrade/controllers/card_controller.dart';
import 'package:upgrade/entity/card_entity.dart';
import 'package:upgrade/entity/user_entity.dart';
import 'package:upgrade/extension.dart';
import 'package:upgrade/main.dart';
import 'package:upgrade/mapper/app_mapper.dart';
import 'package:upgrade/models/shape_creator_model.dart';
import 'package:upgrade/models/user_model.dart';
import 'package:upgrade/widgets/app_snack_bar.dart';
import 'package:upgrade/widgets/color_picker_dialog.dart';
import 'package:upgrade/widgets/font_size_dialog.dart';

class AddCardController extends GetxController {
  late int id;
  late bool isEdit;
  late UserEntity user;
  CardEntity? cardEntity;
  ShapeCreatorModel? shapeCreatorModel;
  final TextEditingController controllerFront = TextEditingController();
  final TextEditingController controllerBack = TextEditingController();
  final TextEditingController controllerComments = TextEditingController();
  final List<String> types = [
    "BASIC",
    "CLOZE",
    "OCCLUSION",
  ];

  final RxString _frontImage = ''.obs;
  final RxString _backImage = ''.obs;
  final RxString _commentImage = ''.obs;
  final RxString _file = ''.obs;
  final RxString _fileName = ''.obs;
  final RxString _selectedTypes = 'BASIC'.obs;
  final RxDouble _selectedFontSizeFront = 14.0.obs;
  final RxDouble _selectedFontSizeBack = 14.0.obs;
  final RxDouble _selectedFontSizeComment = 14.0.obs;
  final Rx<TextAlign> _selectedAlignFront = TextAlign.center.obs;
  final Rx<TextAlign> _selectedAlignBack = TextAlign.center.obs;
  final Rx<TextAlign> _selectedAlignComment = TextAlign.center.obs;

  String get frontImage => _frontImage.value;

  String get backImage => _backImage.value;

  String get commentImage => _commentImage.value;

  String get file => _file.value;

  String get fileName => _fileName.value;

  String get selectedTypes => _selectedTypes.value;

  double get selectedFontSizeFront => _selectedFontSizeFront.value;

  double get selectedFontSizeBack => _selectedFontSizeBack.value;

  double get selectedFontSizeComment => _selectedFontSizeComment.value;

  TextAlign get selectedAlignFront => _selectedAlignFront.value;

  TextAlign get selectedAlignBack => _selectedAlignBack.value;

  TextAlign get selectedAlignComment => _selectedAlignComment.value;

  set frontImage(value) => _frontImage.value = value;

  set backImage(value) => _backImage.value = value;

  set commentImage(value) => _commentImage.value = value;

  set file(value) => _file.value = value;

  set fileName(value) => _fileName.value = value;

  set selectedTypes(value) => _selectedTypes.value = value;

  set selectedFontSizeFront(value) => _selectedFontSizeFront.value = value;

  set selectedFontSizeBack(value) => _selectedFontSizeBack.value = value;

  set selectedFontSizeComment(value) => _selectedFontSizeComment.value = value;

  set selectedAlignFront(TextAlign value) => _selectedAlignFront.value = value;

  set selectedAlignBack(TextAlign value) => _selectedAlignBack.value = value;

  set selectedAlignComment(TextAlign value) =>
      _selectedAlignComment.value = value;

  void addBraces() {
    if (controllerFront.selection.start != controllerFront.selection.end) {
      String selectedText = controllerFront.text.substring(
        controllerFront.selection.start,
        controllerFront.selection.end,
      );
      controllerFront.text = controllerFront.text.replaceRange(
        controllerFront.selection.start,
        controllerFront.selection.end,
        "{$selectedText}",
      );
    } else {
      controllerFront.text += "{}";
      controllerFront.selection = TextSelection.collapsed(
        offset: controllerFront.text.length - 1,
      );
    }
  }

  void pickImage(FrontBackType type) async {
    final pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 50);

    if (pickedFile != null) {
      final image = await ApiController.uploadImage(pickedFile.path);
      if (image != null) {
        switch (type) {
          case FrontBackType.front:
            frontImage = image;
          case FrontBackType.back:
            backImage = image;
          case FrontBackType.comments:
            commentImage = image;
        }
      }
    }
  }

  pickFile() async {
    showAppLoadingDialog();
    final pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: false,
    );
    if (pickedFile != null) {
      if (pickedFile.files.isNotEmpty) {
        file =
            await ApiController.uploadFile(pickedFile.files.first.path ?? "") ??
                '';
        fileName = pickedFile.files.first.path?.split("/").last ?? '';
      }
    }

    if (Get.isDialogOpen == true) {
      Get.back();
    }
  }

  clearFile() {
    file = '';
    fileName = '';
  }

  void pickColor(FrontBackType type) async {
    Color? color = await Get.dialog(const ColorPickerDialog(tempColor: Colors.black));

    if (color != null) {
      final hexColor = color.toHex().substring(3);
      final controllers = {
        FrontBackType.front: controllerFront,
        FrontBackType.back: controllerBack,
        FrontBackType.comments: controllerComments,
      };

      final controller = controllers[type];
      if (controller == null) return;

      if (controller.selection.start != controller.selection.end) {
        String selectedText = controller.text.substring(
          controller.selection.start,
          controller.selection.end,
        );
     // <span style="color: #$color;">$insideText</span>
        controller.text = controller.text.replaceRange(
          controller.selection.start,
          controller.selection.end,
          "<span style=\"color: #$hexColor;\">$selectedText</span>",
        );
      } else {
        controller.text += "<span style=\"color: #$hexColor;\"></span>";
        controller.selection = TextSelection.collapsed(
          offset: controller.text.length - 7,
        );
      }
    }
  }

  void toggleFontSize(FrontBackType type) async {
    double? selectedSize = await Get.dialog(const FontSizeDialog());

    if (selectedSize != null) {
      switch (type) {
        case FrontBackType.front:
          selectedFontSizeFront = selectedSize;
        case FrontBackType.back:
          selectedFontSizeBack = selectedSize;
        case FrontBackType.comments:
          selectedFontSizeComment = selectedSize;
      }
    }
  }

  void addAlignToText(FrontBackType type, TextAlign align) async {
    switch (type) {
      case FrontBackType.front:
        selectedAlignFront = align;
      case FrontBackType.back:
        selectedAlignBack = align;
      case FrontBackType.comments:
        selectedAlignComment = align;
    }
  }

  void toggleBold(FrontBackType type) {
    final controllers = {
      FrontBackType.front: controllerFront,
      FrontBackType.back: controllerBack,
      FrontBackType.comments: controllerComments,
    };

    final controller = controllers[type];
    if (controller == null) return;

    if (controller.selection.start != controller.selection.end) {
      String selectedText = controller.text.substring(
        controller.selection.start,
        controller.selection.end,
      );
      controller.text = controller.text.replaceRange(
        controller.selection.start,
        controller.selection.end,
        "<b>$selectedText</b>",
      );
    } else {
      controller.text += "<b></b>";
      controller.selection = TextSelection.collapsed(
        offset: controller.text.length - 4,
      );
    }
  }

  void toggleItalic(FrontBackType type) {
    final controllers = {
      FrontBackType.front: controllerFront,
      FrontBackType.back: controllerBack,
      FrontBackType.comments: controllerComments,
    };

    final controller = controllers[type];
    if (controller == null) return;

    if (controller.selection.start != controller.selection.end) {
      String selectedText = controller.text.substring(
        controller.selection.start,
        controller.selection.end,
      );
      controller.text = controller.text.replaceRange(
        controller.selection.start,
        controller.selection.end,
        "<i>$selectedText</i>",
      );
    } else {
      controller.text += "<i></i>";
      controller.selection = TextSelection.collapsed(
        offset: controller.text.length - 4,
      );
    }
  }

  void toggleUnderline(FrontBackType type) {
    final controllers = {
      FrontBackType.front: controllerFront,
      FrontBackType.back: controllerBack,
      FrontBackType.comments: controllerComments,
    };

    final controller = controllers[type];
    if (controller == null) return;

    if (controller.selection.start != controller.selection.end) {
      String selectedText = controller.text.substring(
        controller.selection.start,
        controller.selection.end,
      );
      controller.text = controller.text.replaceRange(
        controller.selection.start,
        controller.selection.end,
        "<u>$selectedText</u>",
      );
    } else {
      controller.text += "<u></u>";
      controller.selection = TextSelection.collapsed(
        offset: controller.text.length - 4,
      );
    }
  }

  void toggleStrikethrough(FrontBackType type) {
    final controllers = {
      FrontBackType.front: controllerFront,
      FrontBackType.back: controllerBack,
      FrontBackType.comments: controllerComments,
    };

    final controller = controllers[type];
    if (controller == null) return;

    if (controller.selection.start != controller.selection.end) {
      String selectedText = controller.text.substring(
        controller.selection.start,
        controller.selection.end,
      );
      controller.text = controller.text.replaceRange(
        controller.selection.start,
        controller.selection.end,
        "<s>$selectedText</s>",
      );
    } else {
      controller.text += "<s></s>";
      controller.selection = TextSelection.collapsed(
        offset: controller.text.length - 4,
      );
    }
  }

  String getTitle(CardTypes type, FrontBackType type2) {
    if (type == CardTypes.basic && type2 == FrontBackType.front) {
      return "Front";
    }
    if (type == CardTypes.cloze && type2 == FrontBackType.front) {
      return "Text";
    }
    if (type == CardTypes.occlusion && type2 == FrontBackType.front) {
      return "Header";
    }
    if (type == CardTypes.basic && type2 == FrontBackType.back) {
      return "Back";
    }
    if ((type == CardTypes.cloze || type == CardTypes.occlusion) &&
        type2 == FrontBackType.back) {
      return "Back Extra";
    }
    if (type == CardTypes.occlusion && type2 == FrontBackType.comments) {
      return "Comments";
    }
    return "";
  }

  String getImage(FrontBackType type) {
    switch (type) {
      case FrontBackType.front:
        return frontImage;
      case FrontBackType.back:
        return backImage;
      case FrontBackType.comments:
        return commentImage;
    }
  }

  onTapClearImage(FrontBackType type) {
    switch (type) {
      case FrontBackType.front:
        frontImage = '';
      case FrontBackType.back:
        backImage = '';
      case FrontBackType.comments:
        commentImage = '';
    }
  }

  onChangeTypeValue(String? level) {
    selectedTypes = level!;
    frontImage = '';
    backImage = '';
    commentImage = '';
  }

  addCard() async {
    showAppLoadingDialog();
    final cardData = getCardData();

    CardEntity? card;

    if (isEdit) {
      card = await ApiController.editcard(
        cardEntity!.id,
        cardEntity!.deckId,
        selectedTypes,
        cardData,
        frontImageName: frontImage.isNotEmpty ? frontImage : null,
        backImageName: backImage.isNotEmpty ? backImage : null,
        documentName: file.isNotEmpty ? file : null,
        documenttitle: fileName.isNotEmpty ? fileName : null,
      );
    } else {
      card = await ApiController.addcard(
        id,
        selectedTypes,
        cardData,
        frontImageName: frontImage,
        backImageName: backImage,
        documentName: file.isNotEmpty ? file : null,
        documenttitle: fileName.isNotEmpty ? fileName : null,
      );
    }

    if (card != null) {
      Get.find<CardController>().getCard();
      Get.until((route) {
        return Get.currentRoute == AppRoutes.cardRoute;
      });
    }
  }

  Map<String, dynamic> getCardData() {
    final cardData = {
      'front': {
        'text': controllerFront.text,
        'size': selectedFontSizeFront,
        'align': selectedAlignFront.name,
      },
      'back': {
        'text': controllerBack.text,
        'size': selectedFontSizeBack,
        'align': selectedAlignBack.name,
      },
      if (selectedTypes == "OCCLUSION")
        'comment': {
          'text': controllerComments.text,
          'size': selectedFontSizeComment,
          'align': selectedAlignComment.name,
        },
      if (selectedTypes == "OCCLUSION" && shapeCreatorModel != null)
        "shapes": jsonEncode(shapeCreatorModel!.toJson()),
    };
    return cardData;
  }

  iniCard() {
    if (isEdit && cardEntity != null) {
      selectedTypes = cardEntity!.type;
      final data = jsonDecode(cardEntity!.data);
      controllerFront.text =
          data['front'] != null && data['front']['text'] != null
              ? data['front']['text']
              : '';
      controllerBack.text = data['back'] != null && data['back']['text'] != null
          ? data['back']['text']
          : '';
      selectedFontSizeFront =
          data['front'] != null && data['front']['size'] != null
              ? (data['front']['size'] as int).toDouble()
              : 14.0;
      selectedFontSizeBack =
          data['back'] != null && data['back']['size'] != null
              ? (data['back']['size'] as int).toDouble()
              : 14.0;
      frontImage = cardEntity?.frontImageUrl ?? '';
      backImage = cardEntity?.backImageUrl ?? '';
      file = cardEntity?.documentUrl ?? '';

      selectedAlignFront =
          data['front'] != null && data['front']['align'] != null
              ? data['front']['align'] == "center"
                  ? TextAlign.center
                  : data['front']['align'] == "start"
                      ? TextAlign.start
                      : TextAlign.end
              : TextAlign.center;
      selectedAlignBack = data['back'] != null && data['back']['align'] != null
          ? data['back']['align'] == "center"
              ? TextAlign.center
              : data['back']['align'] == "start"
                  ? TextAlign.start
                  : TextAlign.end
          : TextAlign.center;

      if (cardEntity!.type == "OCCLUSION") {
        controllerComments.text =
            data['comment'] != null && data['comment']['text'] != null
                ? data['comment']['text']
                : '';
        selectedFontSizeComment =
            data['comment'] != null && data['comment']['size'] != null
                ? (data['comment']['size'] as int).toDouble()
                : 14.0;
        selectedAlignComment =
            data['comment'] != null && data['comment']['align'] != null
                ? data['comment']['align'] == "center"
                    ? TextAlign.center
                    : data['comment']['align'] == "start"
                        ? TextAlign.start
                        : TextAlign.end
                : TextAlign.center;
        shapeCreatorModel = data['shapes'] != null
            ? ShapeCreatorModel.fromJson(jsonDecode(data['shapes']))
            : ShapeCreatorModel();
      }
    }
  }

  goToShapeCreator() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      final model =
          await Get.toNamed(AppRoutes.shapeCreatorRoute, arguments: image.path);
      shapeCreatorModel = model;
    }
  }

  deleteCard() async {
    Get.back();
    if (await ApiController.deleteCard(cardEntity!.deckId, cardEntity!.id)) {
      Get.until(
        (route) {
          return Get.currentRoute == AppRoutes.cardRoute;
        },
      );
      Get.find<CardController>().getCard();
    }
  }

  @override
  void onInit() {
    id = Get.arguments['id'];
    isEdit = Get.arguments['isEdit'];
    cardEntity = Get.arguments['cardEntity'];
    user = UserModel.fromJson(jsonDecode(sharedPref.getString('user') ?? "{}"))
        .toDomain();
    iniCard();
    super.onInit();
  }

  @override
  void onClose() {
    controllerFront.dispose();
    controllerBack.dispose();
    controllerComments.dispose();
    super.onClose();
  }

  bool isArabic(String text) {
    final arabicRegex = RegExp(r'[\u0600-\u06FF]');
    return arabicRegex.hasMatch(text);
  }
}




enum CardTypes { basic, cloze, occlusion }

enum FrontBackType { front, back, comments }
