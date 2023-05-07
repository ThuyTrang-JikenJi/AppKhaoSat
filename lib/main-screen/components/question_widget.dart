


import 'package:appkhaosat/main-screen/components/AnswerWidget.dart';
import 'package:appkhaosat/main-screen/model/question.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class QuestionWidget extends StatefulWidget {
  final MultiChoiceQuestion question;
  final Function(MultiChoiceQuestion) onQuestionChanged;
  final Function(MultiChoiceQuestion) onQuestionRemoved;



  const QuestionWidget({
    Key? key,
    required this.question,
    required this.onQuestionChanged,
    required this.onQuestionRemoved,

  }) : super(key: key);

  @override
  _QuestionWidgetState createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  TextEditingController _questionTextController = TextEditingController();
  List<TextEditingController> _answerTextControllers = [];
  bool showRadio = false;


  @override
  void initState() {
    super.initState();
    _questionTextController.text = widget.question.text;
    showRadio = widget.question.hasCorrectAnswer;
    _answerTextControllers.addAll(
      widget.question.answers.map(
            (answer) => TextEditingController(text: answer.text),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
              children: [
                Text(
                  'Câu hỏi trắc nghiệm',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                InkWell(
                  onTap: () {
                    widget.onQuestionRemoved(widget.question);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.remove_circle_outline),
                  ),
                ),

              ]
          ),
          Row(
            children: [
              Text('Có đáp án: '),
              Switch(
                value: showRadio,
                onChanged: (value) {
                  setState(() {
                    showRadio = value;
                    widget.question.hasCorrectAnswer = value;
                    widget.onQuestionChanged(widget.question);



                  });
                },
              ),
            ],
          ),

          SizedBox(height: 8),
          TextField(
            controller: _questionTextController,
            decoration: InputDecoration(
              hintText: 'Nhập câu hỏi của bạn',
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
                borderRadius: BorderRadius.circular(10.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 1.0),
                borderRadius: BorderRadius.circular(10.0),
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            ),
            maxLines: null,
            onChanged: (value) {
              setState(() {
                widget.onQuestionChanged(
                  widget.question.copyWith(text: value),
                );
              });
            },
          ),
          SizedBox(height: 16),
          Text(
            'Các phương án trả lời',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          SizedBox(height: 8),
          Column(
            children: widget.question.answers
                .asMap()
                .map((index, answer) =>
                MapEntry(
                  index,
                  AnswerWidget(
                    isRadioEnabled: showRadio,
                    answer: answer,
                    answerTextController: _answerTextControllers[index],
                    isMultiChoice: true,
                    onAnswerChanged: (newAnswer) {
                      setState(() {
                        _handleCheckAnswer(index);
                        widget.question.answers[index] = newAnswer;
                        widget.onQuestionChanged(widget.question);

                      });
                    },
                    onAnswerRemoved: () {
                      setState(() {
                        widget.question.answers.removeAt(index);
                        _answerTextControllers.removeAt(index);
                        widget.onQuestionChanged(widget.question);
                      });
                    },
                  ),
                ))
                .values
                .toList(),
          ),
          SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                widget.question.answers.add(Answer('', isCorrect: false));
                _answerTextControllers.add(TextEditingController());
                widget.onQuestionChanged(widget.question);
              });
            },
            icon: Icon(Icons.add),
            label: Text('Thêm phương án trả lời'),
          ),
        ],
      ),
    );
  }

  void _handleCheckAnswer(int answerIndex) {
    setState(() {
      for (int i = 0; i < widget.question.answers.length; i++) {
        if (i == answerIndex) {
          widget.question.answers[i] =
              widget.question.answers[i].copyWith(isCorrect: true);
        } else {
          // Automatically remove isCorrect flag from other answers
          widget.question.answers[i] =
              widget.question.answers[i].copyWith(isCorrect: false);
        }
      }
    });
  }
}
