import 'package:firebase_oa/utils/network_managet.dart';
import 'package:firebase_oa/utils/repos/therapist_repo.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class CreatingExercisesController extends GetxController {
  static CreatingExercisesController get instance => Get.find();

  final String exercise1 = 'Sağ Kalça-Abdüksiyon';
  final String exercise2 = 'Sol Kalça-Abdüksiyon';
  final String exercise3 = 'Sağ Kalça-Hiperekstansiyon';
  final String exercise4 = 'Sol Kalça-Hiperekstansiyon';
  final String exercise5 = 'Sağ Kalça-Ekstansiyon';
  final String exercise6 = 'Sol Kalça-Ekstansiyon';
  final String exercise7 = 'Sağ Diz-Fleksiyon';
  final String exercise8 = 'Sol Diz-Fleksiyon';

  final description = TextEditingController();
  final minAngle = TextEditingController();
  var reps = 5.obs;

  GlobalKey<FormState> creatingExerciseFormKey = GlobalKey<FormState>();

  Future<void> createExercise(String userId) async {
    try {
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) return;

      if (!creatingExerciseFormKey.currentState!.validate()) return;

      if (userId.isNotEmpty) {
        String imagePath = 'assets/images/${exerciseName.value}.png';

        final therapistRepo = Get.put(TherapistRepo());
        await therapistRepo.createExerciseForPatient(
            userId,
            exerciseName.value,
            description.text,
            imagePath,
            minAngle.text,
            reps.value.toString(),
            'Yapılacak', []);

        Get.snackbar('Başarılı', 'Egzersiz eklendi userID: $userId');
      }

      setDefault();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  var exerciseName = 'Sağ Kalça-Abdüksiyon'.obs;

  void setSelectedExerciseName(String value) {
    exerciseName.value = value;
  }

  void increaseReps() {
    reps++;
  }

  void decreaseReps() {
    if (reps.value > 1) {
      reps--;
    }
  }

  void setDefault() {
    description.text = '';
    minAngle.text = '';
    exerciseName.value = 'Sağ Kalça-Abdüksiyon';
    reps.value = 5;
  }
}
