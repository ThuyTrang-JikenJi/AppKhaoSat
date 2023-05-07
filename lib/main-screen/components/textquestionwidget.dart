import 'package:appkhaosat/main-screen/model/question.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class TextQuestionWidget extends StatefulWidget {
  final TextQuestion question;
  final Function(TextQuestion) onQuestionChanged;
  final Function(TextQuestion) onQuestionRemoved;

  const TextQuestionWidget({
    Key? key,
    required this.question,
    required this.onQuestionChanged,
    required this.onQuestionRemoved,
  }) : super(key: key);

  @override
  _TextQuestionWidgetState createState() => _TextQuestionWidgetState();
}

class _TextQuestionWidgetState extends State<TextQuestionWidget> {
  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textEditingController.text = widget.question.text;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextFormField(
                  controller: _textEditingController,
                  decoration: InputDecoration(
                    labelText: 'Câu hỏi văn bản',
                    hintText: 'Nhập câu hỏi',
                    border: OutlineInputBorder(),
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
                  // style: TextStyle(fontSize: 13),
                  onChanged: (value) {
                    widget.onQuestionChanged(
                      widget.question.copyWith(text: value),
                    );
                  },
                ),
              ),
              InkWell(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.check_circle_outline),
                ),
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  widget.onQuestionRemoved(widget.question);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
