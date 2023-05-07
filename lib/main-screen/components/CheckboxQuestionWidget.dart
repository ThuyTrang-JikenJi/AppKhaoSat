import 'package:appkhaosat/main-screen/components/AnswerWidget.dart';
import 'package:appkhaosat/main-screen/model/question.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CheckboxQuestionWidget extends StatefulWidget {
  final CheckboxQuestion question;
  final Function(CheckboxQuestion) onQuestionChanged;
  final Function(CheckboxQuestion) onQuestionRemoved;

  const CheckboxQuestionWidget({
    Key? key,
    required this.question,
    required this.onQuestionChanged,
    required this.onQuestionRemoved,
  }) : super(key: key);

  @override
  _CheckboxQuestionWidgetState createState() => _CheckboxQuestionWidgetState();
}

class _CheckboxQuestionWidgetState extends State<CheckboxQuestionWidget> {
  TextEditingController _questionTextController = TextEditingController();
  List<TextEditingController> _answerTextControllers = [];
  List<bool> _answerCheckboxValues = [];
  bool showCheckbox = false;

  @override
  void initState() {
    super.initState();
    _questionTextController.text = widget.question.text;
    showCheckbox = widget.question.hasCorrectAnswer;
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
          Row(children: [
            Text(
              'Câu hỏi checkbox',
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
          ]),
          Row(
            children: [
              Text(
                'Có đáp án: ',
              ),
              Switch(
                value: showCheckbox,
                onChanged: (value) {
                  setState(() {
                    showCheckbox = value;
                    widget.question.hasCorrectAnswer = value;
                    widget.onQuestionChanged(widget.question);
                  });
                },
              ),
            ],
          ),
          TextField(
            controller: _questionTextController,
            decoration: InputDecoration(
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
              hintText: 'Nhập câu hỏi của bạn',
              border: OutlineInputBorder(),
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
            'Các tùy chọn',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          SizedBox(height: 8),
          Column(
            children: widget.question.answers
                .asMap()
                .map((index, answer) => MapEntry(
                      index,
                      AnswerWidget(
                        isRadioEnabled: showCheckbox,
                        answer: answer,
                        answerTextController: _answerTextControllers[index],
                        isMultiChoice: false,
                        onAnswerChanged: (newAnswer) {
                          setState(() {
                            _answerCheckboxValues[index] = newAnswer.isCorrect;
                            widget.question.answers[index] = newAnswer;
                            widget.onQuestionChanged(widget.question);
                          });
                        },
                        onAnswerRemoved: () {
                          setState(() {
                            widget.question.answers.removeAt(index);
                            _answerTextControllers.removeAt(index);
                            _answerCheckboxValues.removeAt(index);
                            //widget.onQuestionChanged(widget.question);
                          });
                        },
                      ),
                    ))
                .values
                .toList(),
          ),
          SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                widget.question.answers.add(
                  Answer('', isCorrect: false),
                );
                _answerTextControllers.add(TextEditingController());
                _answerCheckboxValues.add(false);
                widget.onQuestionChanged(widget.question);
              });
            },
            icon: Icon(Icons.add),
            label: Text('Thêm tùy chọn'),
          ),
        ],
      ),
    );
  }
}
