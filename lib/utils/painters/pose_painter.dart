import 'package:camera/camera.dart';
import 'package:firebase_oa/utils/painters/coordinates_translator.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class PosePainter extends CustomPainter {
  PosePainter(
    this.poses,
    this.imageSize,
    this.rotation,
    this.cameraLensDirection,
  );

  final List<Pose> poses;
  final Size imageSize;
  final InputImageRotation rotation;
  final CameraLensDirection cameraLensDirection;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..color = Colors.white;

    for (final pose in poses) {
      pose.landmarks.forEach(
        (_, landmark) {
          final Offset point = Offset(
            translateX(
              landmark.x,
              size,
              imageSize,
              rotation,
              cameraLensDirection,
            ),
            translateY(
              landmark.y,
              size,
              imageSize,
              rotation,
              cameraLensDirection,
            ),
          );
          canvas.drawCircle(point, 1.08, paint);
        },
      );
    }
  }

  @override
  bool shouldRepaint(covariant PosePainter oldDelegate) {
    return oldDelegate.imageSize != imageSize || oldDelegate.poses != poses;
  }
}
