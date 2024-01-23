import 'package:first_project/hive/hive.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart' as path;


late Box<User> user;
late Box<Chapter> chapter;
late Box<Question> question;
late Box<Score> score;
Future<void> initializeHive() async {
  final dir = await path.getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  await Hive.initFlutter('hive_db');

  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(ChapterAdapter());
  Hive.registerAdapter(SubHeadingAdapter());
  Hive.registerAdapter(QuestionAdapter());
  Hive.registerAdapter(ScoreAdapter());

  user = await Hive.openBox<User>('user');
  chapter = await Hive.openBox<Chapter>('chapter');
  question = await Hive.openBox<Question>('question');
  score = await Hive.openBox<Score>('score');
}