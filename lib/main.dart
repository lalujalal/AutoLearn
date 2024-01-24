import 'package:first_project/hive/hive_manager.dart';
import 'package:flutter/material.dart';
import 'package:first_project/screens/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeHive(); 
  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AutoLearn',
      home: SplashScreen(),
    );
  }
}
