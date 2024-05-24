import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_oa/utils/utils.dart';
import 'package:firebase_oa/view/home/patient/exercise_stats.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

import 'dart:math' as math;

enum PoseState { idle, down, up }

class ExerciseController extends GetxController {
  static ExerciseController get instance => Get.find();

  late final AudioPlayer player;
  RxString id = ''.obs;
  RxString exerciseName = 'Sol Kalça-Abdüksiyon'.obs;
  RxInt reps = 5.obs;
  RxDouble minAngle = 115.0.obs;
  RxDouble maxAngle = 0.0.obs;
  RxDouble rtAngle = 0.0.obs;

  RxBool isInFrame = false.obs;
  RxBool legStraight = false.obs;

  RxBool falling = false.obs;
  RxDouble trunkAngle = 0.0.obs;

  RxList<double> maxAnglesList = <double>[].obs;

  var currentState = PoseState.down.obs;

  @override
  void onInit() {
    super.onInit();
    player = AudioPlayer();
    player.setReleaseMode(ReleaseMode.stop);
  }

  double get averageAngle {
    if (maxAnglesList.isEmpty) {
      return 0;
    }
    double total = maxAnglesList.fold(0, (sum, item) => sum + item);
    return total / maxAnglesList.length;
  }

  void emptyMaxAnglesList() => maxAnglesList = <double>[].obs;

  void addMaxAngle(double angle) => maxAnglesList.add(angle);

  void setPoseState(PoseState state) => currentState.value = state;

