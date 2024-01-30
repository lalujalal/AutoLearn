import 'package:first_project/widgets/progress_bar.dart';
import 'package:first_project/widgets/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:first_project/hive/hive.dart';
import 'package:hive/hive.dart';

class StatisticsScreen extends StatefulWidget {
  final Box<User>? userBox;
  final Box<Score>? scoreBox;
  final Box<Question>? questionBox;
  final int? correctAnswersCount;
  final int? incorrectAnswersCount;

  // Require the boxes in the constructor
  StatisticsScreen({
    Key? key,
    required this.userBox,
    required this.scoreBox,
    required this.questionBox,
    required this.correctAnswersCount,
    required this.incorrectAnswersCount,
  }) : super(key: key);

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  int correctAnswers = 0;
  int incorrectAnswers = 0;

  @override
  void initState() {
    super.initState();
    correctAnswers = widget.correctAnswersCount ?? 0;
    incorrectAnswers = widget.incorrectAnswersCount ?? 0;

    Hive.openBox<User>('user');
    Hive.openBox<Score>('score');
    Hive.openBox<Question>('question');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 300,
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            child: Stack(
              children: [
                const TopBar(),
                Positioned(
                  top: 20,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 70,
                        width: 64,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: Center(
                          child: Image.asset(
                            'assets/images/evaluation.png',
                            height: 40,
                            width: 40,
                          ),
                        ),
                      ),
                      const SizedBox(width: 25),
                      const Text(
                        'Statistics',
                        style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 100,
                  left:23,
                  right: 22,
                  child: Container(
                    height: 160,
                    width: 300,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Stack(
                      children: [
                         const Positioned(
                          top: 10,
                          left: 10,
                          child: RepeatedContent(
                            dotAndText1Color: Colors.purple,
                            text1: '100%',
                            text2: 'Completion',
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: RepeatedContent(
                            dotAndText1Color: Colors.purple,
                            text1: widget.questionBox!.length.toString(),
                            text2: 'Total Questions',
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          left: 10,
                          child: RepeatedContent(
                            dotAndText1Color: Colors.green,
                            text1: correctAnswers.toString(),
                            text2: 'Correct',
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          right: 10,
                          child: RepeatedContent(
                            dotAndText1Color: Colors.red,
                            text1: incorrectAnswers.toString(),
                            text2: 'Wrong',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 60),
          Center(
            child: LinearProgressBarReview(
              scoreBox: widget.scoreBox!,
              questionBox: widget.questionBox!,
              correctAnswers: correctAnswers,
              incorrectAnswers: incorrectAnswers,
            ),
          ),
        ],
      ),
    );
  }
}
