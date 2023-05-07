import 'package:appkhaosat/main-screen/SurveyPage.dart';
import 'package:appkhaosat/main-screen/components/widget/card-horizontal.dart';
import 'package:appkhaosat/main-screen/components/widget/card-small.dart';
import 'package:appkhaosat/main-screen/components/widget/card-square.dart';
import 'package:appkhaosat/main-screen/components/widget/table_cell.dart';
import 'package:appkhaosat/main-screen/constants/theme.dart';
import 'package:appkhaosat/main-screen/model/survey.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'components/navigation_drawer.dart';

class Detail extends StatefulWidget {
  const Detail(
      {final Key? key,
      required this.menuScreenContext,
      required this.onScreenHideButtonPressed,
      required this.hideStatus})
      : super(key: key);
  final BuildContext menuScreenContext;
  final VoidCallback onScreenHideButtonPressed;
  final bool hideStatus;

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  late List<Survey> _surveys = [];
  late List<String?> _surveyKeys = [];
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();

  List<Survey> filteredSurveys = [];

  @override
  void initState() {
    super.initState();
    DatabaseReference surveysRef =
        FirebaseDatabase.instance.ref().child('surveys');
    surveysRef.onChildAdded.listen((event) {
      DataSnapshot snapshot = event.snapshot;
      Survey survey = Survey.fromSnapshot(snapshot);

      setState(() {
        _surveys.add(survey);
        _surveyKeys.add(snapshot.key);
      });
    });
    filteredSurveys = _surveys;
  }

  PreferredSizeWidget? _buildAppBar(BuildContext context) {
    return AppBar(
      title: isSearching ? _buildSearchBar() : Text("Home"),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Color.fromARGB(255, 88, 169, 212),
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            setState(() {
              isSearching = !isSearching;
              searchController.clear();
            });
          },
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: searchController,
      decoration: InputDecoration(
        hintText: "Tìm kiếm",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      onChanged: (value) {
        setState(() {
          filteredSurveys = _surveys
              .where((survey) =>
                  survey.title.toLowerCase().contains(value.toLowerCase()))
              .toList();
        });
      },
    );
  }

  Widget _buildCard(Survey survey, String? surveyKeys) {
    if (survey.title.length <= 45) {
      return CardHorizontal(
        cta: "Thực hiện khảo sát",
        title: survey.title,
        img: survey.urlImage,
        menuScreenContext: widget.menuScreenContext,
        survey: survey,
        surveyKeys: surveyKeys,
        isDetailSurveyPage: false,
      );
    } else {
      return CardSquare(
        cta: "Thực hiện khảo sát",
        title: survey.title,
        img: survey.urlImage,
        menuScreenContext: widget.menuScreenContext,
        survey: survey,
        surveyKeys: surveyKeys,
        isDetailSurveyPage: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: _buildAppBar(context),
        body: SingleChildScrollView(
          child: Column(
            children: List.generate(
              isSearching ? filteredSurveys.length : _surveys.length,
              (index) {
                Survey survey =
                    isSearching ? filteredSurveys[index] : _surveys[index];
                String? surveyKey =
                    _surveyKeys.isNotEmpty ? _surveyKeys[index] : null;
                return _buildCard(survey, surveyKey);
              },
            ),
          ),
        ),
      );
}
