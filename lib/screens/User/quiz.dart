import 'dart:async';
import 'package:first_project/widgets/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:first_project/Screens/User/score.dart';
import 'package:first_project/hive/hive.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

class QuizPageDemo extends StatefulWidget {
  final String chapterKey;

  const QuizPageDemo({Key? key, required this.chapterKey}) : super(key: key);

  @override
  State<QuizPageDemo> createState() => _QuizPageDemoState();
}

class _QuizPageDemoState extends State<QuizPageDemo> {
  late Box<Question> questionBox;
  late Box<Score> scoreBox;
  List<Question> questions = [];
  int correctOptionIndex = 0;
  int selectedOptionIndex = -1;
  bool showCorrectAnswerHint = false;
  int selectedQuestionNumber = 0;
  int remainingTime = 20;
  int correctAnswersCount = 0;
  int incorrectAnswersCount = 0;
  late Timer countdownTimer;
  bool isQuestionAnswered = false;

  @override
  void initState() {
    super.initState();
    openQuestionBox();
    openScoreBox();
  }

  Future<void> openQuestionBox() async {
    questionBox = await Hive.openBox<Question>('question_${widget.chapterKey}');
    loadQuestions();
  }

  Future<void> openScoreBox() async {
    scoreBox = await Hive.openBox<Score>('score_${widget.chapterKey}');
  }

  void loadQuestions() {
    questions = questionBox.values.where((question) => question.chapterKey == widget.chapterKey).toList();
    questions.shuffle();
    print('Number of questions: ${questions.length}');
    _loadQuestions(widget.chapterKey);
  }

  void _loadQuestions(String chapterKey) {
    setState(() {
      if (selectedQuestionNumber < questions.length) {
        correctOptionIndex = questions[selectedQuestionNumber].correctOptionIndex;
        selectedOptionIndex = -1;
        showCorrectAnswerHint = false;
        remainingTime = 20;
        isQuestionAnswered = false; // Reset the flag when loading a new question
        startCountdownTimer();
      }
    });
  }

  void startCountdownTimer() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        remainingTime--;
        if (remainingTime <= 0) {
          timer.cancel();
          _handleTimerExpired();
        }
      });
    });
  }

  void _handleQuestionIndicatorTap(int questionIndex) {
    if (questionIndex >= 0 && questionIndex < questions.length && !isQuestionAnswered) {
      setState(() {
        selectedQuestionNumber = questionIndex;
        correctOptionIndex = questions[selectedQuestionNumber].correctOptionIndex;
        selectedOptionIndex = -1;
        showCorrectAnswerHint = false;
        remainingTime = 20;
        isQuestionAnswered = false; // Reset the flag when loading a new question
        countdownTimer.cancel();
        startCountdownTimer();
      });
    }
  }

  void _handleOptionTap(int optionIndex) {
    if (optionIndex == selectedOptionIndex || isQuestionAnswered) {
      // Option already selected or question already answered, do nothing
      return;
    }

    setState(() {
      selectedOptionIndex = optionIndex;
      showCorrectAnswerHint = true;
      isQuestionAnswered = true; // Set the flag to true after answering the question
      countdownTimer.cancel();
      Future.delayed(const Duration(seconds: 3), () {
        _moveToNextQuestionOrScorePage();
      });
    });
  }

  void _handleTimerExpired() {
    print('Timer expired!');
    _moveToNextQuestionOrScorePage();
  }

  void _moveToNextQuestionOrScorePage() {
    if (selectedOptionIndex != correctOptionIndex) {
      // Answer is wrong
      incorrectAnswersCount++;
      scoreBox.add(
        Score(
          chapterKey: widget.chapterKey,
          correctAnswers: correctAnswersCount,
          incorrectAnswers: incorrectAnswersCount,
          questionNumber: selectedQuestionNumber,
          isCorrect: false,
        ),
      );
    } else {
      // Answer is correct
      correctAnswersCount++;
      scoreBox.add(
        Score(
          chapterKey: widget.chapterKey,
          correctAnswers: correctAnswersCount,
          incorrectAnswers: incorrectAnswersCount,
          questionNumber: selectedQuestionNumber,
          isCorrect: true,
        ),
      );
    }

    // Check if there are more questions
    if (selectedQuestionNumber < questions.length - 1) {
      // Load the next question
      selectedQuestionNumber++;
      _loadQuestions(widget.chapterKey);
    } else {
      //Navigate to the score page with correct and incorrect answers count
      _showScorePagePopup();
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 220,
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child:const Stack(
                    children: [
                      TopBar(),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 37),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int i = 0; i < questions.length; i++)
                        GestureDetector(
                          onTap: () {
                            _handleQuestionIndicatorTap(i);
                          },
                          child: Container(
                            width: 30,
                            height: 30,
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: selectedQuestionNumber == i
                                  ? Colors.blue
                                  : Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                (i + 1).toString(),
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 55, right: 28, top: 115),
                  child: Container(
                    height: 200,
                    width: 300,
                    decoration: BoxDecoration(
                      color: const Color(0xffF5F2F2),
                      border: Border.all(
                        color: Colors.grey,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          questions.isNotEmpty
                              ? questions[selectedQuestionNumber].questionText
                              : 'No questions available, Contact With Admin',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 140,
                  right: 165,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: CircularProgressIndicator(
                          strokeWidth: 8,
                          value: 1 - remainingTime / 20,
                          backgroundColor: Colors.grey,
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                        ),
                      ),
                      Text(
                        remainingTime.toString(),
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            if (questions.isEmpty)
             const Center(
                child: Text(
                  'No questions available for this chapter.\nContact the admin for assistance.',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            if (questions.isNotEmpty)
              for (int j = 0; j < questions[selectedQuestionNumber].options.length; j++)
                Column(
                  children: [
                    optionContainer(
                      questions[selectedQuestionNumber].options[j],
                      j,
                    ),
                    const SizedBox(height: 15), 
                  ],
                ),
            // Display correct answer hint if needed
            if (showCorrectAnswerHint)
              Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.5),
                  border: Border.all(
                    color: Colors.green,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  'Answer: ${questions.isNotEmpty ? questions[selectedQuestionNumber].options[correctOptionIndex] : 'No question available'}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            const Divider(thickness: 1, color: Colors.grey),
            const SizedBox(height: 20),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff6A6C73),
        onPressed: () {
          _showScorePagePopup();
        },
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }

  Widget optionContainer(String optionText, int optionIndex) {
    bool isSelected = selectedOptionIndex == optionIndex;
    bool isCorrect = correctOptionIndex == optionIndex;

    return GestureDetector(
      onTap: () {
        _handleOptionTap(optionIndex);
      },
      child: Container(
        height: 50,
        width: 300,
        decoration: BoxDecoration(
          color: isSelected
              ? isCorrect
                  ? Colors.green.withOpacity(0.5)
                  : Colors.red.withOpacity(0.5)
              : Colors.white,
          border: Border.all(
            color: const Color(0xffA42FC1),
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                optionText,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16
                ),
              ),
              if (isSelected)
                Icon(
                  isCorrect ? Icons.check_circle : Icons.cancel,
                  color: isCorrect
                      ? const Color.fromARGB(255, 11, 156, 16)
                      : const Color.fromARGB(255, 243, 26, 10),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showScorePagePopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Quiz Completed"),
          content: const Text("Do you want to view your score?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ScorePage(
                      chapterKey: widget.chapterKey,
                      questionBox: questionBox,
                      scoreBox: scoreBox,
                      correctAnswersCount: correctAnswersCount,
                      incorrectAnswersCount: incorrectAnswersCount,
                    ),
                  ),
                );
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }
}