import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_oa/utils/repos/authentication_repo.dart';
import 'package:firebase_oa/utils/bindings/genera_bindings.dart';
import 'package:firebase_oa/view/auth/sign_in_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then(
    (value) => Get.put(
      AuthenticationRepo(),
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      themeMode: ThemeMode.system,
      theme: ThemeData(
        useMaterial3: false,
      ),
      initialBinding: GeneralBindings(),
      debugShowCheckedModeBanner: false,
      home: const SignInView(),
    );
  }
}
