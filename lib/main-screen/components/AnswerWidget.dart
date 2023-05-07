import 'package:appkhaosat/main-screen/model/question.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class AnswerWidget extends StatelessWidget {
  final Answer answer;
  final TextEditingController answerTextController;
  final Function(Answer) onAnswerChanged;
  final Function() onAnswerRemoved;
  final bool isMultiChoice;
  final bool isRadioEnabled; // Thêm biến kiểm tra switch vào AnswerWidget


  const AnswerWidget({
    Key? key,
    required this.answer,
    required this.answerTextController,
    required this.onAnswerChanged,
    required this.onAnswerRemoved,
    required this.isMultiChoice,
    required this.isRadioEnabled,

  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        isRadioEnabled
        ? isMultiChoice
            ? Radio(
          value: true,
          groupValue: answer.isCorrect,
          onChanged: (value) {
            onAnswerChanged(answer.copyWith(isCorrect: value ?? false));
          },
        )
            : Checkbox(
          value: answer.isCorrect,
          onChanged: (value) {
            onAnswerChanged(answer.copyWith(isCorrect: value ?? false));
          },
        ): Container(),
        Expanded(
          child: TextField(
            controller: answerTextController,
            decoration: InputDecoration(
              hintText: 'Nhập phương án của bạn',
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
            onChanged: (value) {
              onAnswerChanged(answer.copyWith(text: value));
            },
          ),
        ),
        IconButton(
          onPressed: onAnswerRemoved,
          icon: Icon(Icons.delete),
        ),
      ],
    );
  }
}
