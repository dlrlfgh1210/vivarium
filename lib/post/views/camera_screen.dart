import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraScreen extends StatefulWidget {
  static const routeName = "camera";
  static const routeURL = "/camera";
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  bool _hasPermission = false;
  List<String> _deniedPermissions = [];
  bool _isSelfieMode = false;

  late final bool _noCamera = kDebugMode && Platform.isIOS;

  late final AnimationController _buttonAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 100),
  );

  late final _curve = CurvedAnimation(
    parent: _buttonAnimationController,
    curve: Curves.easeInOut,
  );

  late final Animation<double> _buttonAnimation =
      Tween(begin: 0.8, end: 1.0).animate(_curve);

  late CameraController _cameraController;

  @override
  void initState() {
    super.initState();
    if (!_noCamera) {
      initPermissions();
    } else {
      setState(() {
        _hasPermission = true;
      });
    }
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _buttonAnimationController.dispose();
    if (!_noCamera) {
      _cameraController.dispose();
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_noCamera) return;
    if (!_hasPermission) return;
    if (!_cameraController.value.isInitialized) return;

    if (state == AppLifecycleState.inactive) {
      _cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      initCamera();
    }
  }

  Future<void> initPermissions() async {
    final cameraPermission = await Permission.camera.request();

    final cameraDenied =
        cameraPermission.isDenied || cameraPermission.isPermanentlyDenied;

    if (!cameraDenied) {
      _hasPermission = true;
      await initCamera();
    } else {
      _deniedPermissions = [
        if (cameraDenied) "Camera",
      ];
    }
    setState(() {});
  }

  Future<void> initCamera() async {
    if (!mounted) return;

    final cameras = await availableCameras();

    if (cameras.isEmpty) {
      return;
    }

    _cameraController = CameraController(
      cameras[_isSelfieMode ? 1 : 0],
      ResolutionPreset.ultraHigh,
      enableAudio: false,
    );

    await _cameraController.initialize();
    await _cameraController.prepareForVideoRecording(); // for IOS

    setState(() {});
  }

  Future<void> _toggleSelfieMode() async {
    _isSelfieMode = !_isSelfieMode;
    await initCamera();
    setState(() {});
  }

  Future<void> _takePicture(TapDownDetails _) async {
    if (!_cameraController.value.isInitialized ||
        _cameraController.value.isTakingPicture) {
      return;
    }

    await _buttonAnimationController.forward();
    await _buttonAnimationController.reverse();
    final picture = await _cameraController.takePicture();

    if (!mounted) return;
    Navigator.of(context).pop([picture]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: !_hasPermission
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "잠시만 기다려 주세요...",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const CircularProgressIndicator.adaptive(),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "다음 권한을 부여하십시오:",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  _deniedPermissions.isEmpty
                      ? const SizedBox()
                      : Text(
                          "• ${_deniedPermissions.join(", ")}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                ],
              )
            : Stack(
                alignment: Alignment.center,
                children: [
                  if (!_noCamera && _cameraController.value.isInitialized)
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(36),
                        ),
                        child: CameraPreview(_cameraController),
                      ),
                    ),
                  Positioned(
                    top: 40,
                    left: 20,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Positioned(
                    bottom: 30,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const Icon(
                          Icons.flash_off,
                          color: Colors.white,
                        ),
                        ScaleTransition(
                          scale: _buttonAnimation,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                height: 60 + 16,
                                width: 60 + 16,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              Container(
                                height: 60 + 8,
                                width: 60 + 8,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              GestureDetector(
                                onTapDown: _takePicture,
                                child: Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _toggleSelfieMode(),
                          child: const Icon(
                            Icons.refresh,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
