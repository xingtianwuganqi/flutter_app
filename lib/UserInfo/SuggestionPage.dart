import 'package:flutter/material.dart';
import 'package:flutter_720yun/Common/CommonPage.dart';

class SuggesstionWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SuggestionState();
  }
}

class SuggestionState extends State<SuggesstionWidget> {

  FocusNode _sugFocus = FocusNode();
  TextEditingController _sugController = new TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('意见反馈'),
        elevation: 0.5,
      ),
      body: GestureDetector(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Container(
                child: Text('请输入您的建议',style: TextStyle(color: ColorsUtil.fromEnmu(ColorEnum.content)),),
              ),

              Container(
                  constraints: BoxConstraints(maxHeight: 56, minHeight: 56),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: Color(0xFFE8E8E8),
                              width: 1,
                          ),
                      ),
                  ),
                child: TextField(

                  focusNode: _sugFocus,
                  controller: _sugController,
                  keyboardType: TextInputType.emailAddress,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "您的意见对我们非常重要",
                    hintStyle: TextStyle(color: ColorsUtil.fromEnmu(ColorEnum.defIcon)),

                  ),
                ),
              )
            ],
          ),
        ),
        onTap: (){
          _sugFocus.unfocus();
        },
      )
    );
  }
}