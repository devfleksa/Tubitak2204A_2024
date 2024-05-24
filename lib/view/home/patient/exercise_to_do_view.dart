import 'package:firebase_oa/utils/controllers/user_controller.dart';
import 'package:firebase_oa/view/home/patient/exercise_info_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExcerciesToDoView extends StatelessWidget {
  const ExcerciesToDoView({super.key});

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
    return FutureBuilder(
      future: controller.fetchExercises('Yapılacak'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (controller.exercisesWillDo.isEmpty) {
          return const Scaffold(
            body: Center(child: Text('Henüz yapılacak egzersiz yok.')),
          );
        } else {
          return Scaffold(
            body: ListView.builder(
              itemCount: controller.exercisesWillDo.length,
              itemBuilder: (context, i) {
                return Card(
                  elevation: 10,
                  child: InkWell(
                    splashColor: Colors.white24.withOpacity(0.3),
                    onTap: () {
                      Get.to(
                        () => ExerciseInfoView(
                          id: controller.exercisesWillDo[i].id,
                          title: controller.exercisesWillDo[i].name,
                          reps: int.parse(controller.exercisesWillDo[i].reps),
                          minAngle: double.parse(
                              controller.exercisesWillDo[i].minAngle),
                          gifPath: controller.exercisesWillDo[i].imagePath,
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Image.asset(
                          controller.exercisesWillDo[i].imagePath,
                          height: 120,
                          width: 120,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, top: 10.0, bottom: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text:
                                            controller.exercisesWillDo[i].name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 3),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: 'Tekrar: ',
                                        style: boldStyle,
                                      ),
                                      TextSpan(
                                        text:
                                            controller.exercisesWillDo[i].reps,
                                        style: regularStyle,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 3),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: 'Açı: ',
                                        style: boldStyle,
                                      ),
                                      TextSpan(
                                        text: controller
                                            .exercisesWillDo[i].minAngle,
                                        style: regularStyle,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 3),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: 'Açıklama: ',
                                        style: boldStyle,
                                      ),
                                      TextSpan(
                                        text: controller
                                            .exercisesWillDo[i].description,
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
              },
            ),
          );
        }
      },
    );
  }
}
