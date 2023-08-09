import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tetris_game/animation.dart';
import 'package:tetris_game/board.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Wait for 3 seconds, then navigate to the home screen
    Timer(
      const Duration(seconds: 3),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const GameBoard()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screenHeight = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: const Color(0x00ecf0f1),
        body: Center(
          child: Column(
            children: [
              Lottie.asset('assets/json/game.json').animateOnPageLoad(
                  msDelay: 150, dx: 0.0, dy: -200.0, showDelay: 900),
              Column(
                children: [
                  SizedBox(
                    height: screenHeight.height * 0.3,
                  ),
                  const Text(
                    "Developed By",
                    style: TextStyle(color: Colors.cyan),
                  ).animateOnPageLoad(
                      msDelay: 300, dx: 0.0, dy: 70.0, showDelay: 300),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Mohamed Shehata",
                    style: TextStyle(
                      color: Colors.white60,
                    ),
                  ).animateOnPageLoad(
                      msDelay: 300, dx: 0.0, dy: 70.0, showDelay: 300),
                ],
              ),
            ],
          ),
        ));
  }
}
