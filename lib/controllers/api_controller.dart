import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:upgrade/controllers/app_local_data_source.dart';
import 'package:upgrade/controllers/error_handler.dart';
import 'package:upgrade/di.dart';
import 'package:upgrade/entity/card_entity.dart';
import 'package:upgrade/entity/deck_entity.dart';
import 'package:upgrade/entity/document_entity.dart';
import 'package:upgrade/mapper/app_mapper.dart';
import 'package:upgrade/models/card_model.dart';
import 'package:upgrade/models/deck_model.dart';
import 'package:upgrade/models/document_model.dart';
import 'package:upgrade/models/user_model.dart';
import 'package:upgrade/network_info.dart';
import 'package:upgrade/widgets/app_snack_bar.dart';

import '../api.dart';
import '../main.dart';

class ApiController {
  static late Dio dio;
  static final AppLocalDataSource _appLocalDataSource =
      instance<AppLocalDataSource>();
  static final NetworkInfo _networkInfo = instance<NetworkInfo>();

  static initDio() {
    dio = Dio(
      BaseOptions(
        baseUrl: Api.baseUrl,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        sendTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
        validateStatus: (status) {
          return status! >= 200 || status <= 500;
        },
      ),
    );
    if (!kReleaseMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
        ),
      );
    }
  }

  static Future<void> register(String username, String email, String password,
      BuildContext context) async {
    try {
      final response = await dio.post(
        Api.register,
        data: {
          'name': username,
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 201) {
        Get.toNamed(AppRoutes.activateCodeRoute);
      } else {
        showSnackBarWidget(message: response.data['message'] ?? "");
      }
    } catch (e) {
      if(ErrorHandler.handle(e).failure.code != -6) {
        showSnackBarWidget(message: ErrorHandler
            .handle(e)
            .failure
            .message ?? "");
      }
    }
  }

  static Future<void> activate(
      String code, String email, BuildContext context) async {
    try {
      final response = await dio.put(
        Api.activate,
        data: {
          'code': code,
          'email': email,
        },
      );

      if (response.statusCode == 200) {
        Get.offAllNamed(AppRoutes.loginRoute);
      } else {
        showSnackBarWidget(message: response.data['message'] ?? "");
      }
    } catch (e) {
      if(ErrorHandler.handle(e).failure.code != -6) {
        showSnackBarWidget(message: ErrorHandler
            .handle(e)
            .failure
            .message ?? "");
      }
    }
  }

  static Future<void> login(
      String email, String password, BuildContext context) async {
    try {
      final response = await dio.post(
        Api.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      Map<String, dynamic> json = response.data;
      if (response.statusCode == 201) {
        if (json['user']['status'] == "PENDING") {
          Get.toNamed(AppRoutes.activateCodeRoute);
          return;
        }
        Get.offNamed(AppRoutes.mainRoute);
        sharedPref.setString('token', json['token']);
        sharedPref.setString(
            "user", jsonEncode(UserModel.fromJson(json['user'])));
      } else {
        showSnackBarWidget(message: json['message'] ?? "");
      }
    } catch (e) {
      if(ErrorHandler.handle(e).failure.code != -6) {
        showSnackBarWidget(message: ErrorHandler
            .handle(e)
            .failure
            .message ?? "");
      }
    }
  }

  static Future<void> requestResetPassword(
      String email, BuildContext context) async {
    try {
      final response = await dio.put(
        Api.requestResetPassword,
        data: {
          'email': email,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.offAllNamed(AppRoutes.loginRoute);
      } else {
        showSnackBarWidget(message: response.data['message'] ?? "");
      }
    } catch (e) {
      if(ErrorHandler.handle(e).failure.code != -6) {
        showSnackBarWidget(message: ErrorHandler
            .handle(e)
            .failure
            .message ?? "");
      }
    }
  }

  static Future<void> resetPassword(
      String email, String code, String password, BuildContext context) async {
    try {
      await dio.put(
        Api.resetPassword,
        data: {
          'email': email,
          'code': code,
          'password': password,
        },
      );

      Get.offAllNamed(AppRoutes.loginRoute);
    } catch (e) {
      if(ErrorHandler.handle(e).failure.code != -6) {
        showSnackBarWidget(message: ErrorHandler
            .handle(e)
            .failure
            .message ?? "");
      }
    }
  }

  static Future<CardEntity?> addcard(
    int? id,
    String type,
    Map<String, dynamic> data, {
    String? documentName,
    String? documenttitle,
    required String backImageName,
    required String frontImageName,
  }) async {
    try {
      Map<String, dynamic> requestBody = {
        'type': type,
        'data': data,
      };
      if (backImageName.isNotEmpty) {
        requestBody['back_image_name'] = backImageName;
      }

      if (frontImageName.isNotEmpty) {
        requestBody['front_image_name'] = frontImageName;
      }

      if (documentName != null) {
        requestBody['document_name'] = documentName;
      }

      if (documenttitle != null) {
        requestBody['document_title'] = documenttitle;
      }

      final response = await dio.post(
        '${Api.addCard}/$id',
        data: requestBody,
        options: GetOptions.getOptions(),
      );

      Map<String, dynamic> json = response.data;
      if (response.statusCode == 201) {
        return CardModel.fromJson(json).toDomain();
      } else {
        Get.back();
        showSnackBarWidget(message: json['message'] ?? "");
      }
    } catch (e) {
      Get.back();
      if(ErrorHandler.handle(e).failure.code != -6) {
        showSnackBarWidget(message: ErrorHandler
            .handle(e)
            .failure
            .message ?? "");
      }
    }
    return null;
  }

  static Future<CardEntity?> editcard(
    int id,
    int deckid,
    String type,
    Map<String, dynamic> data, {
    String? documentName,
    String? documenttitle,
    String? backImageName,
    String? frontImageName,
  }) async {
    try {
      Map<String, dynamic> requestBody = {
        'type': type,
        'data': data,
      };
      if (backImageName != null) {
        requestBody['back_image_name'] = backImageName;
      }

      if (frontImageName != null) {
        requestBody['front_image_name'] = frontImageName;
      }

      if (documentName != null) {
        requestBody['document_name'] = documentName;
      }

      if (documenttitle != null) {
        requestBody['document_title'] = documenttitle;
      }

      final response = await dio.put(
        '${Api.addCard}/$deckid/$id',
        data: requestBody,
        options: GetOptions.getOptions(),
      );
      Map<String, dynamic> json = response.data;
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back();
        return CardModel.fromJson(json).toDomain();
      } else {
        Get.back();
        showSnackBarWidget(message: json['message'] ?? "");
      }
    } catch (e) {
      Get.back();
      if(ErrorHandler.handle(e).failure.code != -6) {
        showSnackBarWidget(message: ErrorHandler
            .handle(e)
            .failure
            .message ?? "");
      }
    }
    return null;
  }

  static Future<String?> uploadImage(String path) async {
    try {
      final file = await MultipartFile.fromFile(path);

      final formData = FormData.fromMap(
        {
          "file": file,
        },
        ListFormat.multiCompatible,
      );

      final response = await dio.post(
        Api.uploadImage,
        data: formData,
        options: GetOptions.getOptions(),
      );

      Map<String, dynamic> json = response.data;

      if (response.statusCode == 201) {
        return json['name'];
      } else {
        showSnackBarWidget(message: json['message'] ?? "");
      }
    } catch (e) {
      log(e.toString());
      if(ErrorHandler.handle(e).failure.code != -6) {
      showSnackBarWidget(message: ErrorHandler.handle(e).failure.message ?? "");
      }
      return null;
    }
    return null;
  }

  static Future<String?> uploadFile(String path) async {
    try {
      final file = await MultipartFile.fromFile(path);

      final formData = FormData.fromMap(
        {
          "file": file,
        },
        ListFormat.multiCompatible,
      );

      final response = await dio.post(
        Api.uploadDocument,
        data: formData,
        options: GetOptions.getOptions(),
      );

      Map<String, dynamic> json = response.data;

      if (response.statusCode == 201) {
        return json['name'];
      } else {
        showSnackBarWidget(message: json['message'] ?? "");
      }
    } catch (e) {
      log(e.toString());
      if(ErrorHandler.handle(e).failure.code != -6) {
        showSnackBarWidget(message: ErrorHandler
            .handle(e)
            .failure
            .message ?? "");
      }
      return null;
    }
    return null;
  }

  static Future<List<DeckEntity>> getDecks() async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await dio.get(
          Api.getDecks,
          options: GetOptions.getOptions(),
        );

        List<dynamic> json = response.data;

        if (response.statusCode == 200 || response.statusCode == 201) {
          List<DeckModel> list = [];
          for (var value in json) {
            list.add(DeckModel.fromJson(value));
          }

          final data = list.map((e) => e.toDomain()).toList();
          await _appLocalDataSource.setDeckEntityToLocal(data);

          return data;
        } else {
          showSnackBarWidget(message: response.data['message'] ?? "");
        }

        return [];
      } catch (e) {
        if(ErrorHandler.handle(e).failure.code != -6) {
        showSnackBarWidget(
            message: ErrorHandler.handle(e).failure.message ?? "");
        }
        log(e.toString());
        return [];
      }
    } else {
      final data = await _appLocalDataSource.getDeckEntityFromLocal();
      if (data.isNotEmpty) {
        return data;
      } else {
        // showSnackBarWidget(
        //     message:
        //         DataSource.noInternetConnection.getFailure().message ?? "");
      }
    }
    return [];
  }

  static Future<List<DeckEntity>> getMyDecks() async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await dio.get(
          Api.getMyDecks,
          options: GetOptions.getOptions(),
        );

        List<dynamic> json = response.data;

        if (response.statusCode == 200 || response.statusCode == 201) {
          List<DeckModel> list = [];
          for (var value in json) {
            list.add(DeckModel.fromJson(value));
          }
          final data = list.map((e) => e.toDomain()).toList();
          await _appLocalDataSource.setMyDeckEntityToLocal(data);
          return data;
        } else {
          showSnackBarWidget(message: response.data['message'] ?? "");
        }

        return [];
      } catch (e) {
        if(ErrorHandler.handle(e).failure.code != -6) {
        showSnackBarWidget(
            message: ErrorHandler.handle(e).failure.message ?? "");
        }
        log(e.toString());
        return [];
      }
    } else {
      final data = await _appLocalDataSource.getMyDeckEntityFromLocal();
      if (data.isNotEmpty) {
        return data;
      } else {
        // showSnackBarWidget(
        //     message:
        //         DataSource.noInternetConnection.getFailure().message ?? "");
      }
    }
    return [];
  }

  static Future<bool> enterCode(String code) async {
    try {
      final response = await dio.post(
        Api.enterCode,
        data: {
          "code": code,
        },
        options: GetOptions.getOptions(),
      );
      if(response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        showSnackBarWidget(message: response.data['message'] ?? "");
      }
      return false;
    } catch (e) {
      if(ErrorHandler.handle(e).failure.code != -6) {
        showSnackBarWidget(message: ErrorHandler
            .handle(e)
            .failure
            .message ?? "");
      }
      log(e.toString());
      return false;
    }
  }

  static Future<DeckEntity?> createDeck(String name) async {
    try {
      final response = await dio.post(
        Api.createDeck,
        options: GetOptions.getOptions(),
        data: {
          "title": name,
        },
      );

      final Map<String, dynamic> json = response.data;

      return DeckModel.fromJson(json).toDomain();
    } catch (e) {
      if(ErrorHandler.handle(e).failure.code != -6) {
        showSnackBarWidget(message: ErrorHandler
            .handle(e)
            .failure
            .message ?? "");
      }
    }
    return null;
  }

  static Future<DeckEntity?> editDeck(String name, int id) async {
    try {
      final response = await dio.put(
        Api.editDeck(id),
        options: GetOptions.getOptions(),
        data: {
          "title": name,
        },
      );

      final Map<String, dynamic> json = response.data;

      return DeckModel.fromJson(json).toDomain();
    } catch (e) {
      if(ErrorHandler.handle(e).failure.code != -6) {
        showSnackBarWidget(message: ErrorHandler
            .handle(e)
            .failure
            .message ?? "");
      }
    }
    return null;
  }

  static Future<void> deleteDeck(int id) async {
    try {
      await dio.delete(
        Api.deleteDeck(id),
        options: GetOptions.getOptions(),
      );

      return;
    } catch (e) {
      if(ErrorHandler.handle(e).failure.code != -6) {
        showSnackBarWidget(message: ErrorHandler
            .handle(e)
            .failure
            .message ?? "");
      }
    }
    return;
  }

  static Future<bool> deleteCard(int deckId, int id) async {
    try {
     final response =  await dio.delete(
        Api.deleteCard(deckId, id),
        options: GetOptions.getOptions(),
      );

     if(response.statusCode == 200 || response.statusCode == 201) {
       return true;
     } else {
       showSnackBarWidget(message: response.data?['message'] ?? 'Error ${response.data}');
       return false;
     }
    } catch (e,stacktrace) {
      print(e.toString());
      print(stacktrace.toString());
      if(ErrorHandler.handle(e).failure.code != -6) {
        showSnackBarWidget(message: ErrorHandler
            .handle(e)
            .failure
            .message ?? "");
      }
    }
    return false;
  }

  static Future<List<CardEntity>> getCards(int id) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await dio.get(
          Api.getCards(id),
          options: GetOptions.getOptions(),
        );

        final List<dynamic> json = response.data;

        final List<CardModel> list = [];

        for (var element in json) {
          list.add(CardModel.fromJson(element));
        }

        final data = list.map((e) => e.toDomain()).toList();
        await _appLocalDataSource.setCardEntityToLocal(data, id);

        return data;
      } catch (e,stackTrace) {
        log(e.toString());
        log(stackTrace.toString());
        if(ErrorHandler.handle(e).failure.code != -6) {
          showSnackBarWidget(
              message: ErrorHandler
                  .handle(e)
                  .failure
                  .message ?? "");
        }
      }
    } else {
      final data = await _appLocalDataSource.getCardEntityFromLocal(id);
      if (data.isNotEmpty) {
        return data;
      } else {
        // showSnackBarWidget(
        //     message:
        //         DataSource.noInternetConnection.getFailure().message ?? "");
      }
    }
    return [];
  }

  static Future<List<DocumentEntity>> getDocument() async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await dio.get(
          Api.getDocument,
          options: GetOptions.getOptions(),
        );

        final List<dynamic> json = response.data;

        final List<DocumentModel> list = [];

        for (var element in json) {
          list.add(DocumentModel.fromJson(element));
        }

        final data = list.map((e) => e.toDomain()).toList();
        await _appLocalDataSource.setDocumentEntityToLocal(data);

        return data;
      } catch (e) {
        if(ErrorHandler.handle(e).failure.code != -6) {
          showSnackBarWidget(
              message: ErrorHandler
                  .handle(e)
                  .failure
                  .message ?? "");
        }
      }
    } else {
      final data = await _appLocalDataSource.getDocumentEntityFromLocal();
      if (data.isNotEmpty) {
        return data;
      } else {
        // showSnackBarWidget(
        //     message:
        //         DataSource.noInternetConnection.getFailure().message ?? "");
      }
    }
    return [];
  }

  static Future<void> answerCard(
      {required int cardID, required String answer}) async {
    try {
      await dio.put(
        Api.answerCard(cardID),
        data: {
          "answer": answer,
        },
        options: GetOptions.getOptions(),
      );
    } catch (e) {
      if(ErrorHandler.handle(e).failure.code != -6) {
        showSnackBarWidget(message: ErrorHandler.handle(e).failure.message ?? "");
      }
    }
  }

  static logout() async {
    await sharedPref.remove("token");
    Get.offAllNamed(AppRoutes.loginRoute);
  }
}

class GetOptions {
  static Options options = Options();

  static Options getOptions() {
    final token = sharedPref.getString("token") ?? "";
    if (token.isNotEmpty) {
      options.headers = {
        'Accept': 'application/json',
        'Authorization': token,
      };
    } else {
      options.headers = {
        'Accept': 'application/json',
      }; // default for non-auth
    }
    return options;
  }
}
