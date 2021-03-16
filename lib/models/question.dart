import 'package:cloud_firestore/cloud_firestore.dart';

class Question {
  final String id, question, answerId, answerDetails, explanation, status;
  final List<QuizOption> options;

  final int creationDateTimeMillis, lastUpdateDateTimemillis;

  final int assignedTimeInSeconds;

  Question({
    this.id,
    this.question,
    this.answerId,
    this.options,
    this.creationDateTimeMillis,
    this.lastUpdateDateTimemillis,
    this.answerDetails,
    this.assignedTimeInSeconds,
    this.explanation,
    this.status,
  });

  factory Question.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data();

    List<QuizOption> optionsList = [];

    var options = data['options'];
    int i = 0;
    while (i < options.length) {
      QuizOption quizOption = QuizOption.fromJson(options[i]);
      optionsList.add(quizOption);
      ++i;
    }

    optionsList.shuffle();

    return Question(
      id: data['id'] ?? null,
      question: data['question'] ?? null,
      answerId: data['answerId'] ?? null,
      options: optionsList,
      creationDateTimeMillis: data['creationDateTimeMillis'] ?? 0,
      lastUpdateDateTimemillis: data['lastUpdateDateTimemillis'] ?? 0,
      answerDetails: data['answerDetails'] ?? null,
      assignedTimeInSeconds: int.tryParse(data['assignedTimeInSeconds']) ?? 0,
      explanation: data['explanation'] ?? null,
      status: data['status'] ?? null,
    );
  }

  factory Question.fromJson(Map<String, dynamic> data) {
    List<QuizOption> optionsList = [];

    var options = data['options'];
    int i = 0;
    while (i < options.length) {
      QuizOption quizOption = QuizOption.fromJson(options[i]);
      optionsList.add(quizOption);
      ++i;
    }
    optionsList.shuffle();
    return Question(
      id: data['id'] ?? null,
      question: data['question'] ?? null,
      answerId: data['answerId'] ?? null,
      options: optionsList,
      creationDateTimeMillis: data['creationDateTimeMillis'] ?? 0,
      lastUpdateDateTimemillis: data['lastUpdateDateTimemillis'] ?? 0,
      answerDetails: data['answerDetails'] ?? null,
      assignedTimeInSeconds: data['assignedTimeInSeconds'] ?? 0,
      explanation: data['explanation'] ?? null,
      status: data['status'] ?? null,
    );
  }

  // @override
  // String toString() =>
  //     'Question(id: $id, question: $question, answerId: $answerId, subjectId: $subjectId, topicId: $topicId, subTopicId: $subTopicId, teacherId: $teacherId, type: $type, options: $options, creationDateTimeMillis: $creationDateTimeMillis, lastUpdateDateTimemillis: $lastUpdateDateTimemillis, answerDetails: $answerDetails, assignedTimeInSeconds: $assignedTimeInSeconds,)';
}

class QuizOption {
  final String id, answer;

  QuizOption({this.id, this.answer});

  factory QuizOption.fromJson(Map<String, dynamic> data) {
    // print(data);
    return QuizOption(
      id: data['id'] ?? null,
      answer: data['answer'],
    );
  }

  @override
  String toString() => 'QuizOption(id: $id, answer: $answer)';
}
