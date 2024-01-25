import 'package:flutter/material.dart';
import 'package:first_project/hive/hive.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:first_project/Screens/admin/admin_home.dart';

class AddQuestionPage extends StatefulWidget {
  const AddQuestionPage({Key? key}) : super(key: key);

  @override
  AddQuestionPageState createState() => AddQuestionPageState();
}

class AddQuestionPageState extends State<AddQuestionPage> {
  final chapterBox = Hive.box<Chapter>('chapter');
  late List<TextEditingController> questionControllers;
  late List<List<TextEditingController>> optionControllers;
  late List<int> correctOptionIndices;
  late Chapter? selectedChapter;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    selectedChapter = chapterBox.isNotEmpty ? chapterBox.values.first : null;
    questionControllers = [TextEditingController()];
    optionControllers = [
      [TextEditingController(), TextEditingController(), TextEditingController(), TextEditingController()],
    ];
    correctOptionIndices = optionControllers.isNotEmpty ? [0] : [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 105, 105, 105),
        title: const Text('Add Questions', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
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
                if (chapterBox.isEmpty)
                  const Center(
                    child: Text('No chapters available'),
                  )
                else
                  DropdownButton<Chapter>(
                    value: selectedChapter,
                    onChanged: (Chapter? value) {
                      setState(() {
                        selectedChapter = value;
                        // Load questions for the selected chapter
                      });
                    },
                    items: Hive.box<Chapter>('chapter').values.map((Chapter chapter) {
                      return DropdownMenuItem<Chapter>(
                        value: chapter,
                        child: Text(chapter.chapterName),
                      );
                    }).toList(),
                  ),
                if (selectedChapter != null)
                  for (int i = 0; i < questionControllers.length; i++)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: questionControllers[i],
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
                        ),
                        const SizedBox(height: 20,),
                        for (int j = 0; j < optionControllers[i].length; j++)
                          TextFormField(
                            controller: optionControllers[i][j],
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
                          ),
                        const SizedBox(height: 5),
                        const Text('Choose Correct option', style: TextStyle(fontWeight: FontWeight.bold)),
                        DropdownButton<int>(
                          value: correctOptionIndices[i],
                          onChanged: (int? value) {
                            setState(() {
                              correctOptionIndices[i] = value!;
                            });
                          },
                          items: [0, 1, 2, 3]
                              .map<DropdownMenuItem<int>>(
                                (int value) => DropdownMenuItem<int>(
                                  value: value,
                                  child: Text('Option ${String.fromCharCode('A'.codeUnitAt(0) + value)}'),
                                ),
                              )
                              .toList(),
                        ),
                        const Divider(thickness: 12),
                      ],
                    ),
                const SizedBox(height: 12),
                FloatingActionButton(
                  onPressed: () {
                    addQuestionField();
                  },
                  child: const Icon(Icons.add),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState?.validate() ?? false) {
                      // Save the questions to Hive
                      saveQuestions();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 105, 105, 105),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    minimumSize: const Size(280, 40),
                  ),
                  child: const Text('Save Questions'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void addQuestionField() {
    setState(() {
      if (selectedChapter != null) {
        questionControllers.add(TextEditingController());
        optionControllers.add([
          TextEditingController(),
          TextEditingController(),
          TextEditingController(),
          TextEditingController(),
        ]);
        correctOptionIndices.add(0);
      }
    });
  }

  void saveQuestions() async {
    if (selectedChapter != null) {
      String boxName = 'question_${selectedChapter!.chapterKey}';

      // Open the Hive box for questions, if not open
      await Hive.openBox<Question>(boxName);

      Box<Question> questionBox = Hive.box<Question>(boxName);

      for (int i = 0; i < questionControllers.length; i++) {
        final questionKey = 'question_${questionBox.length + 1}';
        final question = Question(
          chapterKey: selectedChapter!.chapterKey,
          questionKey: questionKey,
          questionText: questionControllers[i].text,
          options: optionControllers[i].map((controller) => controller.text).toList(),
          correctOptionIndex: correctOptionIndices[i],
        );

        await questionBox.put(questionKey, question);
      }

      print('Number of Questions: ${questionBox.length}');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Questions added successfully'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );

      // Navigate back to the previous screen
      Navigator.push(context, MaterialPageRoute(builder: (context) => AdminHome()));

      // Clear controllers and indices after saving
      questionControllers.clear();
      optionControllers.clear();
      correctOptionIndices.clear();
    }
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }
}

