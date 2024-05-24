import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_oa/utils/class/exercises.dart';
import 'package:firebase_oa/utils/class/user_model.dart';
import 'package:firebase_oa/utils/repos/authentication_repo.dart';
import 'package:firebase_oa/utils/repos/patient_repo.dart';
import 'package:firebase_oa/utils/repos/therapist_repo.dart';
import 'package:firebase_oa/utils/repos/user_repo.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  //İts For General Users
  Rx<UserModel> user = UserModel.empty().obs;
  final userRepo = Get.put(UserRepo());
  final isLoading = false.obs;

  //İts For Therapist Home Page
  RxList<UserModel> patients = <UserModel>[].obs;
  final therapistRepo = Get.put(TherapistRepo());
  RxList<Exercises> patientsExercizes = <Exercises>[].obs;
  RxList<String> exerciseStats = <String>[].obs;

  //İts For Patients Home Page
  final patientRepo = Get.put(PatientRepo());
  RxList<Exercises> exercisesWillDo = <Exercises>[].obs;
  RxList<Exercises> exercisesDone = <Exercises>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserRecord();
    fetchPatients();
  }

  Future<void> saveUserRecord(UserCredential? userCredentials) async {
    try {
      if (userCredentials != null) {
        // final username = UserModel.name
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> fetchUserRecord() async {
    try {
      isLoading.value = true;
      final user = await userRepo.fetchUserDetails();
      this.user(user);
    } catch (e) {
      user(UserModel.empty());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateExerciseStats(String id, List<String> stats) async {
    var documentReference =
        FirebaseFirestore.instance.collection('exercises').doc(id);

    await documentReference.update({
      'stats': stats,
      'status': 'Tamamlandı',
    }).then((_) {
      print('Stats successfully updated for Exercise ID: $id');
    }).catchError((error) {
      print('Error updating stats for Exercise ID: $id: $error');
    });
  }

  fetchPatients() async {
    try {
      isLoading.value = true;

      final data = await therapistRepo.getPatients();

      patients.assignAll(data);

      isLoading.value = false;
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> fetchExerciseForTherapist(String uid) async {
    try {
      isLoading.value = true;
      final data = await therapistRepo.getExercisesByUserId(uid);

      patientsExercizes.assignAll(data ?? []);

      sortExercisesByStatus('Yapılacak');
      isLoading.value = false;
    } catch (e) {
      print(e.toString());
    }
  }

  void sortExercisesByStatus(String status) {
    patientsExercizes.sort((a, b) {
      if (a.status == status && b.status != status) {
        return -1;
      } else if (a.status != status && b.status == status) {
        return 1;
      } else {
        return 0;
      }
    });
  }

  Future<void> fetchExercises(String status) async {
    try {
      isLoading.value = true;
      final data = await patientRepo.getExercises(user.value.id, status);
      if (status == 'Yapılacak') {
        exercisesWillDo.assignAll(data ?? []);
      } else if (status == 'Tamamlandı') {
        exercisesDone.assignAll(data ?? []);
      }

      isLoading.value = false;
    } catch (e) {
      print(e.toString());
    }
  }

  void setStats(int index) {
    if (index < 0 || index >= patientsExercizes.length) {
      print('Index out of range');
      return;
    }

    exerciseStats.clear();
    exerciseStats.addAll(patientsExercizes[index].stats ?? []);
  }

  double calculateAverageAngle(List<String> stats) {
    double sum = 0.0;
    for (var e in stats) {
      double a = double.parse(e);
      sum = sum + a;
    }
    return sum / stats.length;
  }

  void logOut() {
    AuthenticationRepo.instance.logout();
  }
}
