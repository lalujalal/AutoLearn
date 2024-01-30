import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:first_project/hive/hive.dart';
import 'package:first_project/Screens/User/chapter.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({Key? key}) : super(key: key);

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  late Box<Chapter> chapterBox;

  @override
  void initState() {
    super.initState();
   chapterBox = Hive.box<Chapter>('chapter');
    Hive.openBox<Chapter>('chapter').then((value) {
      setState(() {
        chapterBox = value;
      }); 
      print('Chapter Box Length: ${chapterBox.length}');
      for (int i = 0; i < chapterBox.length; i++) {
        Chapter chapter = chapterBox.getAt(i)!;
        print('Chapter $i - Name: ${chapter.chapterName}, Icon: ${chapter.chapterIconImagePath}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  body: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Container(
        height: 130,
        decoration: const BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          image: DecorationImage(
            image: AssetImage('assets/images/home_header.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.menu),
                  iconSize: 35,
                  color: Colors.white,
                  onPressed: () {},
                ),
                const SizedBox(
                  width: 100,
                ),
                const Text(
                  'Home',
                  textAlign: TextAlign.center,
                  style: TextStyle(
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
       Padding(
        padding: const EdgeInsets.only(bottom: 20,left: 20,right: 20),
        child:chapterBox.isEmpty
                ? const Center(
                    child: Text(
                      'There are no chapters added. Kindly contact the admin to add chapters.',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                  : GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 25.0,
                      mainAxisSpacing: 10.0,
                      mainAxisExtent: 110,
                    ),
                    itemCount: chapterBox.length,
                    itemBuilder: (BuildContext context, int index) {
                      Chapter chapter = chapterBox.getAt(index)!;

                      return ChapterButton(
                      iconImageUrl: chapter.chapterIconImagePath,
                      buttonText: chapter.chapterName,
                      chapterScreen: DemoChapter(chapter: chapter),
                    );
                    },
                  ),
      ),
    ],
  ),
);
  }
}


class ChapterButton extends StatelessWidget {
  final String iconImageUrl;
  final String buttonText;
  final Widget chapterScreen;

  ChapterButton({
    required this.iconImageUrl,
    required this.buttonText,
    required this.chapterScreen,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print('Chapter Button Tapped: $buttonText');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => chapterScreen,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: const Color(0xffE4DDDD),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.file(
              File(iconImageUrl),
              width: 75,
              height: 75,
            ),
            Text(
              buttonText,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


