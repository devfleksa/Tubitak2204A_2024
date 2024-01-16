import 'dart:io';
import 'dart:math' as math;
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:test_1/views/camera_view.dart';
import 'package:vector_math/vector_math.dart';

Future<String> getAssetPath(String asset) async {
  final path = await getLocalPath(asset);
  await Directory(dirname(path)).create(recursive: true);
  final file = File(path);
  if (!await file.exists()) {
    final byteData = await rootBundle.load(asset);
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
  }
  return file.path;
}

Future<String> getLocalPath(String path) async {
  return '${(await getApplicationSupportDirectory()).path}/$path';
}

double angle(
  PoseLandmark firstLandmark,
  PoseLandmark midLandmark,
  PoseLandmark lastLandmark,
) {
  final radians = math.atan2(
          lastLandmark.y - midLandmark.y, lastLandmark.x - midLandmark.x) -
      math.atan2(
          firstLandmark.y - midLandmark.y, firstLandmark.x - midLandmark.x);

  double degrees = radians * 180.0 / math.pi;

  degrees = degrees.abs();

  if (degrees > 180.0) {
    degrees = 360.0 - degrees;
  }
  return degrees;
}

double angleLandmarks(
  Landmark firstLandmark,
  Landmark midLandmark,
  Landmark lastLandmark,
) {
  final radians = math.atan2(
          lastLandmark.y - midLandmark.y, lastLandmark.x - midLandmark.x) -
      math.atan2(
          firstLandmark.y - midLandmark.y, firstLandmark.x - midLandmark.x);

  double degrees = radians * 180.0 / math.pi;

  degrees = degrees.abs();

  if (degrees > 180.0) {
    degrees = 360.0 - degrees;
  }
  return degrees;
}

double angle3D(
  PoseLandmark firstLandmark,
  PoseLandmark midLandmark,
  PoseLandmark lastLandmark,
) {
  // Vektörleri oluştur
  final Vector3 firstVector = Vector3(
    firstLandmark.x - midLandmark.x,
    firstLandmark.y - midLandmark.y,
    firstLandmark.z - midLandmark.z,
  );

  final Vector3 secondVector = Vector3(
    lastLandmark.x - midLandmark.x,
    lastLandmark.y - midLandmark.y,
    lastLandmark.z - midLandmark.z,
  );

  // Vektörlerin nokta çarpımını hesapla
  final double dotProduct = firstVector.dot(secondVector);

  // Vektörlerin büyüklüklerini hesapla
  final double magnitudeFirstVector = firstVector.length;
  final double magnitudeSecondVector = secondVector.length;

  // Kosinüs teoremi kullanarak açıyı hesapla (radyan cinsinden)
  final double angleRadians =
      acos(dotProduct / (magnitudeFirstVector * magnitudeSecondVector));

  // Açıyı dereceye çevir
  final double degrees = angleRadians * (180 / pi);

  return degrees;
}

bool isLegStraight(
  PoseLandmark hipLandmark,
  PoseLandmark kneeLandmark,
  PoseLandmark ankleLandmark,
) {
  double legAngle = angle(hipLandmark, kneeLandmark, ankleLandmark);

  if (legAngle > 170) {
    return true;
  } else {
    return false;
  }
}

Landmark calculateMidHip(
  PoseLandmark leftHip,
  PoseLandmark rightHip,
) {
  return Landmark((leftHip.x + rightHip.x) / 2, (leftHip.y + rightHip.y) / 2);
}

Landmark calculateMidShoulder(
  PoseLandmark leftShoulder,
  PoseLandmark rightShoulder,
) {
  return Landmark(
    (leftShoulder.x + rightShoulder.x) / 2,
    (leftShoulder.y + rightShoulder.y) / 2,
  );
}

double calculateTrunkAngle(
  PoseLandmark leftShoulder,
  PoseLandmark rightShoulder,
  PoseLandmark leftHip,
  PoseLandmark rightHip,
) {
  Landmark midShoulder = Landmark(
    (leftShoulder.x + rightShoulder.x) / 2,
    (leftShoulder.y + rightShoulder.y) / 2,
  );
  Landmark midHip = Landmark(
    (leftHip.x + rightHip.x) / 2,
    (leftHip.y + rightHip.y) / 2,
  );

  Landmark verticalPoint = Landmark(midHip.x, midHip.y - 10);

  double trunkAngle = angleLandmarks(midShoulder, midHip, verticalPoint);

  return trunkAngle;
}

double rangle(
  PoseLandmark firstLandmark,
  PoseLandmark midLandmark,
  Landmark lastLandmark,
) {
  final radians = math.atan2(
          lastLandmark.y - midLandmark.y, lastLandmark.x - midLandmark.x) -
      math.atan2(
          firstLandmark.y - midLandmark.y, firstLandmark.x - midLandmark.x);

  double degrees = radians * 180.0 / math.pi;

  degrees = degrees.abs();

  if (degrees > 180.0) {
    degrees = 360.0 - degrees;
  }
  return degrees;
}

void pushNotificaiton() {}
