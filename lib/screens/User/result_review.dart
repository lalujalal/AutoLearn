import 'package:first_project/Screens/User/bottomnav.dart';
import 'package:first_project/Screens/User/statistics.dart';
import 'package:first_project/hive/hive.dart';
import 'package:first_project/widgets/progress_bar.dart';
import 'package:first_project/widgets/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

class ResultReview extends StatefulWidget {
  final Box<Score> scoreBox;
  final Box<Question> questionBox;
  final Box<User> userBox; // Add userBox here
  final int correctAnswersCount;
  final int incorrectAnswersCount;

  const ResultReview({
    Key? key,
    required this.scoreBox,
    required this.questionBox,
    required this.userBox, // Pass userBox here
    required this.correctAnswersCount,
    required this.incorrectAnswersCount,
  }) : super(key: key);

  @override
  State<ResultReview> createState() => _ResultReviewState();
}

class _ResultReviewState extends State<ResultReview> {
  int correctAnswers = 0;
  int incorrectAnswers = 0;

  @override
  void initState() {
    super.initState();
    correctAnswers = widget.correctAnswersCount;
    incorrectAnswers = widget.incorrectAnswersCount;
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
                  top: 65,
                  left: 55,
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
                            text1: widget.questionBox.length.toString(),
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
            child: CircularProgressBarReview(
              scoreBox: widget.scoreBox,
              questionBox: widget.questionBox,
              correctAnswers: correctAnswers,
              incorrectAnswers: incorrectAnswers,
            ),
          ),
          SizedBox(
            height: 100,
            width: 400,
            child: Stack(
              children: [
                Positioned(
                  left: 20,
                  child: Column(
                    children: [
                      FloatingActionButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StatisticsScreen(
                                scoreBox: widget.scoreBox,
                                questionBox: widget.questionBox,
                                userBox: widget.userBox, 
                                correctAnswersCount: correctAnswers,
                                incorrectAnswersCount: incorrectAnswers,
                              ),
                            ),
                          );
                        },
                        backgroundColor: Colors.blue,
                        child: const Icon(Icons.signal_cellular_alt_sharp, size: 18),
                      ),
                      const Text('Statistics', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Positioned(
                  right: 20,
                  child: Column(
                    children: [
                      FloatingActionButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const BottomNav()),
                            (route) => false,
                          );
                        },
                        backgroundColor: const Color.fromARGB(255, 143, 68, 173),
                        child: const Icon(Icons.home),
                      ),
                      const Text('Home', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}