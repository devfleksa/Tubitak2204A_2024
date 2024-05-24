import 'package:firebase_oa/utils/controllers/user_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExerciseStatsView extends StatelessWidget {
  const ExerciseStatsView(
      {super.key, required this.title, required this.minAngle});

  final String title;
  final String minAngle;

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
        title: Text(title),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: controller.exerciseStats.isEmpty
          ? const Center(
              child: Text('Veri yok'),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: LineChart(
                      LineChartData(
                        lineBarsData: [
                          LineChartBarData(
                            spots: controller.exerciseStats
                                .asMap()
                                .entries
                                .map((e) => FlSpot(e.key.toDouble() + 1,
                                    double.parse(e.value)))
                                .toList(),
                            isCurved: false,
                            color: Colors.green,
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
                      'Egzersiz Bilgisi',
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
                            text: controller.exerciseStats.length.toString(),
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
                            text: minAngle,
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
                            text: controller
                                .calculateAverageAngle(controller.exerciseStats)
                                .toString(),
                            style: regularStyle,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
