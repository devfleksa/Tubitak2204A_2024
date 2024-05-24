import 'package:firebase_oa/utils/network_managet.dart';
import 'package:firebase_oa/utils/repos/authentication_repo.dart';
import 'package:firebase_oa/view/auth/sign_in_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  final email = TextEditingController();
  final password = TextEditingController();

  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  Future<void> login() async {
    try {
      final isConnected = await NetworkManager.instance.isConnected();

      if (!isConnected) return;

      if (!loginFormKey.currentState!.validate()) return;

      AuthenticationRepo.instance
          .signInWithEmailAndPassword(email.text.trim(), password.text);

      setDefault();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  void setDefault() {
    email.text = '';
    password.text = '';
  }

  void goToSigninView() => Get.offAll(() => const SignInView());
}
