import 'package:appkhaosat/main-screen/model/question.dart';

class UserAnswer {
  late QuestionType questionType;
  late String idQuest;
  late dynamic answer;

  UserAnswer({
    required this.questionType,
    required this.idQuest,
    required this.answer,
  });

  factory UserAnswer.fromJson(Map<String, dynamic> json) {
    return UserAnswer(
      questionType: _parseQuestionType(json['questionType']),
      idQuest: json['idQuest'],
      answer: json['answer'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['questionType'] = this.questionType.toString().split('.')[1];
    data['idQuest'] = this.idQuest;
    data['answer'] = this.answer;
    return data;
  }

  static QuestionType _parseQuestionType(String value) {
    switch (value) {
      case 'checkbox':
        return QuestionType.checkbox;
      case 'multiChoice':
        return QuestionType.multiChoice;
      case 'text':
        return QuestionType.text;
      default:
        throw ArgumentError('Invalid question type: $value');
    }
  }

}

