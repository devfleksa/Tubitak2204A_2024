import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';
import 'package:test_1/models/pose_model.dart';
import 'package:test_1/views/splash/splash_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ORA Demo',
      home: const SplashScreen(),
      initialBinding: SplashBinding(),
    );
  }
}

class SplashBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(PoseController());
  }
}
