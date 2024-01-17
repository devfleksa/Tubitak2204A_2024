import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_1/models/pose_model.dart';
import 'package:test_1/views/splash/splash_view.dart';

class StaticsView extends StatelessWidget {
  const StaticsView({super.key});

  @override
  Widget build(BuildContext context) {
    final PoseController controller = Get.find<PoseController>();
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    void sendToFirestore(List<double> maxAnglesList) {
      Map<String, dynamic> data = {
        'maxAnglesList': maxAnglesList,
      };

      firestore
          .collection('001')
          .add(data)
          .then((docRef) {})
          .catchError((error) {});
    }

    double average = controller.averageAngle;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(Get.arguments['name']),
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
                      spots: controller.maxAnglesList
                          .asMap()
                          .entries
                          .map((e) =>
                              FlSpot(e.key.toDouble() + 1, e.value.toDouble()))
                          .toList(),
                      isCurved: false,
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Card(
            color: Colors.blue,
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Text(
                'Ortalama Açı: ${average.toStringAsFixed(1)}',
                style: GoogleFonts.ubuntu(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          sendToFirestore(controller.maxAnglesList);
          Get.offAll(const SplashScreen());
          controller.setCounter(5);
          controller.resetmaxAnglesList();
        },
        label: const Text('ANA MENÜYE DÖN'),
      ),
    );
  }
}
