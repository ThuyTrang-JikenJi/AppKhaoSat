import 'package:appkhaosat/main-screen/components/widget/card-horizontal.dart';
import 'package:appkhaosat/main-screen/components/widget/card-small.dart';
import 'package:appkhaosat/main-screen/components/widget/card-square.dart';
import 'package:appkhaosat/main-screen/components/widget/table_cell.dart';
import 'package:appkhaosat/main-screen/constants/theme.dart';
import 'package:appkhaosat/main-screen/model/survey.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'components/navigation_drawer.dart';

class Search_Screen extends StatefulWidget {
  const Search_Screen(
      {final Key? key,
      required this.menuScreenContext,
      required this.onScreenHideButtonPressed,
      this.hideStatus = false})
      : super(key: key);
  final BuildContext menuScreenContext;
  final VoidCallback onScreenHideButtonPressed;
  final bool hideStatus;

  @override
  _Search_ScreenState createState() => _Search_ScreenState();
}

class _Search_ScreenState extends State<Search_Screen> {
  late List<Survey> _surveys = [];
  late List<String?> _surveyKeys = [];
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();

  List<Survey> filteredSurveys = [];

  @override
  void initState() {
    super.initState();
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DatabaseReference surveysRef =
          FirebaseDatabase.instance.ref().child('surveys');
      surveysRef
          .orderByChild('idUser')
          .equalTo(user.uid)
          .onChildAdded
          .listen((event) {
        DataSnapshot snapshot = event.snapshot;
        Survey survey = Survey.fromSnapshot(snapshot);

        setState(() {
          _surveys.add(survey);
          _surveyKeys.add(snapshot.key);
        });
      });
    }
    filteredSurveys = _surveys;
  }

  PreferredSizeWidget? _buildAppBar(BuildContext context) {
    return AppBar(
      title: isSearching ? _buildSearchBar() : Text("Khảo sát của tôi"),
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
        cta: "Xem thông tin khảo sát",
        title: survey.title,
        img: survey.urlImage,
        menuScreenContext: widget.menuScreenContext,
        survey: survey,
        surveyKeys: surveyKeys,
        isDetailSurveyPage: true,
      );
    } else {
      return CardSquare(
        cta: "Xem thông tin khảo sát",
        title: survey.title,
        img: survey.urlImage,
        menuScreenContext: widget.menuScreenContext,
        survey: survey,
        surveyKeys: surveyKeys,
        isDetailSurveyPage: true,
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
