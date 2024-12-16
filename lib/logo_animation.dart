import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LogoAnimationController extends GetxController {
  RxBool shouldAnimate = false.obs; // Controls the initial animation
  RxBool shouldShowText = false.obs; // Controls "GO" visibility
  RxBool circleVisible = true.obs; // Circle visibility control
  RxBool showButtonUI = false.obs; // Show button UI after "GO" click
  late Timer timer;

  @override
  void onInit() {
    super.onInit();
    _startAnimationTimer();
  }

  void _startAnimationTimer() {
    timer = Timer(const Duration(seconds: 1), () {
      shouldAnimate.value = true;
      shouldShowText.value = true;
    });
  }

  void transitionToButtonUI() {
    circleVisible.value = false; // Hide circles
    showButtonUI.value = true; // Trigger button UI
  }

  @override
  void onClose() {
    timer.cancel();
    super.onClose();
  }
}

class LogoAnimation extends StatelessWidget {
  const LogoAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final LogoAnimationController controller = Get.put(LogoAnimationController());

    return Scaffold(
      body: SafeArea(
        child: Obx(() => Stack(
          children: [
            // Animated Circle and "GO" Text UI
            if (!controller.showButtonUI.value) ...[
              GestureDetector(
                onTap: controller.transitionToButtonUI,
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (controller.circleVisible.value) ...[
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 777),
                          curve: Curves.decelerate,
                          width: controller.shouldAnimate.value
                              ? size.width * .55
                              : size.width * .41,
                          height: controller.shouldAnimate.value
                              ? size.width * .55
                              : size.width * .41,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(1000),
                          ),
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 555),
                          curve: Curves.decelerate,
                          width: controller.shouldAnimate.value
                              ? size.width * .48
                              : size.width * .41,
                          height: controller.shouldAnimate.value
                              ? size.width * .48
                              : size.width * .41,
                          decoration: BoxDecoration(
                            color: const Color(0xff4b4b4b),
                            borderRadius: BorderRadius.circular(1000),
                          ),
                        ),
                        Container(
                          width: size.width * .41,
                          height: size.width * .41,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(1000),
                          ),
                        ),
                      ],
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 1000),
                        opacity: controller.shouldShowText.value ? 1 : 0,
                        child: const Text(
                          "GO",
                          style: TextStyle(
                            fontSize: 31,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            // Buttons UI with AnimatedPositioned and AnimatedOpacity
            if (controller.showButtonUI.value) ...[
              Positioned.fill(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _animatedButton("Human Activities Recorder", size, 1),
                    _animatedButton("Sensors Check", size, 2),
                    _animatedButton("Saved Activities", size, 3),
                    _animatedButton("File Location", size, 4),
                  ],
                ),
              ),
            ],
          ],
        )),
      ),
    );
  }

  // Helper Method: Animated Button
  Widget _animatedButton(String text, Size size, int positionIndex) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 500 * positionIndex),
      curve: Curves.easeOut,
      left: 0,
      right: 0,
      top: 100.0 * positionIndex, // Each button appears progressively lower
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 500),
        opacity: 1,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              minimumSize: Size(size.width * 0.8, 60),
            ),
            child: Text(
              text,
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
