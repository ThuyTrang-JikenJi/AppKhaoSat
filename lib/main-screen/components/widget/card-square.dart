import 'package:appkhaosat/main-screen/SurveyPage.dart';
import 'package:appkhaosat/main-screen/constants/theme.dart';
import 'package:appkhaosat/main-screen/detail-surveys.dart';
import 'package:appkhaosat/main-screen/model/survey.dart';
import 'package:flutter/material.dart';

class CardSquare extends StatelessWidget {
  CardSquare(
      {this.title = "Placeholder Title",
        this.cta = "",
        this.img = "https://via.placeholder.com/200",
        required this.menuScreenContext,
        required this.survey,
        required this.surveyKeys,
        required this.isDetailSurveyPage,
      });

  final String cta;
  final String img;
  final BuildContext menuScreenContext;
  final String title;
  final Survey survey;
  final String? surveyKeys;
  final bool isDetailSurveyPage;

  static void defaultFunc(BuildContext context,Survey survey,String? surveyKeys, bool isDetailSurvey) {
    if(isDetailSurvey) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>
            DetailSurveyPage(survey: survey, surveyKeys: surveyKeys)),
      );
    }else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>
            SurveyPage(survey: survey, surveyKeys: surveyKeys)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 250,
        width: null,
        child: Card(
              elevation: 3,
              shadowColor: NowUIColors.muted.withOpacity(0.22),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4.0))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                      flex: 1,
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(4.0),
                                  topRight: Radius.circular(4.0)),
                              image: DecorationImage(
                                image: NetworkImage(img),
                                fit: BoxFit.cover,
                              )
                          ))
                  ),
                  Flexible(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(title,
                                style: TextStyle(
                                    color: NowUIColors.text, fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                            ),

                         GestureDetector(
                              onTap: (){
                                defaultFunc(menuScreenContext,survey,surveyKeys,isDetailSurveyPage);
                              },
                              child:  Text(cta,
                                  style: TextStyle(
                                      color: NowUIColors.primary,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600))
                          ),


                          ],
                        ),
                      ))
                ],
              )),
        );
  }
}
