import 'dart:async';

import 'package:nsplay/models/game_result_model.dart';
import 'package:nsplay/services/game_result_service.dart';

class GameResultController extends StreamDispose {
  List<GameResultModel?>? _list = List<GameResultModel>.empty(growable: true);
  StreamController<List<GameResultModel>> gameListController =
      StreamController<List<GameResultModel>>();
  Stream<List<GameResultModel>> get listResult => gameListController.stream;
  StreamSink<List<GameResultModel?>?> get listPutResult =>
      gameListController.sink;
  void fetchResultApi() async {
    _list = await GameResultService.fetchGameResult();
    listPutResult.add(_list);
  }

  @override
  void dispose() {
    gameListController.close();
  }
}

abstract class StreamDispose {
  void dispose();
}
