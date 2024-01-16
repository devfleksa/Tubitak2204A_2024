import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_1/class/poses.dart';
import 'package:test_1/views/pose_info/pose_info_view.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List currentList = kneePoses;

    const String hipOAExcersizes = 'OA Egzersizleri';

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          hipOAExcersizes,
        ),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return Card(
            elevation: 10,
            child: InkWell(
              splashColor: Colors.white24.withOpacity(0.3),
              onTap: () {
                Get.to(
                  const PoseInfoView(),
                  arguments: {
                    'name': currentList[index].name,
                    'description': currentList[index].description,
                    'descriptionImageFile':
                        currentList[index].descriptionImageFile,
                    'steps': currentList[index].steps,
                  },
                );
              },
              child: Row(
                children: [
                  Image.asset(currentList[index].imageFile,
                      width: 120.0, height: 120.0),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            currentList[index].name,
                            style: GoogleFonts.ubuntu(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            currentList[index].description,
                            style: GoogleFonts.ubuntu(
                              color: Colors.grey,
                            ),
                            overflow: TextOverflow.clip,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        itemCount: currentList.length,
        scrollDirection: Axis.vertical,
      ),
    );
  }
}
