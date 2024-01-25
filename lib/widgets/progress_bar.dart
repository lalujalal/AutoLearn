import 'package:first_project/hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class CircularProgressBarReview extends StatelessWidget {
  final Box<Score> scoreBox;
  final Box<Question> questionBox;
  final int correctAnswers;
  final int incorrectAnswers;

  const CircularProgressBarReview({
    Key? key,
    required this.scoreBox,
    required this.questionBox,
    required this.correctAnswers,
    required this.incorrectAnswers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int totalQuestions = questionBox.length;

    // Calculate progress for correct and incorrect answers
    double correctProgress = correctAnswers / totalQuestions;
    double incorrectProgress = incorrectAnswers / totalQuestions;

    // Check if values are finite before converting to int
    if (correctProgress.isFinite && incorrectProgress.isFinite) {
      return Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            child: SizedBox(
              height: 200,
              width: 200,
              child: CircularProgressIndicator(
                strokeWidth: 8,
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xffFA3939)),
                backgroundColor: const Color(0xffE9ECEF),
                value: incorrectProgress,
              ),
            ),
          ),
          SizedBox(
            height: 130,
            width: 130,
            child: CircularProgressIndicator(
              strokeWidth: 8,
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xff1F8435)),
              backgroundColor: const Color(0xffE9ECEF),
              value: correctProgress,
            ),
          ),
        ],
      );
    } else {
      // Display a message when there's an error in progress calculation
      return const Text(
        'Error: Unable to calculate progress. Please complete the quiz.',
        style: TextStyle(color: Colors.red),
      );
    }
  }
}

class LinearProgressBarReview extends StatelessWidget {
  final Box<Score> scoreBox;
  final Box<Question> questionBox;
  final int correctAnswers;
  final int incorrectAnswers;

  const LinearProgressBarReview({
    Key? key,
    required this.scoreBox,
    required this.questionBox,
    required this.correctAnswers,
    required this.incorrectAnswers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int totalQuestions = questionBox.length;

    // Calculate progress for correct and incorrect answers
    double correctProgress = correctAnswers / totalQuestions;
    double incorrectProgress = incorrectAnswers / totalQuestions;

    // Check if values are finite before converting to int
    if (correctProgress.isFinite && incorrectProgress.isFinite) {
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 10,
              child: LinearProgressIndicator(
                value: incorrectProgress,
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xffFA3939)),
                backgroundColor: const Color(0xffE9ECEF),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 10,
              child: LinearProgressIndicator(
                value: correctProgress,
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xff1F8435)),
                backgroundColor: const Color(0xffE9ECEF),
              ),
            ),
          ],
        ),
      );
    } else {
      // Display a message when there's an error in progress calculation
      return const Padding(
        padding:  EdgeInsets.all(20.0),
        child:  Text(
          'Error: Unable to calculate progress. Please complete the quiz.',
          style: TextStyle(color: Colors.red,fontSize: 16),
        ),
      );
    }
  }
}

class RepeatedContent extends StatelessWidget {
  final Key? key;
  final Color dotAndText1Color;
  final String text1;
  final String text2;

  const RepeatedContent({
    this.key,
    required this.dotAndText1Color,
    required this.text1,
    required this.text2,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Row(
        children: [
          Container(
            height: 18,
            width: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: dotAndText1Color,
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                text1,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 24, color: dotAndText1Color),
              ),
              Text(
                text2,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              )
            ],
          ),
        ],
      ),
    );
  }
}
