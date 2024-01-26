import 'dart:io';
// import 'package:first_project/Screens/User/quiz.dart';
import 'package:first_project/Screens/User/quiz.dart';
import 'package:flutter/material.dart';
import 'package:first_project/hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DemoChapter extends StatefulWidget {
  final Chapter chapter;

  const DemoChapter({required this.chapter, Key? key}) : super(key: key);

  @override
  DemoChapterState createState() => DemoChapterState();
}

class DemoChapterState extends State<DemoChapter> {
  late Future<void> initialization;
  late YoutubePlayerController ytController;
  final TextEditingController newReferenceImagePathController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initialization = initializeHive();
    final videoId = YoutubePlayer.convertUrlToId(widget.chapter.youtubeLink);
    ytController = YoutubePlayerController(
      initialVideoId: videoId!,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        showLiveFullscreenButton: true,
      ),
    );
  }

  Future<void> initializeHive() async {
    // Initialize Hive
    await Hive.initFlutter('hive_db');

    // Open the chapter box
    await Hive.openBox<Chapter>('chapter');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // Once Hive is initialized, build the UI
          return buildChapterScreen();
        } else {
          // Display a loading indicator while Hive is initializing
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  Widget buildChapterScreen() {
    Chapter demoChapter = widget.chapter;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        toolbarHeight: 120,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          height: 180,
          decoration:BoxDecoration(
            borderRadius:const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight:Radius.circular(30),
            ),
            image: DecorationImage(
              image: FileImage(File(demoChapter.chapterHeaderImagePath)),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 30, top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  iconSize: 35,
                  color: Colors.black,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(width: 50),
                Text(
                  demoChapter.chapterName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Center(
              child: Text(
                ' ${demoChapter.chapterName}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 180,
              child: PageView(
                scrollDirection: Axis.horizontal,
                children: demoChapter.referenceImagePaths.asMap().entries.map(
                  (entry) {
                    int index = entry.key;
                    String referenceImagePath = entry.value;
                    return Column(
                      children: [
                        Image.network(referenceImagePath, width: 150, height: 150),
                        const SizedBox(height: 5),
                        Text(
                          'Fig: ${demoChapter.chapterName}, $index',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                      ],
                    );
                  },
                ).toList(),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Key points',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            for (SubHeading subHeading in demoChapter.subHeadings)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    subHeading.subHeading,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subHeading.subHeadingContent,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const Divider(thickness: 1, color: Colors.grey),
                ],
              ),
            YoutubePlayer(
              controller: ytController,
              showVideoProgressIndicator: true,
            ),
            const SizedBox(height: 10,),
            SizedBox(
              height: 65,
              width: 250,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuizPageDemo(chapterKey: demoChapter.chapterKey,),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 24, 23, 23),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                icon: const Icon(
                  Icons.quiz,
                  size: 30,
                ),
                label: const Text(
                  'Start Quiz',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    ),
  );
  }
}