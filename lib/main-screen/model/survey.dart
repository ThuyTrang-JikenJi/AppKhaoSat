import 'package:appkhaosat/main-screen/model/question.dart';
import 'package:firebase_database/firebase_database.dart';



class Survey {
  final String idUser;
  final String title;
  final String urlImage;
  final Map<String, Question> questions; // thuộc tính chứa danh sách câu hỏi

  Survey({
    required this.idUser,required this.title, required this.urlImage, required this.questions,
  });


  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'idUser': idUser,
      'title': title,
      'urlImage': urlImage,
    };
    Map<String, dynamic> questionsJson = {};
    for (String id in questions.keys) {
      questionsJson[id] = questions[id]!.toJson();
    }
    json['questions'] = questionsJson;
    return json;
  }


  factory Survey.fromSnapshot(DataSnapshot snapshot) {
    Map<dynamic, dynamic> surveyData = snapshot.value as Map<dynamic, dynamic>;

    String idUser = surveyData['idUser'];
    String title = surveyData['title'];
    String urlImage = surveyData['urlImage'];

    Map<dynamic, dynamic> questionData = surveyData['questions'];
    Map<String, Question> questions = {};

    questionData.forEach((key, value) {
      QuestionType questionType = QuestionType.values.firstWhere((e) =>
      e.toString() == 'QuestionType.${value['questionType']}');
      switch (questionType) {
        case QuestionType.text:
          questions[key] = TextQuestion.fromJson(value);
          break;
        case QuestionType.checkbox:
          questions[key] = CheckboxQuestion.fromJson(value);
          break;
        case QuestionType.multiChoice:
          questions[key] = MultiChoiceQuestion.fromJson(value);
          break;
        default:
          throw ArgumentError('Invalid question type');
      }
    });

    return Survey(
      idUser: idUser,
      title: title,
      urlImage: urlImage,
      questions: questions,
    );
  }

}
