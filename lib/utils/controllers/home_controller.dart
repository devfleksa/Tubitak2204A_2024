import 'package:firebase_oa/view/home/patient/exercise_done_view.dart';
import 'package:firebase_oa/view/home/patient/exercise_to_do_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  static HomeController get instance => Get.find();

  final Rx<int> selectedIndex = 0.obs;

  final List<Widget> screens = <Widget>[
    const ExcerciesToDoView(),
    const ExcerciesDoneView(),
  ];
}
