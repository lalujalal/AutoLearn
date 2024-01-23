// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 0;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      userId: fields[0] as String,
      name: fields[1] as String,
      email: fields[2] as String,
      password: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.password);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ChapterAdapter extends TypeAdapter<Chapter> {
  @override
  final int typeId = 1;

  @override
  Chapter read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Chapter(
      chapterKey: fields[0] as String,
      chapterName: fields[1] as String,
      chapterIconImagePath: fields[2] as String,
      chapterHeaderImagePath: fields[3] as String,
      referenceImagePaths: (fields[4] as List).cast<String>(),
      youtubeLink: fields[5] as String,
      subHeadings: (fields[6] as List).cast<SubHeading>(),
    );
  }

  @override
  void write(BinaryWriter writer, Chapter obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.chapterKey)
      ..writeByte(1)
      ..write(obj.chapterName)
      ..writeByte(2)
      ..write(obj.chapterIconImagePath)
      ..writeByte(3)
      ..write(obj.chapterHeaderImagePath)
      ..writeByte(4)
      ..write(obj.referenceImagePaths)
      ..writeByte(5)
      ..write(obj.youtubeLink)
      ..writeByte(6)
      ..write(obj.subHeadings);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChapterAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SubHeadingAdapter extends TypeAdapter<SubHeading> {
  @override
  final int typeId = 2;

  @override
  SubHeading read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SubHeading(
      subHeading: fields[0] as String,
      subHeadingContent: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SubHeading obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.subHeading)
      ..writeByte(1)
      ..write(obj.subHeadingContent);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubHeadingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class QuestionAdapter extends TypeAdapter<Question> {
  @override
  final int typeId = 3;

  @override
  Question read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Question(
      chapterKey: fields[0] as String,
      questionKey: fields[1] as String,
      questionText: fields[2] as String,
      options: (fields[3] as List).cast<String>(),
      correctOptionIndex: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Question obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.chapterKey)
      ..writeByte(1)
      ..write(obj.questionKey)
      ..writeByte(2)
      ..write(obj.questionText)
      ..writeByte(3)
      ..write(obj.options)
      ..writeByte(4)
      ..write(obj.correctOptionIndex);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuestionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ScoreAdapter extends TypeAdapter<Score> {
  @override
  final int typeId = 4;

  @override
  Score read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Score(
      chapterKey: fields[0] as String,
      correctAnswers: fields[1] as int,
      incorrectAnswers: fields[2] as int,
      questionNumber: fields[3] as int,
      isCorrect: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Score obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.chapterKey)
      ..writeByte(1)
      ..write(obj.correctAnswers)
      ..writeByte(2)
      ..write(obj.incorrectAnswers)
      ..writeByte(3)
      ..write(obj.questionNumber)
      ..writeByte(4)
      ..write(obj.isCorrect);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScoreAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
