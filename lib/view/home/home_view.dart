import 'package:firebase_oa/view/home/family_member/family_member_view.dart';
import 'package:firebase_oa/view/home/patient/patient_view.dart';
import 'package:firebase_oa/view/home/therapist/therapist_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_oa/utils/controllers/user_controller.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController controller = Get.put(UserController());

    return FutureBuilder(
      future: controller.fetchUserRecord(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return const Text('Error');
        } else {
          switch (controller.user.value.userType) {
            case 'Hasta':
              return const PatientView();
            case 'Terapist':
              return const TherapistView();
            case 'Aile Üyesi':
              return const FamilyView();
            default:
              print('Error ${controller.user.value.userType.toString()}');
              return const Placeholder(); // Default ekran
          }
        }
      },
    );
  }
}

class UserOnAppBar extends StatelessWidget {
  const UserOnAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final UserController controller = Get.put(UserController());
    return Row(
      children: [
        const Icon(Icons.person_2),
        Padding(
          padding: const EdgeInsets.only(left: 1, right: 3),
          child: Obx(
            () => Text(
              controller.user.value.username,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Obx(
          () => Text(
            '(${controller.user.value.userType})',
          ),
        ),
      ],
    );
  }
}
