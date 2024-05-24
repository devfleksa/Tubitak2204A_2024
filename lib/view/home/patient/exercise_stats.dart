import 'package:firebase_oa/utils/controllers/user_controller.dart';
import 'package:firebase_oa/view/home/home_view.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExerciseStats extends StatelessWidget {
  const ExerciseStats(
      {super.key,
      required this.exerciseName,
      required this.minAngle,
      required this.maxAnglesList,
      required this.averageAngle,
      required this.id});

  final String id;
  final String exerciseName;
  final double minAngle;
  final List<double> maxAnglesList;
  final double averageAngle;

  @override
  Widget build(BuildContext context) {
    final UserController controller = Get.put(UserController());
    List<String> convertDoubleListToStringList(List<double> doubleList) {
      return doubleList
          .map((doubleValue) => doubleValue.toStringAsFixed(2))
          .toList();
    }

    const TextStyle boldStyle = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
    );
    const TextStyle regularStyle = TextStyle(
      color: Colors.black,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(exerciseName),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: AspectRatio(
              aspectRatio: 1,
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: maxAnglesList
                          .asMap()
                          .entries
                          .map((e) => FlSpot(e.key.toDouble() + 1, e.value))
                          .toList(),
                      isCurved: false,
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Egzersiz İstatistikleri',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 16.0),
              RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Tekrar Sayısı: ',
                      style: boldStyle,
                    ),
                    TextSpan(
                      text: maxAnglesList.length.toString(),
                      style: regularStyle,
                    ),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Açı: ',
                      style: boldStyle,
                    ),
                    TextSpan(
                      text: minAngle.toString(),
                      style: regularStyle,
                    ),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Egzersiz Sırasında Ortalama Açı: ',
                      style: boldStyle,
                    ),
                    TextSpan(
                      text: averageAngle.toStringAsFixed(2),
                      style: regularStyle,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            List<String> stats = convertDoubleListToStringList(maxAnglesList);
            try {
              await controller.updateExerciseStats(id, stats);
              Get.offAll(() => const HomeView());
              print('Stats successfully updated and navigating home.');
            } catch (error) {
              print('Failed to update stats: $error');
            }
          },
          label: const Text('Ana Menüye Dön')),
    );
  }
}
