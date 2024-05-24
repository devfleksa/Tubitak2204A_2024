import 'package:firebase_oa/utils/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExcerciesDoneView extends StatelessWidget {
  const ExcerciesDoneView({super.key});

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
      future: controller.fetchExercises('Tamamlandı'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (controller.exercisesDone.isEmpty) {
          return const Scaffold(
            body: Center(child: Text('Henüz tamamlanan egzersiz yok.')),
          );
        } else {
          return Scaffold(
            body: ListView.builder(
              itemCount: controller.exercisesDone.length,
              itemBuilder: (context, i) {
                return Card(
                  elevation: 10,
                  child: InkWell(
                    splashColor: Colors.white24.withOpacity(0.3),
                    onTap: () {},
                    child: Row(
                      children: [
                        Image.asset(
                          controller.exercisesDone[i].imagePath,
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
                                        text: controller.exercisesDone[i].name,
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
                                        text: controller.exercisesDone[i].reps,
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
                                            .exercisesDone[i].minAngle,
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
                                            .exercisesDone[i].description,
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
