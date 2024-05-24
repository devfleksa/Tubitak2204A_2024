import 'package:firebase_oa/utils/controllers/creating_exercises_cotnroller.dart';
import 'package:firebase_oa/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreatingExercisesView extends StatelessWidget {
  const CreatingExercisesView({super.key});

  @override
  Widget build(BuildContext context) {
    final CreatingExercisesController controller =
        Get.put(CreatingExercisesController());

    final String userId = Get.arguments['id'];
    final String userName = Get.arguments['name'];

    return Scaffold(
      appBar: AppBar(
        title: Text(userName),
        centerTitle: false,
        backgroundColor: Colors.green,
      ),
      body: Form(
        key: controller.creatingExerciseFormKey,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 16,
            right: 16,
            left: 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Obx(
                  () => DropdownButton<String>(
                    value: controller.exerciseName.value,
                    onChanged: (value) =>
                        controller.setSelectedExerciseName(value!),
                    items: [
                      controller.exercise1,
                      controller.exercise2,
                      controller.exercise3,
                      controller.exercise4,
                      controller.exercise5,
                      controller.exercise6,
                      controller.exercise7,
                      controller.exercise8
                    ].map<DropdownMenuItem<String>>(
                      (String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      },
                    ).toList(),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: 225,
                  child: TextFormField(
                    controller: controller.minAngle,
                    expands: false,
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        MyValidator.validateEmptyText('Angle', value),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Açı',
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Tekrar Sayısı : ',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.remove),
                        color: Colors.white,
                        onPressed: () {
                          controller.decreaseReps();
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Obx(
                      () => Text(
                        controller.reps.value.toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.add),
                        color: Colors.white,
                        onPressed: () {
                          controller.increaseReps();
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: controller.description,
                  expands: false,
                  validator: (value) =>
                      MyValidator.validateEmptyText('Description', value),
                  decoration: const InputDecoration(
                    labelText: 'Açıklama',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    CreatingExercisesController.instance.createExercise(userId);
                  },
                  style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.green)),
                  child: const Text('Egzersiz oluştur'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
