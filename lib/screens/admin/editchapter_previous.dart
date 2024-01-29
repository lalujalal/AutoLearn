import 'package:first_project/Screens/admin/add_chapter.dart';
import 'package:first_project/Screens/admin/edit_chapter.dart';
import 'package:first_project/widgets/chapter_button.dart';
import 'package:flutter/material.dart';
import 'package:first_project/hive/hive.dart';
import 'package:hive/hive.dart';

class AdminChapterEditScreen extends StatefulWidget {
  const AdminChapterEditScreen({Key? key}) : super(key: key);

  @override
  _AdminChapterEditScreenState createState() => _AdminChapterEditScreenState();
}

class _AdminChapterEditScreenState extends State<AdminChapterEditScreen> {
  late Box<Chapter> chapterBox;

  @override
  void initState() {
    super.initState();
    chapterBox = Hive.box<Chapter>('chapter');
    Hive.openBox<Chapter>('chapter').then((value) {
      setState(() {
        chapterBox = value;
      });
    });
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
                    'assets/images/edit.png',
                    height: 45,
                    width: 45,
                  ),
                ),
              ),
              const SizedBox(width: 25),
              const Text(
                'Update Chapters',
                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left:20.0,right: 20,bottom: 20),
        child:chapterBox.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'No Chapters available, Kindly Add Chapters',
                          style: TextStyle(fontSize: 18,),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
    
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const AddChapter()));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey
                          ),
                          child: const Text('Add Chapter'),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 25.0,
                      mainAxisSpacing: 10.0,
                      mainAxisExtent: 136,
                    ),
                    itemCount: chapterBox.length,
                    itemBuilder: (BuildContext context, int index) {
                      Chapter chapter = chapterBox.getAt(index)!;

                      return ChapterEditButton(
                        iconImageUrl: chapter.chapterIconImagePath,
                        buttonText: chapter.chapterName,
                        chapterScreen: EditChapter(chapterKey: chapter.chapterKey),
                        onEditPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditChapter(chapterKey: chapter.chapterKey),
                            ),
                          ).then((value) {
                            // Refresh the page after editing
                            setState(() {});
                          });
                        },
                        onDeletePressed: () {
                          // Implement delete functionality
                          chapterBox.deleteAt(index);
                          // Refresh the page after deletion
                          setState(() {});
                        },
                        showEditButton: true,
                        showDeleteButton: true,
                      );
                    },
                  ),
      ),
    );
  }
}


