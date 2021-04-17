import 'package:flutter/material.dart';

class SearchPageWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SearchPageState();
  }
}

class SearchPageState extends State<SearchPageWidget> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          padding: EdgeInsets.only(left: 20,right: 20),
          width: double.infinity,
          height: 40,
          child:TextField(

          ),
        ),
      ),
      body: Center(
        child: Text('搜索'),
      )
      ,
    );
  }
}