import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:test_1/painters/coordinates_translator.dart';
import '../utils.dart' as utils;

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

  PoseLandmark? _p1;
  PoseLandmark? _p2;
  PoseLandmark? _p3;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..color = Colors.blue;

    final leftPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.white;

    final rightPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.white;

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    for (final pose in poses) {
      pose.landmarks.forEach((_, landmark) {
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

        PoseLandmark getPoseLandmark(PoseLandmarkType type1) {
          final PoseLandmark joint1 = pose.landmarks[type1]!;
          return joint1;
        }

        _p1 = getPoseLandmark(PoseLandmarkType.rightHip);
        _p2 = getPoseLandmark(PoseLandmarkType.leftHip);
        _p3 = getPoseLandmark(PoseLandmarkType.leftAnkle);

        if (_p1 != null && _p2 != null && _p3 != null) {
          final rtaAngle = utils.angle(_p1!, _p2!, _p3!);

          textPainter.text = TextSpan(
            text: 'Angle: ${rtaAngle.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.red,
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
            ),
          );

          textPainter.layout();

          // Sağ dirsek üzerinde açıyı çiz
          final offset = Offset(
            translateX(
              _p2!.x,
              size,
              imageSize,
              rotation,
              cameraLensDirection,
            ),
            translateY(
              _p2!.y,
              size,
              imageSize,
              rotation,
              cameraLensDirection,
            ),
          );
          textPainter.paint(canvas, offset + const Offset(12, 12));
        }

        // Eklenen kısım: her bir noktanın yanına koordinatları yazdırma

        // textPainter.text = TextSpan(
        //   text:
        //       '(${landmark.x.toStringAsFixed(2)}, ${landmark.y.toStringAsFixed(2)})',
        //   style: const TextStyle(
        //     color: Colors.red,
        //     fontSize: 10.0,
        //   ),
        // );
        // textPainter.layout();
        // textPainter.paint(canvas, point + const Offset(12, 12));
      });

      void paintLine(
          PoseLandmarkType type1, PoseLandmarkType type2, Paint paintType) {
        final PoseLandmark joint1 = pose.landmarks[type1]!;
        final PoseLandmark joint2 = pose.landmarks[type2]!;
        canvas.drawLine(
            Offset(
                translateX(
                  joint1.x,
                  size,
                  imageSize,
                  rotation,
                  cameraLensDirection,
                ),
                translateY(
                  joint1.y,
                  size,
                  imageSize,
                  rotation,
                  cameraLensDirection,
                )),
            Offset(
                translateX(
                  joint2.x,
                  size,
                  imageSize,
                  rotation,
                  cameraLensDirection,
                ),
                translateY(
                  joint2.y,
                  size,
                  imageSize,
                  rotation,
                  cameraLensDirection,
                )),
            paintType);
      }

      // Draw arms
      paintLine(
          PoseLandmarkType.leftShoulder, PoseLandmarkType.leftElbow, leftPaint);
      paintLine(
          PoseLandmarkType.leftElbow, PoseLandmarkType.leftWrist, leftPaint);
      paintLine(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow,
          rightPaint);
      paintLine(
          PoseLandmarkType.rightElbow, PoseLandmarkType.rightWrist, rightPaint);

      //Draw Body
      paintLine(
          PoseLandmarkType.leftShoulder, PoseLandmarkType.leftHip, leftPaint);
      paintLine(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip,
          rightPaint);

      //Draw legs
      paintLine(PoseLandmarkType.leftHip, PoseLandmarkType.leftKnee, leftPaint);
      paintLine(
          PoseLandmarkType.leftKnee, PoseLandmarkType.leftAnkle, leftPaint);
      paintLine(
          PoseLandmarkType.rightHip, PoseLandmarkType.rightKnee, rightPaint);
      paintLine(
          PoseLandmarkType.rightKnee, PoseLandmarkType.rightAnkle, rightPaint);
    }
  }

  @override
  bool shouldRepaint(covariant PosePainter oldDelegate) {
    return oldDelegate.imageSize != imageSize || oldDelegate.poses != poses;
  }
}
