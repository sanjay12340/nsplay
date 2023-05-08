import 'package:nsplay/models/game_result_model.dart';
import 'package:get/state_manager.dart';

class GameNameController extends GetxController {
  var gameList = List<GameResultModel>.empty(growable: true).obs;

  void add(List<GameResultModel> gameNameList) {
    gameList.value = gameNameList;
    update();
  }

  void addSingle(GameResultModel gameNameList) {
    gameList.add(gameNameList);
    update();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
