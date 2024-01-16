import 'package:get/get.dart';

enum PoseState { idle, down, up }

class PoseController extends GetxController {
  var rtAngle = 0.0.obs;
  var maxAngle = 0.0.obs;
  var legStraight = false.obs;
  var falling = false.obs;

  var trunkAngle = 0.0.obs;
  var distanceX = 0.0.obs;

  var maxAnglesList = <double>[].obs;
  double currentMaxAngle = 0.0;

  var counter = 5.obs;
  var currentState = PoseState.down.obs;

  double get averageAngle {
    if (maxAnglesList.isEmpty) {
      return 0;
    }
    double total = maxAnglesList.fold(0, (sum, item) => sum + item);
    return total / maxAnglesList.length;
  }

  void resetmaxAnglesList() {
    maxAnglesList = <double>[].obs;
  }

  void resetCounter() {
    counter.value = 0;
  }

  void addMaxAngle(double angle) {
    maxAnglesList.add(angle);
  }

  void setPoseState(PoseState newState) {
    currentState.value = newState;
  }

  void decreaseCounter() {
    counter.value--;
  }

  void setCounter(int value) {
    counter.value = value;
  }
}
