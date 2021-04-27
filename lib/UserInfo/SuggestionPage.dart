import 'package:flutter/material.dart';

class SuggesstionWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SuggestionState();
  }
}

class SuggestionState extends State<SuggesstionWidget> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('意见反馈'),
        elevation: 0.5,
      ),
      body: Center(),
    );
  }
}