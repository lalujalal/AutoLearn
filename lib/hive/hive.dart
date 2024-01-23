import 'package:hive/hive.dart';
part 'hive.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  late String userId;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late String email;

  @HiveField(3)
  late String password;

  User({required this.userId, required this.name, required this.email, required this.password});
}

@HiveType(typeId: 1)
class Chapter extends HiveObject {
  @HiveField(0)
  late String chapterKey;

  @HiveField(1)
  late String chapterName;

  @HiveField(2)
  late String chapterIconImagePath;

  @HiveField(3)
  late String chapterHeaderImagePath;

  @HiveField(4)
  late List<String> referenceImagePaths;

  @HiveField(5)
  late String youtubeLink;

  @HiveField(6)
  late List<SubHeading> subHeadings;

  Chapter({
    required this.chapterKey,
    required this.chapterName,
    required this.chapterIconImagePath,
    required this.chapterHeaderImagePath,
    required this.referenceImagePaths,
    required this.youtubeLink,
    required this.subHeadings, 
  });
}

@HiveType(typeId: 2)
class SubHeading {
  @HiveField(0)
  late String subHeading;

  @HiveField(1)
  late String subHeadingContent;

  SubHeading({required this.subHeading, required this.subHeadingContent});
}

@HiveType(typeId: 3)
class Question extends HiveObject {
  @HiveField(0)
  final String chapterKey;

  @HiveField(1)
  final String questionKey;

  @HiveField(2)
  final String questionText;

  @HiveField(3)
  final List<String> options;

  @HiveField(4)
  int correctOptionIndex;

  Question({
    required this.chapterKey,
    required this.questionKey,
    required this.questionText,
    required this.options,
    required this.correctOptionIndex,
  });

  void updateCorrectOptionIndex(int newIndex) {
    correctOptionIndex = newIndex;
  }
}

@HiveType(typeId: 4)
class Score extends HiveObject {
  @HiveField(0)
  late String chapterKey;

  @HiveField(1)
  late int correctAnswers;

  @HiveField(2)
  late int incorrectAnswers;

  @HiveField(3)
  late int questionNumber;

  @HiveField(4)
  late bool isCorrect;

  Score({
    required this.chapterKey,
    required this.correctAnswers,
    required this.incorrectAnswers,
    required this.questionNumber,
    required this.isCorrect,
  });
}
