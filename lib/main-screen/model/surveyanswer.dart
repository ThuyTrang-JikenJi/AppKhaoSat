import 'package:appkhaosat/main-screen/model/useranswer.dart';
import 'package:firebase_database/firebase_database.dart';

class SurveyAnswer {
  late Map<String, UserAnswer> userAnswers;

  SurveyAnswer({
    required this.userAnswers,
  });

  factory SurveyAnswer.fromSnapshot(DataSnapshot snapshot) {
    Map<String, UserAnswer> userAnswers = {};
    Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
    //print(data);
    if (data != null) {
      data.forEach((key, value) {
        Map<String, dynamic> answer = Map<String, dynamic>.from(value);
        UserAnswer userAnswer = UserAnswer.fromJson(answer);
        userAnswers[key] = userAnswer;
      });
    }
    return SurveyAnswer(userAnswers: userAnswers);
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    final Map<String, dynamic> answers = {};
    userAnswers.forEach((key, value) {
      final Map<String, dynamic> answer = value.toJson();
      answers[key] = answer;
    });
    data['userAnswers'] = answers;
    return data;
  }
}
