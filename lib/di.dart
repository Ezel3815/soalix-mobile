import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:upgrade/controllers/app_local_data_source.dart';
import 'package:upgrade/entity/answers_entity.dart';
import 'package:upgrade/entity/card_entity.dart';
import 'package:upgrade/entity/deck_entity.dart';
import 'package:upgrade/entity/document_entity.dart';
import 'package:upgrade/models/answers_model.dart';

import 'hive_constants.dart';
import 'network_info.dart';

final instance = GetIt.instance;

initAppModule() async {
  instance.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(
      InternetConnectionChecker.instance,
    ),
  );

  final dir = await getApplicationDocumentsDirectory();
  Hive
    ..init(dir.path)
    ..registerAdapter(DeckEntityAdapter())
    ..registerAdapter(CardEntityAdapter())
    ..registerAdapter(DocumentEntityAdapter())
    ..registerAdapter(AnswersModelAdapter());


  await Hive.openBox<DeckEntity>(HiveConstants.deckBoxName);
  await Hive.openBox<DeckEntity>(HiveConstants.myDeckBoxName);
  await Hive.openBox<CardEntity>(HiveConstants.cardBoxName);
  await Hive.openBox<DocumentEntity>(HiveConstants.documentBoxName);
  await Hive.openBox<AnswersModel>(HiveConstants.answersBoxName);

  instance.registerLazySingleton<AppLocalDataSource>(
    () => AppLocalDataSourceImpl(),
  );
}
