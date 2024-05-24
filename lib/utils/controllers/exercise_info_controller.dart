import 'package:get/get.dart';

class ExerciseInfoController extends GetxController {
  static ExerciseInfoController get instance => Get.find();

  RxString title = ''.obs;
  RxInt reps = 5.obs;
  RxDouble minAngle = 40.0.obs;
  RxString gifPath = 'assets/placeholders/user_placeholder'.obs;
}
