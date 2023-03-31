
import 'package:flutter/material.dart';
import 'package:flutter_720yun/Common/CommonPage.dart';

class FindPetDetailPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return FindPetDetailState();
  }
}

class FindPetDetailState extends State<FindPetDetailPage> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("找宠小助手"),
        elevation: 0.2,
      ),
      body: CustomScrollView(
        slivers: [
          findPetHeader(),

        ],
      ),
    );
  }


  // MARK: 头部视图
  Widget findPetHeader() {
    var header = Container(
      color: ColorsUtil.hexColor(0xF0EBDA),
      padding: EdgeInsets.only(left: 15,right: 15),
      child: Row(
        children: [
          GestureDetector(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image.asset('assets/icons/icon_cat_header.png',width: 50,height: 50,),
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context){
                // return NewUserInfoPage(pageType: MyPageType.otherPage,userId: data.userInfo.id);
              }));
            },
          ),
          Expanded(child:  
            Container(
              margin: EdgeInsets.only(top: 15,left: 15,right: 15,bottom: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                color: ColorsUtil.hexColor(0xCBCFB5),
              ),
              child: Container(
                child: Padding(padding: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
                  child: Text('没有找到想要的宠物？\n可以提交相关信息给小助手\n有合适的宠物后会通知您~',
                    style: TextStyle(fontSize: FontUtil.fs(FontSize.content),
                        color: ColorsUtil.fromEnmu(ColorEnum.content),height: 1.3),
                  ),
                ),
              ),
            )
          )
        ],
      ),
    );

    return SliverToBoxAdapter(
      child: header,
    );
  }

  // 宠物类型
  Widget petTypeWidget() {
    var petType = Container(
      color: ColorsUtil.hexColor(0xF0EBDA),
      height: 50,
      child: Row(
        children: [
          Text('种类',),
          // IconButton(onPressed: onPressed, icon: icon)
        ],
      ),
    );

    return SliverToBoxAdapter(
      child: petType,
    );
  }
}