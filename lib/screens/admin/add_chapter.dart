import 'package:flutter/material.dart';
import 'package:first_project/widgets/dynamic_feild.dart';
import 'package:first_project/hive/hive.dart';
import 'package:hive/hive.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class AddChapter extends StatefulWidget {
  const AddChapter({Key? key}) : super(key: key);

  @override
  State<AddChapter> createState() => _AddChapterState();
}

class _AddChapterState extends State<AddChapter> {
  final chapterBox = Hive.box<Chapter>('chapter');
  final _formkey = GlobalKey<FormState>();
  final TextEditingController chapterNameController = TextEditingController();
  File? chapterIconImage;
  File? chapterHeaderImage;
  TextEditingController youtubeLinkController = TextEditingController();
  List<TextEditingController> subHeadingControllers = [TextEditingController()];
  List<TextEditingController> subHeadingContentControllers = [TextEditingController()];
  List<int> dynamicFieldIndices = [];
  List<TextEditingController> referenceImagePathsControllers = [TextEditingController()];

  @override
  void initState() {
    super.initState();
    Hive.openBox<Chapter>('chapter');
    chapterBox;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 140,
        flexibleSpace: Ink(
          height: 140,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: const Color.fromARGB(255, 105, 105, 105),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 70,
                width: 70,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/chapter.png',
                    height: 60,
                    width: 60,
                  ),
                ),
              ),
              const SizedBox(width: 25),
              const Text(
                'Add Chapters',
                style: TextStyle(color: Colors.white, fontSize: 22,fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Chapter Name:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5,),
                    TextFormField(
                      controller: chapterNameController,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter chapter name';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter chapter name',
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
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        pickImage('Select Chapter Icon Image', (pickedFile) {
                          setState(() {
                            chapterIconImage = pickedFile;
                          });
                        });
                      },
                      child: Container(
                        color: Colors.grey[200],
                        height: 100,
                        child: Center(
                          child: chapterIconImage != null
                              ? Image.file(chapterIconImage!)
                              : const Text('Select Chapter Icon Image'),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        pickImage('Select Chapter Header Image', (pickedFile) {
                          setState(() {
                            chapterHeaderImage = pickedFile;
                          });
                        });
                      },
                      child: Container(
                        color: Colors.grey[200],
                        height: 100,
                        child: Center(
                          child: chapterHeaderImage != null
                              ? Image.file(chapterHeaderImage!)
                              : const Text('Select Chapter Header Image'),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Divider(
                      thickness: 2,
                      color: Color.fromARGB(255, 75, 74, 74),
                    ),
                    const Text(
                      'Reference Image Paths:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Column(
                      children: [
                        for (int index = 0; index < referenceImagePathsControllers.length; index++)
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: referenceImagePathsControllers[index],
                                  decoration: InputDecoration(
                                    hintText: 'Enter Reference Image Path',
                                    border: OutlineInputBorder(
                                      borderSide:const BorderSide(color: Color(0xffA42FC1)),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:const BorderSide(color: Color(0xffA42FC1)),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:const BorderSide(color: Color(0xffA42FC1)),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    contentPadding:const EdgeInsets.symmetric(horizontal: 16),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon:const Icon(Icons.add),
                                onPressed: () {
                                  addDynamicField(referenceImagePathsControllers);
                                },
                              ),
                            ],
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'YouTube Link:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: youtubeLinkController,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Enter YouTube link';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter YouTube link',
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
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Chapter Contents:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                     for (int index in dynamicFieldIndices)
                      DynamicField(
                        index: index,
                        subHeadingController: subHeadingControllers[index],
                        subHeadingContentController: subHeadingContentControllers[index],
                        onRemove: () {
                          removeDynamicField(index);
                        },
                      ),
                    const SizedBox(height: 20),

                    FloatingActionButton(
                      onPressed: addChapterDynamicField,
                      child: const Icon(Icons.add),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formkey.currentState?.validate() ?? false) {
                  addChapter();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                minimumSize: const Size(200, 45),
              ),
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

Future<void> pickImage(String title, Function(File?) onImagePicked) async {
  final picker = ImagePicker();
  try {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final pickedImage = File(pickedFile.path);
      onImagePicked(pickedImage);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an image!'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  } catch (e) {
    print('Error picking image: $e');
  }
}


  void addDynamicField(List<TextEditingController> controllers) {
    setState(() {
      controllers.add(TextEditingController());
    });
  }

  void removeDynamicField(int index) {
    setState(() {
      dynamicFieldIndices.remove(index);
      subHeadingControllers.removeAt(index);
      subHeadingContentControllers.removeAt(index);
    });
  }


  void addChapterDynamicField() {
    setState(() {
      int newIndex = dynamicFieldIndices.length;
      dynamicFieldIndices.add(newIndex);

      subHeadingControllers.add(TextEditingController());
      subHeadingContentControllers.add(TextEditingController());
    });
  }

  void addChapter() async {
    String chapterIconImagePath = chapterIconImage?.path ?? '';
    String chapterHeaderImagePath = chapterHeaderImage?.path ?? '';
    List<String> referenceImagePathsList = referenceImagePathsControllers
        .map((controller) => controller.text)
        .where((path) => path.trim().isNotEmpty)
        .toList();

    List<SubHeading> subHeadings = [];
    for (int i = 0; i < dynamicFieldIndices.length; i++) {
      subHeadings.add(SubHeading(
        subHeading: subHeadingControllers[i].text,
        subHeadingContent: subHeadingContentControllers[i].text,
      ));
    }
    int chapterIndex = chapterBox.length;
    String chapterKey = 'chapter_$chapterIndex';

    Chapter newChapter = Chapter(
      chapterKey: chapterKey,
      chapterName: chapterNameController.text,
      chapterIconImagePath: chapterIconImagePath,
      chapterHeaderImagePath: chapterHeaderImagePath,
      referenceImagePaths: referenceImagePathsList,
      youtubeLink: youtubeLinkController.text,
      subHeadings: subHeadings,
    );

    await Hive.box<Chapter>('chapter').put(chapterKey, newChapter);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Chapter added successfully'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );

    Navigator.pop(context);
  }
}

