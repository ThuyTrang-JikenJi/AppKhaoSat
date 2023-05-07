import 'dart:ffi';

import 'package:appkhaosat/main-screen/chart.dart';
import 'package:appkhaosat/main-screen/model/question.dart';
import 'package:appkhaosat/main-screen/model/survey.dart';
import 'package:appkhaosat/main-screen/model/surveyanswer.dart';
import 'package:appkhaosat/main-screen/model/useranswer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class DetailSurveyPage extends StatefulWidget {
  final Survey survey;
  final String? surveyKeys;
  DetailSurveyPage({required this.survey,required this.surveyKeys});


  @override
  DetailSurveyPageState createState() => DetailSurveyPageState();
}

class DetailSurveyPageState extends State<DetailSurveyPage> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  late Map<String,dynamic> listanswer = {};
  late Map<String,Map<String,double>> rateOfanswer = {};
  bool _isSurveyLoaded = true;
  late List<SurveyAnswer> _surveyAnswer = [];
  late Map<String,List<String>> answerText = {};

  @override
  void initState() {
    super.initState();
    getListQuestText();
    getListSurvey();

    //print(widget.survey.questions);
    //print(tinhPhanTram(_surveyAnswer).length);
  }



  void getListSurvey(){
    try{
      DatabaseReference surveyRef = _database.child('userAnswers')
          .child(widget.surveyKeys!);

      surveyRef.onChildAdded.listen((event) {
        SurveyAnswer surveyAnswer = SurveyAnswer.fromSnapshot(event.snapshot);
        setState(() {
          _surveyAnswer.add(surveyAnswer);
          _isSurveyLoaded = false;
          rateOfanswer = tinhPhanTram(_surveyAnswer);
          answerText = getAnsText(_surveyAnswer);
        });
      });



    } catch(e)
    {
      Fluttertoast.showToast(msg: 'Gặp lỗi trong quá trình lấy dữ liệu');
    }
  }

  void getListQuestText() {
    Map<String, Question> questions = widget.survey.questions;

    questions.forEach((key, question) {
      for (final question in questions.values) {
          final answers = question.text;
          if(question.questionType == QuestionType.text)
          listanswer.putIfAbsent(question.idQuest, () => answers);
      }

    });
    //print(listanswer);
  }

  Map<String,List<String>> getAnsText(List<SurveyAnswer> surveyAns) {
    Map<String,List<String>> AnsText = {};

    surveyAns.forEach((surveyAnswer) {
      surveyAnswer.userAnswers.forEach((questionId, answer) {
        if(answer.questionType == QuestionType.text) {
          String ans = answer.answer;
          List<String> answers = AnsText.putIfAbsent(questionId, () => []);
          if (!answers.contains(ans)) {
            answers.add(ans);
            AnsText[questionId] = answers;
          }
        }
      });
    });
    //print(AnsText);
    return AnsText;
  }



  Map<String,Map<String,double>> tinhPhanTram(List<SurveyAnswer> surveyAns){
    int people = surveyAns.length;
    late Map<String,Map<String,double>> SoLanXuatHien = {};

    // Duyệt qua các người tham gia khảo sát
    surveyAns.forEach((surveyAnswer) {

      // Duyệt qua các câu hỏi của khảo sát
      surveyAnswer.userAnswers.forEach((questionId, answer) {

          if(answer.answer is List<Object?>)
            {
              Map<String, double> answerCount = SoLanXuatHien[questionId] ?? {};

              final answ = answer.answer;

              answ.forEach((index) {
                answerCount[index!] = (answerCount[index] ?? 0) + 1/people;
              });

              SoLanXuatHien.putIfAbsent(questionId, () => answerCount);
            }else if(answer.questionType == QuestionType.multiChoice)
              {
                Map<String, double> answerCount = SoLanXuatHien[questionId] ?? {};

                final answ = answer.answer;

                answerCount[answ] = (answerCount[answ] ?? 0) + 1/people;

                SoLanXuatHien.putIfAbsent(questionId, () => answerCount);
              }

      });

    });
    //print(SoLanXuatHien);
    return SoLanXuatHien;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông tin khảo sát'),

      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: _isSurveyLoaded
            ? Center(child: CircularProgressIndicator())
            : Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.survey.urlImage.isNotEmpty)
              Image.network(
                widget.survey.urlImage,
                fit: BoxFit.cover,
              ),
            SizedBox(height: 16.0),
            Text(
              widget.survey.title,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.0),
            PieChart(rateOfanswer: rateOfanswer,survey: widget.survey,answerText: answerText,),

          ],
        ),
      ),
    );
  }

}


