import 'package:first_project/hive/hive_manager.dart';
import 'package:flutter/material.dart';
import 'package:first_project/splash.dart';
// import 'package:first_project/hive/hive.dart';
// import 'package:hive_flutter/adapters.dart';
// import 'package:path_provider/path_provider.dart' as path;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeHive(); // await for the initialization to complete
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
