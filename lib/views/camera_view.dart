import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:test_1/models/pose_model.dart';
import 'package:test_1/views/splash/splash_view.dart';
import 'package:test_1/views/statics/statistics_view.dart';
import 'package:wakelock/wakelock.dart';
import '../painters/pose_painter.dart';
import '../utils.dart' as utils;

class CameraView extends StatefulWidget {
  const CameraView(
      {Key? key,
      required this.posePainter,
      required this.customPaint,
      required this.onImage,
      this.onCameraFeedReady,
      this.onDetectorViewModeChanged,
      this.onCameraLensDirectionChanged,
      this.initialCameraLensDirection = CameraLensDirection.front,
      required this.currentPoseName})
      : super(key: key);
  final PosePainter? posePainter;
  final CustomPaint? customPaint;
  final Function(InputImage inputImage) onImage;
  final VoidCallback? onCameraFeedReady;
  final VoidCallback? onDetectorViewModeChanged;
  final Function(CameraLensDirection direction)? onCameraLensDirectionChanged;
  final CameraLensDirection initialCameraLensDirection;
  final String currentPoseName;

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  static List<CameraDescription> _cameras = [];
  CameraController? _controller;
  int _cameraIndex = -1;
  double _currentZoomLevel = 1.0;
  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;
  double _minAvailableExposureOffset = 0.0;
  double _maxAvailableExposureOffset = 0.0;
  double _currentExposureOffset = 0.0;
  bool _changingCameraLens = false;

  PoseLandmark? p1;
  PoseLandmark? p2;
  PoseLandmark? p3;
  PoseLandmark? p4;
  PoseLandmark? p5;
  PoseLandmark? p6;
  PoseLandmark? p7;
  PoseLandmark? p8;

  @override
  void initState() {
    super.initState();

    _initialize();
  }

  void _initialize() async {
    Wakelock.enable();
    if (_cameras.isEmpty) {
      _cameras = await availableCameras();
    }
    for (var i = 0; i < _cameras.length; i++) {
      if (_cameras[i].lensDirection == widget.initialCameraLensDirection) {
        _cameraIndex = i;
        break;
      }
    }
    if (_cameraIndex != -1) {
      _startLiveFeed();
    }
  }

