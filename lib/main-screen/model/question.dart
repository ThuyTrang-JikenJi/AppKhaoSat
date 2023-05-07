enum QuestionType { text, multiChoice, checkbox }

abstract class Question {
  late final String idQuest;
  late final String text;
  final QuestionType questionType;
  late bool hasCorrectAnswer;

  Question(this.idQuest,this.text, this.questionType, this.hasCorrectAnswer);

  Map<String, dynamic> toJson() {
    return {
      'idQuest': idQuest,
      'text': text,
      'questionType': questionType.toString().split('.')[1], // Lấy tên enum
      'hasCorrectAnswer': hasCorrectAnswer,
    };
  }

  static Question fromJson(Map<dynamic, dynamic> json) {
    QuestionType questionType = QuestionType.values.firstWhere((e) => e.toString() == 'QuestionType.${json['questionType']}');
    switch (questionType) {
      case QuestionType.text:
        return TextQuestion.fromJson(json);
      case QuestionType.checkbox:
        return CheckboxQuestion.fromJson(json);
      case QuestionType.multiChoice:
        return MultiChoiceQuestion.fromJson(json);
      default:
        throw ArgumentError('Invalid question type');
    }
  }
}

class TextQuestion extends Question {
  TextQuestion(String idQuest,String text) : super(idQuest, text, QuestionType.text,false);

  TextQuestion copyWith({
    String? idQuest,
    String? text,
  }) {
    return TextQuestion(
      idQuest ?? this.idQuest,
      text ?? this.text,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    return json;
  }


  static TextQuestion fromJson(Map<dynamic, dynamic> json) {
    String text = json['text'];
    String idQuest = json['idQuest'];
    return TextQuestion(idQuest, text);
  }

}


class CheckboxQuestion extends Question {
  List<Answer> answers;

  CheckboxQuestion(String idQuest,String text, {List<Answer>? answers})
      : this.answers = answers ?? [],
        super(idQuest,text, QuestionType.checkbox,_hasCorrectAnswer(answers));

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json.addAll({'answers': answers.map((a) => a.toJson()).toList()});
    return json;
  }

  static bool _hasCorrectAnswer(List<Answer>? answers) {
    return answers?.any((a) => a.isCorrect) ?? false;
  }

  CheckboxQuestion copyWith({String? idQuest,String? text, List<Answer>? answers}) {
    final newText = text ?? this.text;
    return CheckboxQuestion(
      idQuest ?? this.idQuest,
      newText,
      answers: answers ?? this.answers,
    );
  }

  factory CheckboxQuestion.fromJson(Map<dynamic, dynamic> json) {
    final List<dynamic> answerData = json['answers'];
    final List<Answer> answers = answerData.map((a) => Answer.fromJson(a)).toList();
    final String text = json['text'];
    final bool hasCorrectAnswer = json['hasCorrectAnswer'];
    final String idQuest = json['idQuest'];
    return CheckboxQuestion(idQuest,text, answers: answers)
      ..hasCorrectAnswer = hasCorrectAnswer;
  }
}



class MultiChoiceQuestion extends Question {
  List<Answer> answers;


  MultiChoiceQuestion(String idQuest,String text, {List<Answer>? answers})
      : this.answers = answers ?? [],
        super(idQuest,text, QuestionType.multiChoice,_hasCorrectAnswer(answers));

  static bool _hasCorrectAnswer(List<Answer>? answers) {
    return answers?.any((a) => a.isCorrect) ?? false;
  }


  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json.addAll({'answers': answers.map((a) => a.toJson()).toList()});
    return json;
  }

  MultiChoiceQuestion copyWith({String? idQuest,String? text, List<Answer>? answers}) {
    final newText = text ?? this.text;
    return MultiChoiceQuestion(
      idQuest ?? this.idQuest,
      newText,
      answers: answers ?? this.answers,
    );
  }

  factory MultiChoiceQuestion.fromJson(Map<dynamic, dynamic> json) {
    final List<Answer> answers = (json['answers'] as List<dynamic>)
        .map((a) => Answer.fromJson(a))
        .toList();

    return MultiChoiceQuestion(
      json['idQuest'],
      json['text'],
      answers: answers,
    );
  }

}

class Answer {
  final String text;
  bool isCorrect;

  Answer copyWith({
    String? text,
    bool? isCorrect,
  }) {
    return Answer(
      text ?? this.text,
      isCorrect: isCorrect ?? this.isCorrect,
    );
  }

  Answer(this.text, {this.isCorrect = false});

  Map<String, dynamic> toJson() => {'text': text, 'isCorrect': isCorrect};

  factory Answer.fromJson(Map<dynamic, dynamic> json) {
    return Answer(
      json['text'],
      isCorrect: json['isCorrect'] ?? false,
    );
  }
}
