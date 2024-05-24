import 'package:firebase_oa/utils/class/user_model.dart';
import 'package:firebase_oa/utils/network_managet.dart';
import 'package:firebase_oa/utils/repos/authentication_repo.dart';
import 'package:firebase_oa/utils/repos/user_repo.dart';
import 'package:firebase_oa/view/auth/login_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignInController extends GetxController {
  static SignInController get instance => Get.find();

  final userName = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  var userType = 'Hasta'.obs;

  GlobalKey<FormState> signinFormKey = GlobalKey<FormState>();

  void setSelectedType(String type) {
    userType.value = type;
  }

  Future<void> signIn() async {
    try {
      final isConnected = await NetworkManager.instance.isConnected();

      if (!isConnected) return;

      if (!signinFormKey.currentState!.validate()) return;

      await AuthenticationRepo.instance.createUserWithEmailAndPassword(
          email.text.trim(), password.text.trim());

      if (AuthenticationRepo.instance.firebaseUser.value != null) {
        final newUser = UserModel(
          id: AuthenticationRepo.instance.firebaseUser.value!.uid,
          username: userName.text,
          email: email.text,
          userType: userType.value,
          imagePath: '',
        );

        final userRepo = Get.put(UserRepo());
        await userRepo.saveUserRecord(newUser);
      }

      setDefault();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  void setDefault() {
    userName.text = '';
    email.text = '';
    password.text = '';
    userType.value = 'Hasta';
  }

  void goToLoginView() {
    Get.offAll(() => const LoginView());
  }
}
