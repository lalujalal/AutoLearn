import 'package:first_project/hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart' as path;


late Box<User> user;
late Box<Chapter> chapter;
late Box<Question> question;
late Box<Score> score;

Future<void> initializeHive() async {
  final dir = await path.getApplicationDocumentsDirectory();
  Hive.init(dir.path);

  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(ChapterAdapter());
  Hive.registerAdapter(SubHeadingAdapter());
  Hive.registerAdapter(QuestionAdapter());
  Hive.registerAdapter(ScoreAdapter());

  await Hive.initFlutter('hive_db');
}
