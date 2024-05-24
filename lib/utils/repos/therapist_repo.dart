import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_oa/utils/class/exercises.dart';
import 'package:firebase_oa/utils/class/user_model.dart';
import 'package:get/get.dart';

class TherapistRepo extends GetxController {
  static TherapistRepo get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<List<UserModel>> getPatients() async {
    try {
      final snapshot = await _db
          .collection('user')
          .where('userType', isEqualTo: 'Hasta')
          .limit(20)
          .get();

      return snapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList();
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<void> createExerciseForPatient(
      String userId,
      String name,
      String description,
      String imagePath,
      String minAngle,
      String reps,
      String status,
      List<String>? stats) async {
    try {
      DocumentReference docRef = _db.collection('exercises').doc();
      final exercises = Exercises(
        id: docRef.id,
        uid: userId,
        name: name,
        description: description,
        imagePath: imagePath,
        minAngle: minAngle,
        reps: reps,
        status: status,
        stats: stats,
      );
      await docRef.set(exercises.toJson());
      print(
          'Exercise successfully created with ID ${docRef.id} for user $userId');
    } catch (e) {
      print('Error creating exercise for user $userId: ${e.toString()}');
    }
  }

  Future<List<Exercises>?> getExercisesByUserId(String uid) async {
    try {
      final snapshot = await _db
          .collection('exercises')
          .where('uid', isEqualTo: uid)
          .limit(20)
          .get();

      return snapshot.docs.map((doc) => Exercises.fromSnapshot(doc)).toList();
    } catch (e) {
      print('Error fetching exercises for user $uid: ${e.toString()}');
      return [];
    }
  }
}
