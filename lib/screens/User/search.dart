import 'package:first_project/Screens/User/chapter.dart';
import 'package:first_project/widgets/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:first_project/hive/hive.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late List<Chapter> allChapters;
  List<Chapter> filteredChapters = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Load all chapters from Hive
    allChapters = Hive.box<Chapter>('chapter').values.toList();
    // Initially, set filteredChapters to an empty list
    filteredChapters = [];
  }

  void searchChapters(String query) async {
    setState(() {
      isLoading = true;
    });
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      if (query.isEmpty) {
        filteredChapters = [];
      } else {
        filteredChapters = allChapters
            .where((chapter) =>
                chapter.chapterName
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                chapter.subHeadings.any((subHeading) =>
                    subHeading.subHeading
                        .toLowerCase()
                        .contains(query.toLowerCase()) ||
                    subHeading.subHeadingContent
                        .toLowerCase()
                        .contains(query.toLowerCase())))
            .toList();
      }
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 100,
        flexibleSpace: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: const TopBar(),
            ),
            Positioned(
              top: 55,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  onChanged: (query) => searchChapters(query),
                  decoration: const InputDecoration(
                    hintText: 'Search...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12,horizontal: 4),
                    suffixIcon: Icon(Icons.search),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : filteredChapters.isEmpty
              ? const Center(
                  child: Text(
                    'Type in the search bar to find chapters.',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  itemCount: filteredChapters.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(filteredChapters[index].chapterName),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5),
                          const Text('Subheadings:'),
                          for (SubHeading subHeading
                              in filteredChapters[index].subHeadings)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 5),
                                Text(subHeading.subHeading),
                                Text(subHeading.subHeadingContent),
                              ],
                            ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DemoChapter(chapter: filteredChapters[index]),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}