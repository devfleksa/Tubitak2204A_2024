import 'package:camera/camera.dart';
import 'package:firebase_oa/utils/controllers/exercise_controller.dart';
import 'package:firebase_oa/utils/painters/pose_painter.dart';
import 'package:firebase_oa/view/home/patient/exercise/detector_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class PoseDetectorView extends StatefulWidget {
  const PoseDetectorView({
    super.key,
    required this.currentExerciseName,
    required this.reps,
    required this.minAngle,
    required this.id,
  });

  final String id;
  final String currentExerciseName;
  final int reps;
  final double minAngle;

  @override
  State<StatefulWidget> createState() => _PoseDetectorViewState();
}

class _PoseDetectorViewState extends State<PoseDetectorView> {
  final PoseDetector _poseDetector =
      PoseDetector(options: PoseDetectorOptions());
  final bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;
  PosePainter? _posePainter;
  final ExerciseController controller = Get.put(ExerciseController());

  var _cameraLensDirection = CameraLensDirection.front;

  @override
  void dispose() async {
    _poseDetector.close();
    super.dispose();
  }

  @override
  void initState() {
    controller.id.value = widget.id;
    controller.reps.value = widget.reps;
    controller.minAngle.value = widget.minAngle;
    controller.exerciseName.value = widget.currentExerciseName;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DetectorView(
      posePainter: _posePainter,
      title: 'Pose Detector',
      customPaint: _customPaint,
      text: _text,
      onImage: _processImage,
      initialCameraLensDirection: _cameraLensDirection,
      onCameraLensDirectionChanged: (value) => _cameraLensDirection = value,
    );
  }

  Future<void> _processImage(InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    setState(() {
      _text = '';
    });

    final poses = await _poseDetector.processImage(inputImage);

    controller.fallDetection(poses);

    if (widget.currentExerciseName == 'Sağ Kalça-Abdüksiyon') {
      controller.hipAbduction(poses, 'right');
    } else if (widget.currentExerciseName == 'Sol Kalça-Abdüksiyon') {
      controller.hipAbduction(poses, 'left');
    } else if (widget.currentExerciseName == 'Sağ Kalça-Hiperekstansiyon') {
      controller.hipHyperextension(poses, 'right');
    } else if (widget.currentExerciseName == 'Sol Kalça-Hiperekstansiyon') {
      controller.hipHyperextension(poses, 'left');
    } else if (widget.currentExerciseName == 'Sağ Kalça-Ekstansiyon') {
      controller.hipExtension(poses, 'right');
    } else if (widget.currentExerciseName == 'Sol Kalça-Ekstansiyon') {
      controller.hipExtension(poses, 'left');
    } else if (widget.currentExerciseName == 'Sağ Diz-Fleksiyon') {
      controller.kneeFlexion(poses, 'right');
    } else if (widget.currentExerciseName == 'Sol Diz-Fleksiyon') {
      controller.kneeFlexion(poses, 'left');
    }

    if (inputImage.metadata?.size != null &&
        inputImage.metadata?.rotation != null) {
      final painter = PosePainter(
        poses,
        inputImage.metadata!.size,
        inputImage.metadata!.rotation,
        _cameraLensDirection,
      );

      _customPaint = CustomPaint(painter: painter);
      _posePainter = painter;
    } else {
      _text = 'Poses found: ${poses.length}\n\n';
      _customPaint = null;
    }
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }
}
