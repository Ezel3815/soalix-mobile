import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:upgrade/controllers/api_controller.dart';
import 'package:upgrade/entity/document_entity.dart';

class DocumentController extends GetxController {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final RxBool _loading = false.obs;
  final RxList<DocumentEntity> _docs = <DocumentEntity>[].obs;
  final RxList<DocumentEntity> _searchList = <DocumentEntity>[].obs;

  bool get loading => _loading.value;

  List<DocumentEntity> get docs => _docs;
  List<DocumentEntity> get searchList => _searchList;

  set loading(value) => _loading.value = value;

  set docs(List<DocumentEntity> value) => _docs.value = value;
  set searchList(List<DocumentEntity> value) => _searchList.value = value;

  getDocument() async {
    loading = true;
    docs = await ApiController.getDocument();
    loading = false;
  }

  @override
  void onInit() async {
    await getDocument();
    super.onInit();
  }
}
