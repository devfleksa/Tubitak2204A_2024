import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_oa/utils/class/user_model.dart';
import 'package:firebase_oa/utils/repos/authentication_repo.dart';
import 'package:get/get.dart';

class UserRepo extends GetxController {
  static UserRepo get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveUserRecord(UserModel user) async {
    try {
      await _db.collection('user').doc(user.id).set(user.toJson());
    } catch (e) {
      print(e.toString());
    }
  }

  Future<UserModel> fetchUserDetails() async {
    try {
      final documentSnapshot = await _db
          .collection('user')
          .doc(AuthenticationRepo.instance.authUser?.uid)
          .get();
      if (documentSnapshot.exists) {
        return UserModel.fromSnapshot(documentSnapshot);
      } else {
        return UserModel.empty();
      }
    } catch (e) {
      print(e.toString());
      return UserModel.empty();
    }
  }

  Future<void> updateUserData(UserModel updatedUser) async {
    try {
      await _db
          .collection('user')
          .doc(updatedUser.id)
          .update(updatedUser.toJson());
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> updateSingleField(Map<String, dynamic> json) async {
    try {
      await _db
          .collection('user')
          .doc(AuthenticationRepo.instance.authUser?.uid)
          .update(json);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> removeUserRecord(String userId) async {
    try {
      await _db.collection('user').doc(userId).delete();
    } catch (e) {
      print(e.toString());
    }
  }
}