  void chechkFalling(
    PoseLandmark leftShoulder,
    PoseLandmark rightShoulder,
    PoseLandmark leftHip,
    PoseLandmark rightHip,
  ) {
    trunkAngle.value =
        calculateTrunkAngle(leftShoulder, rightShoulder, leftHip, rightHip);
    if (trunkAngle.value > 45) {
      falling.value = true;
      if (trunkAngle.value > 55) {
        falling.value = true;
      } else {
        falling.value = false;
      }
    } else if (trunkAngle.value < 45) {
      falling.value = false;
    }
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

  bool isUserInFrame(List<Pose> poses, double threshold) {
    List<int> keyPointsToCheck = [
      0, // nose
      11, // left shoulder
      12, // right shoulder
      23, // left hip
      24, // right hip
      15, // left wrist
      16, // right wrist
      27, // left ankle
      28 // right ankle
    ];

    for (var pose in poses) {
      List<PoseLandmark> landmarks = pose.landmarks.values.toList();

      bool allKeyPointsPresent = true;
      for (var index in keyPointsToCheck) {
        if (index >= landmarks.length ||
            landmarks[index].likelihood < threshold) {
          allKeyPointsPresent = false;
          break;
        }
      }

      if (allKeyPointsPresent) {
        return true;
      }
    }

    return false;
  }

  void fallDetection(
    List<Pose> poses,
  ) {
    PoseLandmark? p1;
    PoseLandmark? p2;
    PoseLandmark? p3;
    PoseLandmark? p4;

    for (final pose in poses) {
      PoseLandmark getLandmarks(PoseLandmarkType type) {
        return pose.landmarks[type]!;
      }

      p1 = getLandmarks(PoseLandmarkType.leftShoulder);
      p2 = getLandmarks(PoseLandmarkType.rightShoulder);
      p3 = getLandmarks(PoseLandmarkType.leftHip);
      p4 = getLandmarks(PoseLandmarkType.rightHip);
    }

    if (p1 != null && p2 != null && p3 != null && p4 != null) {
      chechkFalling(p1, p2, p3, p4);
    }
  }

  Future<void> hipAbduction(List<Pose> poses, String direction) async {
    PoseLandmark? p1;
    PoseLandmark? p2;
    PoseLandmark? p3;
    PoseLandmark? p4;

    if (direction == 'right') {
      for (final pose in poses) {
        PoseLandmark getLandmarks(PoseLandmarkType type) {
          return pose.landmarks[type]!;
        }

        p1 = getLandmarks(PoseLandmarkType.leftHip);
        p2 = getLandmarks(PoseLandmarkType.rightHip);
        p3 = getLandmarks(PoseLandmarkType.rightAnkle);
        p4 = getLandmarks(PoseLandmarkType.rightKnee);
      }
    } else if (direction == 'left') {
      for (final pose in poses) {
        PoseLandmark getLandmarks(PoseLandmarkType type) {
          return pose.landmarks[type]!;
        }

        p1 = getLandmarks(PoseLandmarkType.rightHip);
        p2 = getLandmarks(PoseLandmarkType.leftHip);
        p3 = getLandmarks(PoseLandmarkType.leftAnkle);
        p4 = getLandmarks(PoseLandmarkType.leftKnee);
      }
    }
    if (p1 != null && p2 != null && p3 != null && p4 != null) {
      rtAngle.value = angle(p1, p2, p3);
      legStraight.value = isLegStraight(p2, p4, p3);
      isInFrame.value = isUserInFrame(poses, 0.96);

      if (rtAngle.value < 90) {
        currentState.value = PoseState.down;
      } else if (rtAngle.value > minAngle.value + 90 &&
          legStraight.value &&
          isInFrame.value) {
        if (maxAngle.value == 0.0 || rtAngle.value > maxAngle.value) {
          maxAngle.value = rtAngle.value;
        }
      }
      if (rtAngle.value > minAngle.value + 90 &&
          currentState.value == PoseState.down &&
          maxAngle.value != 0.0 &&
          legStraight.value &&
          isInFrame.value) {
        currentState.value = PoseState.up;
        addMaxAngle(maxAngle.value - 90);
        maxAngle.value = 0.0;
        if (reps.value > 0) {
          await player.play(AssetSource('sounds/correct_sound_effect.mp3'),
              volume: 40.0);
          reps.value--;
          if (reps.value == 0) {
            Get.offAll(
              () => ExerciseStats(
                id: id.value,
                exerciseName: exerciseName.value,
                minAngle: minAngle.value,
                averageAngle: averageAngle,
                maxAnglesList: maxAnglesList,
              ),
            );
          }
        }
      }
    }
  }

  Future<void> hipHyperextension(List<Pose> poses, String direction) async {
    PoseLandmark? p1;
    PoseLandmark? p2;
    PoseLandmark? p3;
    PoseLandmark? p4;

    if (direction == 'right') {
      for (final pose in poses) {
        PoseLandmark getLandmarks(PoseLandmarkType type) {
          return pose.landmarks[type]!;
        }

        p1 = getLandmarks(PoseLandmarkType.rightHip);
        p2 = getLandmarks(PoseLandmarkType.rightKnee);
        p3 = getLandmarks(PoseLandmarkType.rightAnkle);
        p4 = getLandmarks(PoseLandmarkType.leftAnkle);
      }
    } else if (direction == 'left') {
      for (final pose in poses) {
        PoseLandmark getLandmarks(PoseLandmarkType type) {
          return pose.landmarks[type]!;
        }

        p1 = getLandmarks(PoseLandmarkType.leftHip);
        p2 = getLandmarks(PoseLandmarkType.leftKnee);
        p3 = getLandmarks(PoseLandmarkType.leftAnkle);
        p4 = getLandmarks(PoseLandmarkType.rightAnkle);
      }
    }
    if (p1 != null && p2 != null && p3 != null && p4 != null) {
      rtAngle.value = angle(p2, p1, p4);
      legStraight.value = isLegStraight(p1, p2, p3);
      isInFrame.value = isUserInFrame(poses, 0.80);

      if (rtAngle.value < 1) {
        currentState.value = PoseState.down;
      } else if (rtAngle.value > minAngle.value &&
          legStraight.value &&
          isInFrame.value) {
        if (maxAngle.value == 0.0 || rtAngle.value > maxAngle.value) {
          maxAngle.value = rtAngle.value;
        }
      }
      if (rtAngle.value > minAngle.value &&
          currentState.value == PoseState.down &&
          maxAngle.value != 0.0 &&
          legStraight.value &&
          isInFrame.value) {
        currentState.value = PoseState.up;
        addMaxAngle(maxAngle.value);
        maxAngle.value = 0.0;
        if (reps.value > 0) {
          await player.play(AssetSource('sounds/correct_sound_effect.mp3'),
              volume: 40.0);
          reps.value--;
          if (reps.value == 0) {
            Get.offAll(
              () => ExerciseStats(
                id: id.value,
                exerciseName: exerciseName.value,
                minAngle: minAngle.value,
                averageAngle: averageAngle,
                maxAnglesList: maxAnglesList,
              ),
            );
          }
        }
      }
    }
  }

  Future<void> hipExtension(List<Pose> poses, String direction) async {
    PoseLandmark? p1;
    PoseLandmark? p2;
    PoseLandmark? p3;
    PoseLandmark? p4;

    if (direction == 'right') {
      for (final pose in poses) {
        PoseLandmark getLandmarks(PoseLandmarkType type) {
          return pose.landmarks[type]!;
        }

        p1 = getLandmarks(PoseLandmarkType.rightHip);
        p2 = getLandmarks(PoseLandmarkType.rightKnee);
        p3 = getLandmarks(PoseLandmarkType.rightAnkle);
        p4 = getLandmarks(PoseLandmarkType.leftAnkle);
      }
    } else if (direction == 'left') {
      for (final pose in poses) {
        PoseLandmark getLandmarks(PoseLandmarkType type) {
          return pose.landmarks[type]!;
        }

        p1 = getLandmarks(PoseLandmarkType.leftHip);
        p2 = getLandmarks(PoseLandmarkType.leftKnee);
        p3 = getLandmarks(PoseLandmarkType.leftAnkle);
        p4 = getLandmarks(PoseLandmarkType.rightAnkle);
      }
    }
    if (p1 != null && p2 != null && p3 != null && p4 != null) {
      rtAngle.value = angle(p2, p1, p4);
      legStraight.value = isLegStraight(p1, p2, p3);
      isInFrame.value = isUserInFrame(poses, 0.80);
      if (rtAngle.value < 1) {
        currentState.value = PoseState.down;
      } else if (rtAngle.value > minAngle.value &&
          legStraight.value &&
          isInFrame.value) {
        if (maxAngle.value == 0.0 || rtAngle.value > maxAngle.value) {
          maxAngle.value = rtAngle.value;
        }
      }
      if (rtAngle.value > minAngle.value &&
          currentState.value == PoseState.down &&
          maxAngle.value != 0.0 &&
          legStraight.value &&
          isInFrame.value) {
        currentState.value = PoseState.up;
        addMaxAngle(maxAngle.value);
        maxAngle.value = 0.0;
        if (reps.value > 0) {
          await player.play(AssetSource('sounds/correct_sound_effect.mp3'),
              volume: 40.0);
          reps.value--;
          if (reps.value == 0) {
            Get.offAll(
              () => ExerciseStats(
                id: id.value,
                exerciseName: exerciseName.value,
                minAngle: minAngle.value,
                averageAngle: averageAngle,
                maxAnglesList: maxAnglesList,
              ),
            );
          }
        }
      }
    }
  }

  Future<void> kneeFlexion(List<Pose> poses, String direction) async {
    PoseLandmark? p1;
    PoseLandmark? p2;
    PoseLandmark? p3;

    if (direction == 'right') {
      for (final pose in poses) {
        PoseLandmark getLandmarks(PoseLandmarkType type) {
          return pose.landmarks[type]!;
        }

        p1 = getLandmarks(PoseLandmarkType.rightHip);
        p2 = getLandmarks(PoseLandmarkType.rightKnee);
        p3 = getLandmarks(PoseLandmarkType.rightAnkle);
      }
    } else if (direction == 'left') {
      for (final pose in poses) {
        PoseLandmark getLandmarks(PoseLandmarkType type) {
          return pose.landmarks[type]!;
        }

        p1 = getLandmarks(PoseLandmarkType.leftHip);
        p2 = getLandmarks(PoseLandmarkType.leftKnee);
        p3 = getLandmarks(PoseLandmarkType.leftAnkle);
      }
    }
    if (p1 != null && p2 != null && p3 != null) {
      rtAngle.value = angle(p1, p2, p3);
      isInFrame.value = isUserInFrame(poses, 0.80);

      if (rtAngle.value < 90) {
        currentState.value = PoseState.down;
      } else if (rtAngle.value > minAngle.value &&
          legStraight.value &&
          isInFrame.value) {
        if (maxAngle.value == 0.0 || rtAngle.value > maxAngle.value) {
          maxAngle.value = rtAngle.value;
        }
      }
      if (rtAngle.value > minAngle.value &&
          currentState.value == PoseState.down &&
          maxAngle.value != 0.0 &&
          legStraight.value &&
          isInFrame.value) {
        currentState.value = PoseState.up;
        addMaxAngle(maxAngle.value);
        maxAngle.value = 0.0;
        if (reps.value > 0) {
          await player.play(AssetSource('sounds/correct_sound_effect.mp3'),
              volume: 40.0);
          reps.value--;
          if (reps.value == 0) {
            Get.offAll(
              () => ExerciseStats(
                id: id.value,
                exerciseName: exerciseName.value,
                minAngle: minAngle.value,
                averageAngle: averageAngle,
                maxAnglesList: maxAnglesList,
              ),
            );
          }
        }
      }
    }
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
}
