import 'package:firebase_oa/utils/controllers/user_controller.dart';
import 'package:firebase_oa/view/home/home_view.dart';
import 'package:firebase_oa/view/home/therapist/patient_stats_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TherapistView extends StatelessWidget {
  const TherapistView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final UserController controller = Get.put(UserController());
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          child: const UserOnAppBar(),
          onTap: () {
            // Get.off(); user settings
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              UserController.instance.logOut();
            },
            child: const Text(
              'Çıkış Yap',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
        centerTitle: false,
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
        itemCount: controller.patients.length,
        itemBuilder: (context, i) {
          return Obx(() {
            return Card(
              elevation: 10,
              child: InkWell(
                splashColor: Colors.white24.withOpacity(0.3),
                onTap: () {
                  Get.to(
                    () => PatientStatsView(
                      pindex: i,
                    ),
                    arguments: {
                      'index': controller.patients[i],
                    },
                  );
                },
                child: Row(
                  children: [
                    Image.asset(
                      'assets/placeholders/user_placeholder.png',
                      width: 120,
                      height: 120,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              controller.patients[i].username,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 24),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 14),
                            child: Text(
                              controller.patients[i].email,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        },
      ),
      // Belki FloatingActionButton eklenebilir ve hastlar her terapistin localinde keydedilebilir.
    );
  }
}
