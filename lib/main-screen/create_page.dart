import 'dart:convert';

import 'package:appkhaosat/main-screen/components/CheckboxQuestionWidget.dart';
import 'package:appkhaosat/main-screen/components/question_widget.dart';
import 'package:appkhaosat/main-screen/components/textquestionwidget.dart';
import 'package:appkhaosat/main-screen/model/question.dart';
import 'package:appkhaosat/main-screen/model/survey.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

class MyQuizPage extends StatefulWidget {
  @override
  _MyQuizPageState createState() => _MyQuizPageState();
}

class _MyQuizPageState extends State<MyQuizPage> {
  TextEditingController _titleController = TextEditingController();
  final uuid = Uuid();
  Map<String, Question> _questions = {};
  final picker = ImagePicker();
  File? _imageFile;
  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
  }

  Future<String?> _getUserId() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      return user.uid;
    }
    return null;
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    setState(() {
      _imageFile = pickedFile != null ? File(pickedFile.path) : null;
    });
  }

  Future<String?> _uploadImage() async {
    final String? userId = await _getUserId();
    if (userId == null) {
      // User is not authenticated, handle accordingly
      return null;
    }
    if (_imageFile != null) {
      // Upload image to Firebase Storage
      final fileName = path.basename(_imageFile!.path);
      final Reference ref =
          storage.ref().child('ImageSurveys/$userId/$fileName');
      final metadata = SettableMetadata(
        contentType: 'image/jpeg',
      );
      final UploadTask uploadTask = ref.putFile(_imageFile!, metadata);
      final TaskSnapshot downloadUrl = (await uploadTask);
      String link = await downloadUrl.ref.getDownloadURL();
      return link;
      // TODO: Display image from URL
    } else {
      return null;
    }
  }

  Future<void> saveSurvey() async {
    try {
      final databaseRef = FirebaseDatabase.instance.ref();
      final User? user = FirebaseAuth.instance.currentUser;
      final newSurveyRef = databaseRef
          .child('surveys')
          .push(); // Tạo reference mới với ID tự động

      late Survey mySurvey;
      String? url = await _uploadImage();

      final questionsJson = <String, dynamic>{};
      _questions.forEach((idQuest, question) {
        questionsJson[idQuest] = question.toJson();
      });

      if (url == null) {
        mySurvey = Survey(
            idUser: user!.uid,
            title: _titleController.text,
            urlImage:
                "https://images.unsplash.com/photo-1506744038136-46273834b3fb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=750&q=80",
            questions: _questions);
      } else {
        mySurvey = Survey(
            idUser: user!.uid,
            title: _titleController.text,
            urlImage: url,
            questions: _questions);
      }
      await newSurveyRef.set(mySurvey.toJson());
      Fluttertoast.showToast(msg: 'Lưu khảo sát thành công');
      Navigator.pop(context);
    } catch (e) {
      Fluttertoast.showToast(msg: 'Gặp lỗi');
    }
  }

  // Add your state variables and functions here
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tạo khảo sát"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 88, 169, 212),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 0.0),
            child: TextField(
              controller: _titleController,
              textAlign: TextAlign.center,
              inputFormatters: [UpperCaseTextFormatter()],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                labelText: 'Tiêu đề của khảo sát',
                labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 1.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              ),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 16),
                  _imageFile == null
                      ? Text(
                          'Hãy chọn hình ảnh mô tả khảo sát',
                          style: TextStyle(fontSize: 16.0),
                        )
                      : AspectRatio(
                          aspectRatio: 3 / 1,
                          child: Image.file(
                            _imageFile!,
                            fit: BoxFit.cover,
                          ),
                        ),
                  ElevatedButton(
                    onPressed: () => _pickImage(ImageSource.camera),
                    child: Text(
                      'Chụp hình mô tả',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    child: Text('Lấy hình mô tả từ thư viện'),
                  ),
                  SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _questions.values.length,
                    itemBuilder: (BuildContext context, int index) {
                      final question = _questions.values.toList()[index];
                      switch (question.questionType) {
                        case QuestionType.text:
                          return TextQuestionWidget(
                            question: question as TextQuestion,
                            onQuestionChanged: (updatedQuestion) {
                              setState(() {
                                _questions[updatedQuestion.idQuest] =
                                    updatedQuestion;
                              });
                            },
                            onQuestionRemoved: (removedQuestion) {
                              setState(() {
                                _questions.remove(removedQuestion.idQuest);
                              });
                            },
                          );
                          break;
                        case QuestionType.multiChoice:
                          return QuestionWidget(
                            question: question as MultiChoiceQuestion,
                            onQuestionChanged: (updatedQuestion) {
                              setState(() {
                                _questions[updatedQuestion.idQuest] =
                                    updatedQuestion;
                              });
                            },
                            onQuestionRemoved: (removedQuestion) {
                              setState(() {
                                _questions.remove(removedQuestion.idQuest);
                              });
                            },
                          );
                          break;
                        case QuestionType.checkbox:
                          return CheckboxQuestionWidget(
                            question: question as CheckboxQuestion,
                            onQuestionChanged: (updatedQuestion) {
                              setState(() {
                                _questions[updatedQuestion.idQuest] =
                                    updatedQuestion;
                              });
                            },
                            onQuestionRemoved: (removedQuestion) {
                              setState(() {
                                _questions.remove(removedQuestion.idQuest);
                              });
                            },
                          );
                          break;
                        default:
                          return SizedBox.shrink();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: SpeedDial(
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
        children: [
          SpeedDialChild(
            child: Icon(Icons.check_circle_rounded, color: Colors.purple),
            //backgroundColor: Colors.blue,
            label: 'Lưu khảo sát',
            labelStyle: TextStyle(fontSize: 16.0),
            onTap: () {
              saveSurvey();
              _questions.forEach((idQuest, question) {});
            },
          ),
          SpeedDialChild(
            child: Icon(
              Icons.radio_button_checked,
              color: Colors.purple,
            ),
            //backgroundColor: Colors.blue,
            label: 'Thêm câu hỏi trắc nghiệm',
            labelStyle: TextStyle(fontSize: 16.0),
            onTap: () {
              _addQuestion();
              // addQuestion(QuestionType.MultipleChoice);
            },
          ),
          SpeedDialChild(
            child: Icon(
              Icons.check_box,
              color: Colors.purple,
            ),
            //backgroundColor: Colors.blue,
            label: 'Thêm câu hỏi checkbox',
            labelStyle: TextStyle(fontSize: 16.0),
            onTap: () {
              _addCheckboxQuestion();
              // addQuestion(QuestionType.Checkbox);
            },
          ),
          SpeedDialChild(
            child: Icon(
              Icons.short_text,
              color: Colors.purple,
            ),
            //backgroundColor: Colors.blue,
            label: 'Thêm câu hỏi trả lời văn bản',
            labelStyle: TextStyle(fontSize: 16.0),
            onTap: () {
              _addQuestiontText();
            },
          ),
        ],
      ),
    );
  }

  void _addQuestion() {
    Question newQuestion = MultiChoiceQuestion(uuid.v4(), '', answers: []);
    setState(() {
      _questions[newQuestion.idQuest] = newQuestion;
    });
  }

  void _addCheckboxQuestion() {
    Question newQuestion = CheckboxQuestion(uuid.v4(), '', answers: []);
    setState(() {
      _questions[newQuestion.idQuest] = newQuestion;
    });
  }

  void _addQuestiontText() {
    Question newQuestion = TextQuestion(uuid.v4(), '');
    setState(() {
      _questions[newQuestion.idQuest] = newQuestion;
    });
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
