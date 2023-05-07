import 'package:appkhaosat/main-screen/model/question.dart';
import 'package:appkhaosat/main-screen/model/survey.dart';
import 'package:appkhaosat/main-screen/model/useranswer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SurveyPage extends StatefulWidget {
  final Survey survey;
  final String? surveyKeys;
  SurveyPage({required this.survey, required this.surveyKeys});

  @override
  _SurveyPageState createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  late List<UserAnswer> _userAnswers = List.generate(
      widget.survey.questions.length,
      (index) => UserAnswer(
          questionType: QuestionType.text, idQuest: '', answer: null));
  bool _isSurveyLoaded = false;

  @override
  void initState() {
    super.initState();
  }

  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  Future<void> saveUserAnswers(
      String surveyId, List<UserAnswer> answers) async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DatabaseReference ref =
            _database.child('userAnswers').child(surveyId).child(user.uid);
        Map<String, dynamic> answersJson = {};
        for (int i = 0; i < answers.length; i++) {
          //print(answers[i].toJson());
          answersJson[answers[i].idQuest] = answers[i].toJson();
        }
        await ref.set(answersJson);
        Fluttertoast.showToast(msg: 'Cảm ơn! Bạn đã làm khảo sát thành công');
        Navigator.pop(context);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Gặp lỗi trong quá trình lưu');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Form khảo sát'),
        actions: [
          IconButton(
            onPressed: () {
              //print(_userAnswers[1].answer);
              // Tạo đối tượng UserAnswer mới

              saveUserAnswers(widget.surveyKeys!, _userAnswers);
            },
            icon: Icon(Icons.send),
          ),
        ],
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
                  for (int i = 0; i < widget.survey.questions.length; i++)
                    _buildQuestionWidget(i),
                ],
              ),
      ),
    );
  }

  Widget _buildQuestionWidget(int index) {
    Question question = widget.survey.questions.values.toList()[index];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (question.text.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              question.text,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          ),
        if (question is TextQuestion)
          TextFormField(
            onChanged: (value) {
              setState(() {
                //print(question.idQuest);
                _userAnswers[index].idQuest = question.idQuest;
                _userAnswers[index].questionType = question.questionType;

                _userAnswers[index].answer = value;
              });
            },
            decoration: InputDecoration(
              hintText: "Câu trả lời của bạn",
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your answer';
              }
              return null;
            },
          ),
        if (question is CheckboxQuestion)
          for (int i = 0; i < question.answers.length; i++)
            ListTile(
              title: Text(question.answers[i].text),
              leading: Checkbox(
                value: _userAnswers[index]
                        .answer
                        ?.contains(question.answers[i].text) ??
                    false,
                onChanged: (value) {
                  setState(() {
                    //print(value);

                    List<String> answer = _userAnswers[index].answer != null
                        ? _userAnswers[index].answer.cast<String>()
                        : [];

                    //Set<String> answer = _userAnswers[index].answer.cast<String>()?.toSet() ?? {};
                    if (value == true) {
                      answer.add(question.answers[i].text);
                    } else {
                      answer.remove(question.answers[i].text);
                    }

                    _userAnswers[index].idQuest = question.idQuest;
                    _userAnswers[index].questionType = question.questionType;
                    _userAnswers[index].answer = answer.toList();
                  });
                },
              ),
            ),
        if (question is MultiChoiceQuestion)
          for (int i = 0; i < question.answers.length; i++)
            RadioListTile(
              title: Text(question.answers[i].text),
              value: question.answers[i].text,
              groupValue: _userAnswers[index].answer,
              onChanged: (value) {
                setState(() {
                  _userAnswers[index].idQuest = question.idQuest;
                  _userAnswers[index].questionType = question.questionType;
                  _userAnswers[index].answer = value;
                });
              },
            ),
      ],
    );
  }
}
