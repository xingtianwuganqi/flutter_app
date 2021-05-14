import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_720yun/Common/CommonPage.dart';

class ViolationsListWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ViolationListState();
  }
}

class ViolationListState extends State<ViolationsListWidget> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget violationCell() {
    return Container(
      alignment: Alignment.center,
      child: Row(
        children: [
          Icon(Icons.panorama_fish_eye,size: 20,color: ColorsUtil.fromEnmu(ColorEnum.system),),
          Padding(padding: EdgeInsets.only(left: 10)),
          Text('违规违法',style: TextStyle(fontSize: FontUtil.fs(FontSize.content),color: ColorsUtil.fromEnmu(ColorEnum.content)),),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('投诉举报'),
        elevation: 0.5,
      ),
      body: Container(
        padding: EdgeInsets.only(left: 15,right: 15),
        child: CustomScrollView(

          slivers: [
            // 如果不是Sliver家族的Widget，需要使用SliverToBoxAdapter做层包裹
            SliverToBoxAdapter(
              child: Container(
                alignment: Alignment.centerLeft,
                height: 30,
                child: Text('请选择对应理由，理由与内容不符，会延迟处理',style: TextStyle(fontSize: FontUtil.fs(FontSize.desc),color: ColorsUtil.fromEnmu(ColorEnum.mark)),),
              ),
            ),
            SliverGrid(
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    return violationCell();
                  },
                  childCount: 10,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
                  childAspectRatio: 3,
                )
            ),
            SliverToBoxAdapter(
              child: Container(
                alignment: Alignment.centerLeft,
                height: 70,
                child: Column(
                  children: [
                    TextButton(onPressed: (){

                    },
                        child: Text('提交'),
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "了解",
                            style: TextStyle(fontSize: FontUtil.fs(FontSize.desc), color: ColorsUtil.fromEnmu(ColorEnum.mark)),
                          ),
                          TextSpan(
                            text: "用户协议",
                            style: TextStyle(fontSize: FontUtil.fs(FontSize.desc), color: ColorsUtil.fromEnmu(ColorEnum.system)),
                            // 设置点击事件
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {

                              },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}