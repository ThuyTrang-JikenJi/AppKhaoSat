import 'dart:math' as math;
import 'package:appkhaosat/main-screen/model/survey.dart';
import 'package:flutter/material.dart';

class PieChart extends StatelessWidget {
  final Map<String,Map<String,double>> rateOfanswer;
  final Survey survey;
  final Map<String,List<String>> answerText;


  PieChart({required this.rateOfanswer,required this.survey, required this.answerText});

  @override
  Widget build(BuildContext context) {
    List<String> _idQuest = [];
    List<String> _idQuestText = [];

    _idQuest = rateOfanswer.keys.toList();
    _idQuestText =  answerText.keys.toList();

    List<Widget> getCharts(List<String> idQuest) {
      final List<Widget> charts = [];


      for (final id in idQuest) {
        final Map<String, double> data = rateOfanswer[id]!;
        final List<Color> colors = List.generate(
          data.length,
              (index) => Color.fromRGBO(
            math.Random().nextInt(256),
                math.Random().nextInt(256),
                math.Random().nextInt(256),
            1,
          ),
        );

        charts.add(
          Column(
            children: [
              SizedBox(height: 20.0),
              Text(
                survey.questions[id]!.text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              SizedBox(
                height: 150,
                width: 150,
                child: CustomPaint(
                  painter: PieChartPainter(data, colors),
                ),
              ),

              Column(
                children: [
                  for (final entry in data.entries)
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 8),
                          width: 12,
                          height: 12,
                          color: colors[data.keys.toList().indexOf(entry.key) % colors.length],
                        ),
                        Text(
                          entry.key,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        Text(
                          '${(entry.value * 100).toStringAsFixed(2)}%',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        );
      }

      return charts;
    }
    List<Widget> getText(List<String> idQuestText) {
      final List<Widget> charts = [];


      for (final id in idQuestText) {
        final List<String> data = answerText[id]!;
        charts.add(
          Column(
            children: [
              SizedBox(height: 20.0),
              Text(
                survey.questions[id]!.text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              // Hiển thị danh sách câu hỏi
              Column(
                children: data.map((text) => Text(text)).toList(),
              ),
            ],
          ),
        );
      }

      return charts;
    }



    return Column(
      children: [
        ...getCharts(_idQuest),
        ...getText(_idQuestText),
      ]
    );
  }
}

class PieChartPainter extends CustomPainter {
  final Map<String,double> data;
  final List<Color> colors;

  PieChartPainter(this.data, this.colors);

  @override
  void paint(Canvas canvas, Size size) {
    //final double total = data.reduce((value, element) => value + element);
    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    double startAngle = -math.pi / 2;

      int i = 0;
      data.forEach((key, value) {
        final Paint paint = Paint()
          ..color = colors[i % colors.length]
          ..style = PaintingStyle.fill;
        final sweepAngle = value / 1 * 2 * math.pi;
        //print(value);
        canvas.drawArc(rect, startAngle, sweepAngle, true, paint);
        startAngle += sweepAngle;
        i++;
      });


  }

  @override
  bool shouldRepaint(PieChartPainter oldDelegate) {
    return oldDelegate.data != data || oldDelegate.colors != colors;
  }
}
