import 'package:first_project/widgets/dynamic_feild.dart';
import 'package:flutter/material.dart';
import 'package:first_project/hive/hive.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:hive/hive.dart';

class EditChapter extends StatefulWidget {
  final String chapterKey;

  const EditChapter({Key? key, required this.chapterKey}) : super(key: key);

  @override
  EditChapterState createState() => EditChapterState();
}

class EditChapterState extends State<EditChapter> {
  late Chapter existingChapter;
  late Box<Chapter> chapterBox;
  final _formKey = GlobalKey<FormState>();
  TextEditingController chapterNameController = TextEditingController();
  File? chapterIconImage;
  File? chapterHeaderImage;
  List<TextEditingController> referenceImagePathsControllers = [TextEditingController()];
  TextEditingController youtubeLinkController = TextEditingController();
  List<TextEditingController> subHeadingControllers = [TextEditingController()];
  List<TextEditingController> subHeadingContentControllers = [TextEditingController()];
  List<int> dynamicFieldIndices = [];

  @override
  void initState() {
    super.initState();
    chapterBox = Hive.box<Chapter>('chapter');
    existingChapter = chapterBox.get(widget.chapterKey)!;

    // Initialize controllers with existing chapter data
    chapterNameController.text = existingChapter.chapterName;
    youtubeLinkController.text = existingChapter.youtubeLink;

    // Initialize subheading controllers with existing chapter subheadings
    for (int i = 0; i < existingChapter.subHeadings.length; i++) {
      subHeadingControllers.add(TextEditingController());
      subHeadingContentControllers.add(TextEditingController());

      subHeadingControllers[i].text = existingChapter.subHeadings[i].subHeading;
      subHeadingContentControllers[i].text = existingChapter.subHeadings[i].subHeadingContent;

      dynamicFieldIndices.add(i);
    }

    // Initialize reference image path controllers with existing chapter reference image paths
    for (int i = 0; i < existingChapter.referenceImagePaths.length; i++) {
      referenceImagePathsControllers.add(TextEditingController());
      referenceImagePathsControllers[i].text = existingChapter.referenceImagePaths[i];
    }

    // Load existing images if available
    loadExistingImages();
  }

  void loadExistingImages() async {
    if (existingChapter.chapterIconImagePath.isNotEmpty) {
      setState(() {
        chapterIconImage = File(existingChapter.chapterIconImagePath);
      });
    }

    if (existingChapter.chapterHeaderImagePath.isNotEmpty) {
      setState(() {
        chapterHeaderImage = File(existingChapter.chapterHeaderImagePath);
      });
    }
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
          height: 130,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: const Color.fromARGB(255, 105, 105, 105),
          ),
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
                    'assets/images/edit.png',
                    height: 50,
                    width: 45,
                  ),
                ),
              ),
              const SizedBox(width: 25),
              const Text(
                'Edit Chapter',
                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
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
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Chapter Name:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    TextFormField(
                      controller: chapterNameController,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter chapter name';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Enter chapter name',
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
                              : existingChapter.chapterIconImagePath.isNotEmpty
                                  ? Image.file(File(existingChapter.chapterIconImagePath))
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
                              : existingChapter.chapterHeaderImagePath.isNotEmpty
                                  ? Image.file(File(existingChapter.chapterHeaderImagePath))
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
                      'Reference Image Paths (comma-separated):',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    for (int i = 0; i < referenceImagePathsControllers.length; i++)
                      TextFormField(
                        controller: referenceImagePathsControllers[i],
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Please enter reference image path';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          hintText: 'Enter Reference Image Path',
                        ),
                      ),
                    const SizedBox(height: 20),
                    const Text(
                      'YouTube Link:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    TextFormField(
                      controller: youtubeLinkController,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Enter YouTube link';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Enter YouTube link',
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
                        onRemove:() {
                          removeDynamicField(index);
                        },
                      ),
                    const SizedBox(height: 20),
                    FloatingActionButton(
                      onPressed: () {
                        addDynamicField();
                      },
                      child: const Icon(Icons.add),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  editChapter();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                minimumSize: const Size(200, 45),
              ),
              child: const Text(
                'Save',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Future<void> pickImage(String title, Function(File?) onImagePicked) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final pickedImage = File(pickedFile.path);
      onImagePicked(pickedImage);
    }
  }

  void addDynamicField() {
    setState(() {
      int newIndex = dynamicFieldIndices.length;
      dynamicFieldIndices.add(newIndex);

      // Create new controllers for the added dynamic field
      subHeadingControllers.add(TextEditingController());
      subHeadingContentControllers.add(TextEditingController());
    });
  }

  void removeDynamicField(int index) {
  setState(() {
    dynamicFieldIndices.remove(index);
    subHeadingControllers.removeAt(index);
    subHeadingContentControllers.removeAt(index);
  });
}

  void editChapter() async {
    // Convert File objects to String paths
    String chapterIconImagePath = chapterIconImage?.path ?? '';
    String chapterHeaderImagePath = chapterHeaderImage?.path ?? '';
    List<String> referenceImagePathsList = referenceImagePathsControllers
        .map((controller) => controller.text)
        .where((path) => path.trim().isNotEmpty)
        .toList();

    // Create SubHeading objects
    List<SubHeading> subHeadings = [];
    for (int i = 0; i < dynamicFieldIndices.length; i++) {
      subHeadings.add(SubHeading(
        subHeading: subHeadingControllers[i].text,
        subHeadingContent: subHeadingContentControllers[i].text,
      ));
    }

    // Update existing Chapter object
    Chapter editedChapter = Chapter(
      chapterKey: existingChapter.chapterKey,
      chapterName: chapterNameController.text,
      chapterIconImagePath: chapterIconImagePath,
      chapterHeaderImagePath: chapterHeaderImagePath,
      referenceImagePaths: referenceImagePathsList,
      youtubeLink: youtubeLinkController.text,
      subHeadings: subHeadings,
    );

    // Update Chapter object in Hive
    await chapterBox.put(existingChapter.chapterKey, editedChapter);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Chapter edited successfully'),
        backgroundColor: Colors.green, // Set the background color to green
        duration: Duration(seconds: 3), // Set the duration for how long the Snackbar should be displayed
      ),
    );

    Navigator.pop(context);
  }
}