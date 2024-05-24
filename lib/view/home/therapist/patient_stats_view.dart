import 'package:firebase_oa/utils/controllers/user_controller.dart';
import 'package:firebase_oa/utils/repos/authentication_repo.dart';
import 'package:firebase_oa/view/home/therapist/creating_exercises_view.dart';
import 'package:firebase_oa/view/home/therapist/exercise_stats_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PatientStatsView extends StatelessWidget {
  const PatientStatsView({super.key, required this.pindex});

  final int pindex;

  @override
  Widget build(BuildContext context) {
    final UserController controller = Get.put(UserController());
    const TextStyle boldStyle = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
    );
    const TextStyle regularStyle = TextStyle(
      color: Colors.black,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(controller.patients[pindex].username),
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder(
        future: controller
            .fetchExerciseForTherapist(controller.patients[pindex].id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            return controller.patientsExercizes.isNotEmpty
                ? ListView.builder(
                    itemCount: controller.patientsExercizes.length,
                    itemBuilder: (context, i) {
                      return Obx(() {
                        return Card(
                          elevation: 10,
                          child: InkWell(
                            splashColor: Colors.white24.withOpacity(0.3),
                            onTap: () {
                              controller.setStats(i);
                              Get.to(
                                () => ExerciseStatsView(
                                  title: controller.patientsExercizes[i].name,
                                  minAngle:
                                      controller.patientsExercizes[i].minAngle,
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, top: 10.0, bottom: 10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              const TextSpan(
                                                  text: 'egzersiz: ',
                                                  style: boldStyle),
                                              TextSpan(
                                                  text: controller
                                                      .patientsExercizes[i]
                                                      .name,
                                                  style: regularStyle),
                                            ],
                                          ),
                                        ),
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              const TextSpan(
                                                text: 'tekrar sayısı: ',
                                                style: boldStyle,
                                              ),
                                              TextSpan(
                                                text: controller
                                                    .patientsExercizes[i].reps,
                                                style: regularStyle,
                                              ),
                                            ],
                                          ),
                                        ),
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              const TextSpan(
                                                text: 'açı: ',
                                                style: boldStyle,
                                              ),
                                              TextSpan(
                                                text: controller
                                                    .patientsExercizes[i]
                                                    .minAngle,
                                                style: regularStyle,
                                              ),
                                            ],
                                          ),
                                        ),
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              const TextSpan(
                                                text: 'durum: ',
                                                style: boldStyle,
                                              ),
                                              TextSpan(
                                                text: controller
                                                    .patientsExercizes[i]
                                                    .status,
                                                style: regularStyle,
                                              ),
                                            ],
                                          ),
                                        ),
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              const TextSpan(
                                                text: 'açıklama: ',
                                                style: boldStyle,
                                              ),
                                              TextSpan(
                                                text: controller
                                                    .patientsExercizes[i]
                                                    .description,
                                                style: regularStyle,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(right: 16.0),
                                  child: Icon(Icons.chevron_right_rounded),
                                )
                              ],
                            ),
                          ),
                        );
                      });
                    },
                  )
                : const Center(
                    child: Text('Veri yok'),
                  );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.user.value.userType == 'Terapist'
              ? Get.to(() => const CreatingExercisesView(), arguments: {
                  'name': controller.patients[pindex].username,
                  'id': controller.patients[pindex].id,
                })
              : ();
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }
}
