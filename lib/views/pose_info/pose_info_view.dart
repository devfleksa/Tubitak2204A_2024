import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_1/views/pose_detection_view.dart';

class PoseInfoView extends StatelessWidget {
  const PoseInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = GoogleFonts.ubuntu(
      fontSize: 22,
    );

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(Get.arguments['name'] ?? 'Pose Info Page'),
        ),
        body: Container(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(Get.arguments['descriptionImageFile']),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Row(
                  children: [
                    Text(
                      'Tekrar Sayısı : ',
                      style: GoogleFonts.ubuntu(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '5',
                      style: GoogleFonts.ubuntu(
                        fontSize: 22,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.add),
                        color: Colors.white,
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(width: 20),
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.remove),
                        color: Colors.white,
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20, right: 20, bottom: 30),
                child: Divider(
                  thickness: 2,
                ),
              ),
              for (var step in Get.arguments['steps'])
                ListTile(
                  leading: Text(
                    "•",
                    style: textStyle,
                  ),
                  title: Text(
                    step,
                    style: textStyle,
                  ),
                ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Get.off(
                const PoseDetectorView(),
                arguments: {
                  'name': Get.arguments['name'],
                },
              );
            },
            label: const Text('BAŞLA')),
      ),
    );
  }
}
