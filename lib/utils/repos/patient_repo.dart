import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_oa/utils/class/exercises.dart';

import 'package:get/get.dart';

class PatientRepo extends GetxController {
  static PatientRepo get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<List<Exercises>?> getExercises(String userId, String status) async {
    try {
      final snapshot = await _db
          .collection('exercises')
          .where('uid', isEqualTo: userId)
          .where('status', isEqualTo: status)
          .limit(20)
          .get();

      if (snapshot.docs.isEmpty) {
        print('No exercises found for user $userId');
        return [];
      } else {
        return snapshot.docs.map((doc) => Exercises.fromSnapshot(doc)).toList();
      }
    } catch (e) {
      print('Error fetching exercises for user $userId: ${e.toString()}');
      return [];
    }
  }
}
