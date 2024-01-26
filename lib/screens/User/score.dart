import 'package:first_project/Screens/User/result_review.dart';
import 'package:first_project/widgets/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:first_project/Screens/User/bottomnav.dart';
import 'package:first_project/hive/hive.dart';
import 'package:hive/hive.dart';

class ScorePage extends StatefulWidget {
  final String chapterKey;
  final Box<Question> questionBox;
  final Box<Score> scoreBox;
  final int correctAnswersCount;
  final int incorrectAnswersCount;

  const ScorePage({
    Key? key,
    required this.chapterKey,
    required this.questionBox,
    required this.scoreBox,
    required this.correctAnswersCount,
    required this.incorrectAnswersCount,
  }) : super(key: key);

  @override
  State<ScorePage> createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  late List<Score> scores;

  @override
  void initState() {
    super.initState();
    scores = widget.scoreBox.values.where((score) => score.chapterKey == widget.chapterKey).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 380,
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            child: Stack(
              children: [
                const TopBar(),
                Positioned(
                  top: 138,
                  left: 130,
                  child: ClipOval(
                    child: Container(
                      color: const Color.fromARGB(255, 125, 126, 128),
                      height: 150,
                      width: 150,
                      child: Center(
                        child: ClipOval(
                          child: Container(
                            color: const Color.fromARGB(255, 151, 149, 149),
                            height: 125,
                            width: 125,
                            child: Center(
                              child: ClipOval(
                                child: Container(
                                  color: Colors.white,
                                  height: 110,
                                  width: 110,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Your Score',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xffA42FC1),
                                          fontSize: 18,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        widget.correctAnswersCount.toString(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 28,
                                          color: Color(0xffA42FC1),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 300,
            width: 400,
            child: Stack(
              children: [
                Positioned(
                  child: Text('Correct Answers: ${widget.correctAnswersCount}, Incorrect Answers: ${widget.incorrectAnswersCount}'),
                ),
                Positioned(
                  bottom: 40,
                  left: 20,
                  child: Column(children: [
                    FloatingActionButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      backgroundColor: Colors.blue,
                      child: const Icon(Icons.refresh),
                    ),
                    const Text('Play Again', style: TextStyle(fontWeight: FontWeight.bold)),
                  ]),
                ),
                Positioned(
                  bottom: 120,
                  left: 170,
                  child: Column(children: [
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
                  ]),
                ),
                Positioned(
                  bottom: 40,
                  right: 10,
                  child: Column(children: [
                    FloatingActionButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ResultReview(
                              scoreBox: widget.scoreBox,
                              questionBox: widget.questionBox,
                              userBox: Hive.box<User>('user'), // Pass the userBox here
                              correctAnswersCount: widget.correctAnswersCount,
                              incorrectAnswersCount: widget.incorrectAnswersCount,
                            ),
                          ),
                        );
                      },
                      backgroundColor: const Color.fromARGB(255, 212, 151, 82),
                      child: const Icon(Icons.remove_red_eye),
                    ),
                    const Text('Review Results', style: TextStyle(fontWeight: FontWeight.bold)),
                  ]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}