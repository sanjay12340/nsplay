import 'package:get/state_manager.dart';
import 'package:nsplay/models/half_sangam_opne_bet_model.dart';

class HalfSangamOpenBetController extends GetxController {
  var _betList = List<HalfSangamOpenBetModel>.empty(growable: true).obs;

  void add(HalfSangamOpenBetModel halfSangamOpenBetModel) {
    _betList.add(halfSangamOpenBetModel);
    update();
  }

  void removeAt(int index) {
    _betList.removeAt(index);
    update();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
