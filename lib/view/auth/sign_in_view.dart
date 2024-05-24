import 'package:firebase_oa/utils/controllers/sign_in_controller.dart';
import 'package:firebase_oa/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignInView extends StatelessWidget {
  const SignInView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SignInController controller = Get.put(SignInController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kayıt Ol'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Form(
            key: controller.signinFormKey,
            child: Column(
              children: [
                TextButton(
                  onPressed: () {
                    SignInController.instance.goToLoginView();
                  },
                  child: const Text('Hesabın var mı? Giriş yap.'),
                ),
                TextFormField(
                  controller: controller.userName,
                  expands: false,
                  validator: (value) =>
                      MyValidator.validateEmptyText('Username', value),
                  decoration: const InputDecoration(
                    labelText: 'Kullanıcı adı',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
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
                Obx(
                  () => DropdownButton<String>(
                    value: controller.userType.value,
                    onChanged: (value) => controller.setSelectedType(value!),
                    items: ['Hasta', 'Terapist', 'Aile Üyesi']
                        .map<DropdownMenuItem<String>>(
                      (String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      },
                    ).toList(),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    SignInController.instance.signIn();
                  },
                  child: const Text('Kayıt Ol'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
