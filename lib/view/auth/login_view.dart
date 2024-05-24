import 'package:firebase_oa/utils/controllers/login_controller.dart';
import 'package:firebase_oa/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.put(LoginController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Giriş Yap'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Form(
            key: controller.loginFormKey,
            child: Column(
              children: [
                TextButton(
                  onPressed: () {
                    LoginController.instance.goToSigninView();
                  },
                  child: const Text("Hesabın yok mu? Hemen bir tane oluştur."),
                ),
                TextFormField(
                  controller: controller.email,
                  expands: false,
                  validator: (value) => MyValidator.validateEmail(value),
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: controller.password,
                  obscureText: true,
                  expands: false,
                  validator: (value) => MyValidator.validatePassword(value),
                  decoration: const InputDecoration(
                    labelText: 'Şifre',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    LoginController.instance.login();
                  },
                  child: const Text('Giriş Yap'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