  @override
  void didUpdateWidget(covariant CameraView oldWidget) {
    final PoseController controller = Get.find<PoseController>();

    for (final pose in widget.posePainter!.poses) {
      PoseLandmark getPseLandmark(PoseLandmarkType type1) {
        final PoseLandmark joint1 = pose.landmarks[type1]!;
        return joint1;
      }

      p5 = getPseLandmark(PoseLandmarkType.rightHip);
      p6 = getPseLandmark(PoseLandmarkType.leftHip);
      p7 = getPseLandmark(PoseLandmarkType.rightShoulder);
      p8 = getPseLandmark(PoseLandmarkType.leftShoulder);
    }

    //Fall Detection
    if (p5 != null && p6 != null && p7 != null && p8 != null) {
      controller.trunkAngle.value =
          utils.calculateTrunkAngle(p8!, p7!, p6!, p5!);
      if (controller.trunkAngle.value > 45) {
        controller.falling.value = true;
        if (controller.trunkAngle.value > 55) {
          controller.falling.value = true;
          utils.pushNotificaiton();
        } else {
          controller.falling.value = false;
        }
      } else if (controller.trunkAngle.value < 45) {
        controller.falling.value = false;
      }
    }

    if (widget.currentPoseName == 'Sol Kalça-Abdüksiyon') {
      for (final pose in widget.posePainter!.poses) {
        PoseLandmark getPseLandmark(PoseLandmarkType type1) {
          final PoseLandmark joint1 = pose.landmarks[type1]!;
          return joint1;
        }

        p1 = getPseLandmark(PoseLandmarkType.rightHip);
        p2 = getPseLandmark(PoseLandmarkType.leftHip);
        p3 = getPseLandmark(PoseLandmarkType.leftAnkle);
        p4 = getPseLandmark(PoseLandmarkType.leftKnee);
      }
      if (p1 != null && p2 != null && p3 != null && p4 != null) {
        controller.rtAngle.value = utils.angle(p1!, p2!, p3!);
        controller.legStraight.value = utils.isLegStraight(p2!, p4!, p3!);

        if (controller.rtAngle.value < 90) {
          controller.currentState.value = PoseState.down;
        } else if (controller.rtAngle.value > 130 &&
            controller.legStraight.value) {
          if (controller.maxAngle.value == 0.0 ||
              controller.rtAngle.value > controller.maxAngle.value) {
            controller.maxAngle.value = controller.rtAngle.value;
          }
        }
        if (controller.rtAngle.value > 130 &&
            controller.currentState.value == PoseState.down &&
            controller.maxAngle.value != 0.0 &&
            controller.legStraight.value) {
          controller.currentState.value = PoseState.up;
          controller.addMaxAngle(controller.maxAngle.value - 90);
          controller.maxAngle.value = 0.0;
          controller.decreaseCounter();
        }
        if (controller.counter.value == 0) {
          Get.off(
            const StaticsView(),
            arguments: {
              'name': widget.currentPoseName,
            },
          );
        }
      }
    } else if (widget.currentPoseName == 'Sağ Kalça-Abdüksiyon') {
      for (final pose in widget.posePainter!.poses) {
        PoseLandmark getPseLandmark(PoseLandmarkType type1) {
          final PoseLandmark joint1 = pose.landmarks[type1]!;
          return joint1;
        }

        p1 = getPseLandmark(PoseLandmarkType.leftHip);
        p2 = getPseLandmark(PoseLandmarkType.rightHip);
        p3 = getPseLandmark(PoseLandmarkType.rightAnkle);
        p4 = getPseLandmark(PoseLandmarkType.rightKnee);
      }

      if (p1 != null && p2 != null && p3 != null && p4 != null) {
        controller.rtAngle.value = utils.angle(p1!, p2!, p3!);
        controller.legStraight.value = utils.isLegStraight(p2!, p4!, p3!);

        if (controller.rtAngle.value < 90) {
          controller.currentState.value = PoseState.down;
        } else if (controller.rtAngle.value > 130 &&
            controller.legStraight.value) {
          if (controller.maxAngle.value == 0.0 ||
              controller.rtAngle.value > controller.maxAngle.value) {
            controller.maxAngle.value = controller.rtAngle.value;
          }
        }

        if (controller.rtAngle.value > 130 &&
            controller.currentState.value == PoseState.down &&
            controller.maxAngle.value != 0.0 &&
            controller.legStraight.value) {
          controller.currentState.value = PoseState.up;
          controller.addMaxAngle(controller.maxAngle.value - 90);
          controller.maxAngle.value = 0.0;
          controller.decreaseCounter();
        }

        if (controller.counter.value == 0) {
          Get.off(
            const StaticsView(),
            arguments: {
              'name': widget.currentPoseName,
            },
          );
        }
      }
    } else if (widget.currentPoseName == 'Sağ Kalça-Hiperekstansiyon') {
      for (final pose in widget.posePainter!.poses) {
        PoseLandmark getPseLandmark(PoseLandmarkType type1) {
          final PoseLandmark joint1 = pose.landmarks[type1]!;
          return joint1;
        }

        p1 = getPseLandmark(PoseLandmarkType.rightHip);
        p2 = getPseLandmark(PoseLandmarkType.rightKnee);
        p3 = getPseLandmark(PoseLandmarkType.rightAnkle);
        p4 = getPseLandmark(PoseLandmarkType.leftAnkle);
      }

      if (p1 != null && p2 != null && p3 != null && p4 != null) {
        Landmark verticalPoint = Landmark(p1!.x, p1!.y + 10);
        controller.rtAngle.value = utils.rangle(p3!, p1!, verticalPoint);
        controller.legStraight.value = utils.isLegStraight(p1!, p2!, p3!);

        if (controller.rtAngle.value < 1) {
          controller.currentState.value = PoseState.down;
        } else if (controller.rtAngle.value > 15 &&
            controller.legStraight.value) {
          if (controller.maxAngle.value == 0.0 ||
              controller.rtAngle.value > controller.maxAngle.value) {
            controller.maxAngle.value = controller.rtAngle.value;
          }
        }

        if (controller.rtAngle.value > 15 &&
            controller.currentState.value == PoseState.down &&
            controller.maxAngle.value != 0.0 &&
            controller.legStraight.value) {
          controller.currentState.value = PoseState.up;
          controller.addMaxAngle(controller.maxAngle.value);
          controller.maxAngle.value = 0.0;
          controller.decreaseCounter();
        }

        if (controller.counter.value == 0) {
          Get.off(
            const StaticsView(),
            arguments: {
              'name': widget.currentPoseName,
            },
          );
        }
      }
    } else if (widget.currentPoseName == 'Sol Kalça-Hiperekstansiyon') {
      for (final pose in widget.posePainter!.poses) {
        PoseLandmark getPseLandmark(PoseLandmarkType type1) {
          final PoseLandmark joint1 = pose.landmarks[type1]!;
          return joint1;
        }

        p1 = getPseLandmark(PoseLandmarkType.leftHip);
        p2 = getPseLandmark(PoseLandmarkType.leftKnee);
        p3 = getPseLandmark(PoseLandmarkType.leftAnkle);
        p4 = getPseLandmark(PoseLandmarkType.rightAnkle);
      }

      if (p1 != null && p2 != null && p3 != null && p4 != null) {
        Landmark verticalPoint = Landmark(p1!.x, p1!.y + 10);
        controller.rtAngle.value = utils.rangle(p3!, p1!, verticalPoint);
        controller.legStraight.value = utils.isLegStraight(p1!, p2!, p3!);
        if (controller.rtAngle.value < 1) {
          controller.currentState.value = PoseState.down;
        } else if (controller.rtAngle.value > 15 &&
            controller.legStraight.value) {
          if (controller.maxAngle.value == 0.0 ||
              controller.rtAngle.value > controller.maxAngle.value) {
            controller.maxAngle.value = controller.rtAngle.value;
          }
        }
        if (controller.rtAngle.value > 15 &&
            controller.currentState.value == PoseState.down &&
            controller.maxAngle.value != 0.0 &&
            controller.legStraight.value) {
          controller.currentState.value = PoseState.up;
          controller.addMaxAngle(controller.maxAngle.value);
          controller.maxAngle.value = 0.0;
          controller.decreaseCounter();
        }

        if (controller.counter.value == 0) {
          Get.off(
            const StaticsView(),
            arguments: {
              'name': widget.currentPoseName,
            },
          );
        }
      }
    } else if (widget.currentPoseName == 'Sağ Kalça-Ekstansiyon') {
      for (final pose in widget.posePainter!.poses) {
        PoseLandmark getPseLandmark(PoseLandmarkType type1) {
          final PoseLandmark joint1 = pose.landmarks[type1]!;
          return joint1;
        }

        p1 = getPseLandmark(PoseLandmarkType.rightHip);
        p2 = getPseLandmark(PoseLandmarkType.rightKnee);
        p3 = getPseLandmark(PoseLandmarkType.rightAnkle);
        p4 = getPseLandmark(PoseLandmarkType.leftAnkle);
      }

      if (p1 != null && p2 != null && p3 != null && p4 != null) {
        Landmark verticalPoint = Landmark(p1!.x, p1!.y + 10);
        controller.rtAngle.value = utils.rangle(p3!, p1!, verticalPoint);
        controller.legStraight.value = utils.isLegStraight(p1!, p2!, p3!);
        if (controller.rtAngle.value < 1) {
          controller.currentState.value = PoseState.down;
        } else if (controller.rtAngle.value > 40 &&
            controller.legStraight.value) {
          if (controller.maxAngle.value == 0.0 ||
              controller.rtAngle.value > controller.maxAngle.value) {
            controller.maxAngle.value = controller.rtAngle.value;
          }
        }
        if (controller.rtAngle.value > 40 &&
            controller.currentState.value == PoseState.down &&
            controller.maxAngle.value != 0.0 &&
            controller.legStraight.value) {
          controller.currentState.value = PoseState.up;
          controller.addMaxAngle(controller.maxAngle.value);
          controller.maxAngle.value = 0.0;
          controller.decreaseCounter();
        }

        if (controller.counter.value == 0) {
          Get.off(
            const StaticsView(),
            arguments: {
              'name': widget.currentPoseName,
            },
          );
        }
      }
    } else if (widget.currentPoseName == 'Sol Kalça-Ekstansiyon') {
      for (final pose in widget.posePainter!.poses) {
        PoseLandmark getPseLandmark(PoseLandmarkType type1) {
          final PoseLandmark joint1 = pose.landmarks[type1]!;
          return joint1;
        }

        p1 = getPseLandmark(PoseLandmarkType.leftHip);
        p2 = getPseLandmark(PoseLandmarkType.leftKnee);
        p3 = getPseLandmark(PoseLandmarkType.leftAnkle);
        p4 = getPseLandmark(PoseLandmarkType.rightAnkle);
      }

      if (p1 != null && p2 != null && p3 != null && p4 != null) {
        Landmark verticalPoint = Landmark(p1!.x, p1!.y + 10);
        controller.rtAngle.value = utils.rangle(p3!, p1!, verticalPoint);
        controller.legStraight.value = utils.isLegStraight(p1!, p2!, p3!);

        if (controller.rtAngle.value < 1) {
          controller.currentState.value = PoseState.down;
        } else if (controller.rtAngle.value > 40 &&
            controller.legStraight.value) {
          if (controller.maxAngle.value == 0.0 ||
              controller.rtAngle.value > controller.maxAngle.value) {
            controller.maxAngle.value = controller.rtAngle.value;
          }
        }

        if (controller.rtAngle.value > 40 &&
            controller.currentState.value == PoseState.down &&
            controller.maxAngle.value != 0.0 &&
            controller.legStraight.value) {
          controller.currentState.value = PoseState.up;
          controller.addMaxAngle(controller.maxAngle.value);
          controller.maxAngle.value = 0.0;
          controller.decreaseCounter();
        }

        if (controller.counter.value == 0) {
          Get.off(
            const StaticsView(),
            arguments: {
              'name': widget.currentPoseName,
            },
          );
        }
      }
    } else if (widget.currentPoseName == 'Sağ Diz-Fleksiyon') {
      for (final pose in widget.posePainter!.poses) {
        PoseLandmark getPseLandmark(PoseLandmarkType type1) {
          final PoseLandmark joint1 = pose.landmarks[type1]!;
          return joint1;
        }

        p1 = getPseLandmark(PoseLandmarkType.rightHip);
        p2 = getPseLandmark(PoseLandmarkType.rightKnee);
        p3 = getPseLandmark(PoseLandmarkType.rightAnkle);
      }

      if (p1 != null && p2 != null && p3 != null) {
        controller.rtAngle.value = utils.angle(p1!, p2!, p3!);

        if (controller.rtAngle.value < 90) {
          controller.currentState.value = PoseState.down;
        } else if (controller.rtAngle.value > 175) {
          if (controller.maxAngle.value == 0.0 ||
              controller.rtAngle.value > controller.maxAngle.value) {
            controller.maxAngle.value = controller.rtAngle.value;
          }
        }

        if (controller.rtAngle.value > 175 &&
            controller.currentState.value == PoseState.down &&
            controller.maxAngle.value != 0.0) {
          controller.currentState.value = PoseState.up;
          controller.addMaxAngle(controller.maxAngle.value);
          controller.maxAngle.value = 0.0;
          controller.decreaseCounter();
        }

        if (controller.counter.value == 0) {
          Get.off(
            const StaticsView(),
            arguments: {
              'name': widget.currentPoseName,
            },
          );
        }
      }
    } else if (widget.currentPoseName == 'Sol Diz-Fleksiyon') {
      for (final pose in widget.posePainter!.poses) {
        PoseLandmark getPseLandmark(PoseLandmarkType type1) {
          final PoseLandmark joint1 = pose.landmarks[type1]!;
          return joint1;
        }

        p1 = getPseLandmark(PoseLandmarkType.leftHip);
        p2 = getPseLandmark(PoseLandmarkType.leftKnee);
        p3 = getPseLandmark(PoseLandmarkType.leftAnkle);
      }

      if (p1 != null && p2 != null && p3 != null && p4 != null) {
        controller.rtAngle.value = utils.angle(p1!, p2!, p3!);
        if (controller.rtAngle.value < 90) {
          controller.currentState.value = PoseState.down;
        } else if (controller.rtAngle.value > 175 &&
            controller.legStraight.value) {
          if (controller.maxAngle.value == 0.0 ||
              controller.rtAngle.value > controller.maxAngle.value) {
            controller.maxAngle.value = controller.rtAngle.value;
          }
        }
        if (controller.rtAngle.value > 175 &&
            controller.currentState.value == PoseState.down &&
            controller.maxAngle.value != 0.0 &&
            controller.legStraight.value) {
          controller.currentState.value = PoseState.up;
          controller.addMaxAngle(controller.maxAngle.value);
          controller.maxAngle.value = 0.0;
          controller.decreaseCounter();
        }

        if (controller.counter.value == 0) {
          Get.off(
            const StaticsView(),
            arguments: {
              'name': widget.currentPoseName,
            },
          );
        }
      }
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    Wakelock.disable();
    _stopLiveFeed();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _liveFeedBody());
  }

