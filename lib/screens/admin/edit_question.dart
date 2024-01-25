import 'package:flutter/material.dart';
import 'package:first_project/hive/hive.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:first_project/Screens/Admin/admin_home.dart';

class EditQuestionPage extends StatefulWidget {
  const EditQuestionPage({Key? key}) : super(key: key);

  @override
  EditQuestionPageState createState() => EditQuestionPageState();
}

class EditQuestionPageState extends State<EditQuestionPage> {
  final chapterBox = Hive.box<Chapter>('chapter');
  late Chapter? selectedChapter;
  Box<Question>? questionBox;
  List<Question> questions = [];
  bool loading = true; // Added loading state
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    selectedChapter = chapterBox.isNotEmpty ? chapterBox.values.first : null;

    // Check if selectedChapter is not null before opening the questionBox
    if (selectedChapter != null) {
      // Explicitly open the Hive box using openBox command
      Hive.openBox<Question>('question_${selectedChapter!.chapterKey}').then(
        (box) {
          setState(() {
            questionBox = box;
            questions = questionBox!.values.toList();
            loading = false; // Set loading to false when the data is loaded
          });
        },
      ).catchError((error) {
        // Handle the case if there's an error opening the box
        print('Error opening questionBox: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error opening questionBox'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      });
    } else {
      // Handle the case when selectedChapter is null
      // You may want to display an error message or handle it in another way
      // For now, setting an empty list for questions
      questions = [];
      loading = false; // Set loading to false when there's no selected chapter
    }
  }

  @override
  Widget build(BuildContext context) {
    if (chapterBox.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text('No chapters available'),
        ),
      );
    }

    if (selectedChapter == null) {
      return const Scaffold(
        body: Center(
          child: Text('No chapter selected'),
        ),
      );
    }

    if (loading) {
      // Display a circular progress indicator while loading
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (questionBox == null) {
      // Handle the case when questionBox is null
      return const Scaffold(
        body: Center(
          child: Text('Error opening questionBox'),
        ),
      );
    }

    if (questions.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text('No questions available for the selected chapter'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 105, 105, 105),
        title: const Text('Edit Questions', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        centerTitle: true,
        toolbarHeight: 90,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Select Chapter', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                // Dropdown to select chapter
                DropdownButton<Chapter>(
                  value: selectedChapter,
                  onChanged: (Chapter? value) {
                    setState(() {
                      selectedChapter = value;
                      loading = true; // Set loading to true when changing the selected chapter
                      questionBox = value != null ? Hive.box<Question>('question_${value.chapterKey}') : null;
                      questions = questionBox != null ? questionBox!.values.toList() : [];
                    });

                    // Explicitly open the Hive box using openBox command
                    Hive.openBox<Question>('question_${selectedChapter!.chapterKey}').then(
                      (box) {
                        setState(() {
                          questionBox = box;
                          questions = questionBox!.values.toList();
                          loading = false; // Set loading to false when the data is loaded
                        });
                      },
                    ).catchError((error) {
                      // Handle the case if there's an error opening the box
                      print('Error opening questionBox: $error');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Error opening questionBox'),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 3),
                        ),
                      );
                    });
                  },
                  items: chapterBox.values.map((Chapter chapter) {
                    return DropdownMenuItem<Chapter>(
                      value: chapter,
                      child: Text(chapter.chapterName),
                    );
                  }).toList(),
                ),
                for (int i = 0; i < questions.length; i++)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        initialValue: questions[i].questionText,
                        decoration: InputDecoration(
                          labelText: 'Question ${i + 1}',
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Color(0xffA42FC1)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Color(0xffA42FC1)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a question';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          // Update the question text
                          questions[i] = questions[i].copyWith(questionText: value!);
                        },
                      ),
                      const SizedBox(height: 10), // Add gap between question and options
                      for (int j = 0; j < questions[i].options.length; j++)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFormField(
                              initialValue: questions[i].options[j],
                              decoration: InputDecoration(
                                labelText: 'Option ${String.fromCharCode('A'.codeUnitAt(0) + j)}',
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Color(0xffA42FC1)),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Color(0xffA42FC1)),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Color(0xffA42FC1)),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter an option';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                // Update the option text
                                questions[i] = questions[i].copyWithOption(index: j, option: value!);
                              },
                            ),
                            const SizedBox(height: 10), // Add gap between options
                          ],
                        ),
                      const SizedBox(height: 5),
                      const Text('Choose Correct option', style: TextStyle(fontWeight: FontWeight.bold)),
                      DropdownButton<int>(
                        value: questions[i].correctOptionIndex,
                        onChanged: (int? value) {
                          setState(() {
                            questions[i] = questions[i].copyWith(correctOptionIndex: value!);
                          });
                        },
                        items: List.generate(
                          questions[i].options.length,
                          (index) => DropdownMenuItem<int>(
                            value: index,
                            child: Text('Option ${String.fromCharCode('A'.codeUnitAt(0) + index)}'),
                          ),
                        ),
                      ),
                      const Divider(thickness: 12),
                      ElevatedButton(
                        onPressed: () {
                          // Delete the question
                          deleteQuestion(i);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text('Delete Question'),
                      ),
                    ],
                  ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState?.validate() ?? false) {
                      // Save the edited questions to Hive
                      saveEditedQuestions();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 105, 105, 105),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    minimumSize: const Size(280, 40),
                  ),
                  child: const Text('Save Edited Questions'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void saveEditedQuestions() async {
    if (questionBox == null) {
      // Handle the case when questionBox is null
      print('Error: questionBox is null');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error saving edited questions'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    await questionBox!.clear(); // Clear the existing questions in the box

    for (int i = 0; i < questions.length; i++) {
      await questionBox!.put(questions[i].questionKey, questions[i]);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Questions edited successfully'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );

    // Navigate back to the previous screen
    Navigator.push(context, MaterialPageRoute(builder: (context) => AdminHome()));
  }

  void deleteQuestion(int index) {
    // Remove the question from the UI
    setState(() {
      questions.removeAt(index);
    });

    // Remove the question from the associated questionBox
    questionBox!.delete(questions[index].questionKey);

    // Update the question numbers in the UI
    for (int i = index; i < questions.length; i++) {
      questions[i] = questions[i].copyWith(questionText: questions[i].questionText);
    }
  }
}

extension QuestionExtension on Question {
  Question copyWith({String? questionText, int? correctOptionIndex}) {
    return Question(
      chapterKey: chapterKey,
      questionKey: questionKey,
      questionText: questionText ?? this.questionText,
      options: List.from(options),
      correctOptionIndex: correctOptionIndex ?? this.correctOptionIndex,
    );
  }

  Question copyWithOption({required int index, required String option}) {
    List<String> newOptions = List.from(options);
    newOptions[index] = option;
    return Question(
      chapterKey: chapterKey,
      questionKey: questionKey,
      questionText: questionText,
      options: newOptions,
      correctOptionIndex: correctOptionIndex,
    );
  }
}



