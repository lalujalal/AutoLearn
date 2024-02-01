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

    Hive.box<Chapter>('chapter');

    selectedChapter = chapterBox.isNotEmpty ? chapterBox.values.first : null;

    if (selectedChapter != null) {
      final questionBoxKey = 'question_${selectedChapter!.chapterKey}';
      Hive.openBox<Question>(questionBoxKey).then(
        (box) {
          setState(() {
            questionBox = box;
            questions = questionBox!.values.toList();
            loading = false;
          });
        },
      ).catchError((error) {
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
      questions = [];
      loading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (chapterBox.isEmpty) {
      return const Scaffold(
        body: Padding(
          padding: EdgeInsets.all(10.0),
          child: Center(
            child: Text(
              'No chapters available. Kindly add chapters to add questions',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      );
    } else if (selectedChapter == null) {
      return const Scaffold(
        body: Center(
          child: Text('No chapter selected'),
        ),
      );
    } else if (loading) {
      // Display a circular progress indicator while loading
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (questionBox == null) {
      // Handle the case when questionBox is null
      return const Scaffold(
        body: Center(
          child: Text('Error opening questionBox'),
        ),
      );
    } else if (questions.isEmpty) {
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
                DropdownButton<Chapter>(
                  value: selectedChapter,
                  onChanged: (Chapter? value) {
                    setState(() {
                      selectedChapter = value;
                      loading = true;
                      questionBox = value != null ? Hive.box<Question>('question_${value.chapterKey}') : null;
                      questions = questionBox != null ? questionBox!.values.toList() : [];
                    });

                    Hive.openBox<Question>('question_${selectedChapter!.chapterKey}').then(
                      (box) {
                        setState(() {
                          questionBox = box;
                          questions = questionBox!.values.toList();
                          loading = false;
                        });
                      },
                    ).catchError((error) {
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
                          questions[i] = questions[i].copyWith(questionText: value!);
                        },
                      ),
                      const SizedBox(height: 10),
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
                                questions[i] = questions[i].copyWithOption(index: j, option: value!);
                              },
                            ),
                            const SizedBox(height: 10),
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

    await questionBox!.clear();

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

    Navigator.push(context, MaterialPageRoute(builder: (context) => AdminHome()));
  }

  void deleteQuestion(int index) {
    if (questionBox == null) {
      print('Error: questionBox is null');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error deleting question'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    setState(() {
      questions.removeAt(index);
    });

    questionBox!.delete(questions[index].questionKey);

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