  Widget _liveFeedBody() {
    if (_cameras.isEmpty) return Container();
    if (_controller == null) return Container();
    if (_controller?.value.isInitialized == false) return Container();
    return Container(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Center(
            child: _changingCameraLens
                ? const Center(
                    child: Text('Changing camera lens'),
                  )
                : CameraPreview(
                    _controller!,
                    child: widget.customPaint,
                  ),
          ),
          _realTimeAngle(),
          _isLegStraight(),
          _counterWidget(),
          _backButton(),
          _switchLiveCameraToggle(),
          // _zoomControl(),
        ],
      ),
    );
  }

  Widget _counterWidget() {
    return Positioned(
      left: 0,
      top: 50,
      right: 0,
      child: GetBuilder<PoseController>(
        builder: (controller) => SizedBox(
          width: 70,
          child: Column(
            children: [
              Obx(
                () => Text(
                  controller.maxAngle.value.toStringAsFixed(2),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              Container(
                width: 70,
                decoration: BoxDecoration(
                  color: Colors.black54,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.4),
                    width: 4.0,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
                child: Obx(() => Text(
                      '${controller.counter.value}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _realTimeAngle() {
    return Positioned(
      bottom: 50,
      left: 30,
      child: GetBuilder<PoseController>(
        builder: (controller) => Obx(
          () => Text(
            'trunkAngle:${controller.trunkAngle.value.toStringAsFixed(0)} falling${controller.falling.value.toString()}', //Açı :${controller.rtAngle.value.toStringAsFixed(0)}
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _isLegStraight() {
    return Positioned(
      top: 50,
      right: 30,
      child: GetBuilder<PoseController>(
        builder: (controller) => SizedBox(
          width: 80,
          child: Column(
            children: [
              const Text(
                'Bacak düz mü ?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Obx(
                () => SizedBox(
                  height: 50,
                  width: 50,
                  child: Image.asset(
                    controller.legStraight.value
                        ? 'assets/true.png'
                        : 'assets/false.png',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _isFallDetected() {
    return Positioned(
      top: 120,
      right: 30,
      child: GetBuilder<PoseController>(
        builder: (controller) => SizedBox(
          width: 80,
          child: Column(
            children: [
              const Text(
                'Düşüyor mu ?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 50,
                width: 50,
                child: Image.asset(
                  controller.falling.value
                      ? 'assets/true.png'
                      : 'assets/false.png',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _backButton() => Positioned(
        top: 40,
        left: 8,
        child: SizedBox(
          height: 50.0,
          width: 50.0,
          child: FloatingActionButton(
            heroTag: Object(),
            onPressed: () {
              Get.find<PoseController>().resetCounter();
              Get.offAll(const SplashScreen());
            },
            backgroundColor: Colors.black54,
            child: const Icon(
              Icons.arrow_back_ios_outlined,
              size: 20,
            ),
          ),
        ),
      );

  Widget _switchLiveCameraToggle() => Positioned(
        bottom: 8,
        right: 8,
        child: SizedBox(
          height: 50.0,
          width: 50.0,
          child: FloatingActionButton(
            heroTag: Object(),
            onPressed: _switchLiveCamera,
            backgroundColor: Colors.black54,
            child: Icon(
              Platform.isIOS
                  ? Icons.flip_camera_ios_outlined
                  : Icons.flip_camera_android_outlined,
              size: 25,
            ),
          ),
        ),
      );

  Widget _zoomControl() => Positioned(
        bottom: 16,
        left: 0,
        right: 0,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: 250,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Slider(
                    value: _currentZoomLevel,
                    min: _minAvailableZoom,
                    max: _maxAvailableZoom,
                    activeColor: Colors.white,
                    inactiveColor: Colors.white30,
                    onChanged: (value) async {
                      setState(() {
                        _currentZoomLevel = value;
                      });
                      await _controller?.setZoomLevel(value);
                    },
                  ),
                ),
                Container(
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        '${_currentZoomLevel.toStringAsFixed(1)}x',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Future _startLiveFeed() async {
    final camera = _cameras[_cameraIndex];
    _controller = CameraController(
      camera,
      // Set to ResolutionPreset.high. Do NOT set it to ResolutionPreset.max because for some phones does NOT work.
      ResolutionPreset.high, //do not change to max stay high
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );
    _controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }
      _controller?.getMinZoomLevel().then((value) {
        _currentZoomLevel = value;
        _minAvailableZoom = value;
      });
      _controller?.getMaxZoomLevel().then((value) {
        _maxAvailableZoom = value;
      });
      _currentExposureOffset = 0.0;
      _controller?.getMinExposureOffset().then((value) {
        _minAvailableExposureOffset = value;
      });
      _controller?.getMaxExposureOffset().then((value) {
        _maxAvailableExposureOffset = value;
      });
      _controller?.startImageStream(_processCameraImage).then((value) {
        if (widget.onCameraFeedReady != null) {
          widget.onCameraFeedReady!();
        }
        if (widget.onCameraLensDirectionChanged != null) {
          widget.onCameraLensDirectionChanged!(camera.lensDirection);
        }
      });
      setState(() {});
    });
  }

  Future _stopLiveFeed() async {
    await _controller?.stopImageStream();
    await _controller?.dispose();
    _controller = null;
  }

  Future _switchLiveCamera() async {
    setState(() => _changingCameraLens = true);
    _cameraIndex = (_cameraIndex + 1) % _cameras.length;

    await _stopLiveFeed();
    await _startLiveFeed();
    setState(() => _changingCameraLens = false);
  }

  void _processCameraImage(CameraImage image) {
    final inputImage = _inputImageFromCameraImage(image);
    if (inputImage == null) return;
    widget.onImage(inputImage);
  }

  final _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  InputImage? _inputImageFromCameraImage(CameraImage image) {
    if (_controller == null) return null;

    // get image rotation
    final camera = _cameras[_cameraIndex];
    final sensorOrientation = camera.sensorOrientation;
    // print(
    //     'lensDirection: ${camera.lensDirection}, sensorOrientation: $sensorOrientation, ${_controller?.value.deviceOrientation} ${_controller?.value.lockedCaptureOrientation} ${_controller?.value.isCaptureOrientationLocked}');
    InputImageRotation? rotation;
    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (Platform.isAndroid) {
      var rotationCompensation =
          _orientations[_controller!.value.deviceOrientation];
      if (rotationCompensation == null) return null;
      if (camera.lensDirection == CameraLensDirection.front) {
        // front-facing
        rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
      } else {
        // back-facing
        rotationCompensation =
            (sensorOrientation - rotationCompensation + 360) % 360;
      }
      rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
      // print('rotationCompensation: $rotationCompensation');
    }
    if (rotation == null) return null;
    // print('final rotation: $rotation');

    // get image format
    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    // validate format depending on platform
    // only supported formats:
    // * nv21 for Android
    // * bgra8888 for iOS
    if (format == null ||
        (Platform.isAndroid && format != InputImageFormat.nv21) ||
        (Platform.isIOS && format != InputImageFormat.bgra8888)) return null;

    // since format is constraint to nv21 or bgra8888, both only have one plane
    if (image.planes.length != 1) return null;
    final plane = image.planes.first;

    // compose InputImage using bytes
    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation, // used only in Android
        format: format, // used only in iOS
        bytesPerRow: plane.bytesPerRow, // used only in iOS
      ),
    );
  }
}

class Landmark {
  double x;
  double y;

  Landmark(this.x, this.y);
}
