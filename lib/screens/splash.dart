import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment:MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/splash.png",
      ),
            const Text('AutoLearn',style: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.w900,
            ),)
          ],
        ),
      ),
    );
  }
}