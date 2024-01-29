import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:first_project/Screens/User/profile.dart';
import 'package:first_project/Screens/User/search.dart';
import 'package:first_project/Screens/User/statistics.dart';
import 'package:first_project/Screens/User/user_home.dart';
import 'package:first_project/hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  late Box<User> userBox;
  late Box<Score> scoreBox;
  late Box<Question> questionBox;


  @override
  void initState() {
    super.initState();
    // Open the necessary Hive boxes
    userBox = Hive.box<User>('user');
    scoreBox = Hive.box<Score>('score');
    questionBox = Hive.box<Question>('question');
  }

  int index = 0;
  @override
  Widget build(BuildContext context) {
    final screens = [
      const UserHomeScreen(),
      const SearchPage(),
      StatisticsScreen(
        userBox: userBox,
        scoreBox: scoreBox,
        questionBox: questionBox,
        correctAnswersCount: 0,
        incorrectAnswersCount: 0,
      ),
      const ProfilePage(),
    ];

    final bottomBarItems = [
      const SizedBox(
        height: 45,
        child: Column(children: [SizedBox(height: 8,), Icon(Icons.home, size: 18), Text('Home')]),
      ),
      const SizedBox(
        height: 45,
        child: Column(children: [SizedBox(height: 8,), Icon(Icons.search_rounded, size: 18), Text('Search')]),
      ),
      const SizedBox(
        height: 45,
        child: Column(children: [SizedBox(height: 8,), Icon(Icons.signal_cellular_alt_sharp, size: 18), Text('Statistics', style: TextStyle(fontSize: 12),)]),
      ),
      const SizedBox(
        height: 45,
        child: Column(children: [SizedBox(height: 8,), Icon(Icons.person_2_rounded, size: 20), Text('Profile')]),
      ),
    ];

    return Scaffold(
      body: screens[index],
      extendBody: true,
      bottomNavigationBar: CurvedNavigationBar(
        items: bottomBarItems,
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: const Color(0xffE4DDDD),
        color: const Color(0xffE4DDDD),
        height: 60,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 600),
        onTap: (index) => setState(() => this.index = index),
      ),
    );
  }
}