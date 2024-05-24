import 'package:firebase_oa/utils/controllers/home_controller.dart';
import 'package:firebase_oa/utils/controllers/user_controller.dart';
import 'package:firebase_oa/view/home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PatientView extends StatelessWidget {
  const PatientView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeController hcontroller = Get.put(HomeController());
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          child: const UserOnAppBar(),
          onTap: () {
            // Get.off(); // user settings
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
      ),
      body: Obx(() => hcontroller.screens[hcontroller.selectedIndex.value]),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.today),
              label: 'Yapılacaklar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.done_all),
              label: 'Tamamlananlar',
            ),
          ],
          currentIndex: hcontroller.selectedIndex.value,
          onTap: (index) => hcontroller.selectedIndex.value = index,
        ),
      ),
    );
  }
}
