
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
          petTypeWidget(),
          descWidget()
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
      padding: EdgeInsets.only(left: 15,right: 15),
      color: Colors.white,
      height: 50,
      child: Column(
        children: [
          Row(
            children: [
              Text('种类：',),
              Expanded(
                  child: TextButton.icon(
                    icon: Icon(Icons.access_alarm_outlined,size: 20,),
                    label: Text('猫咪'),
                  )
              ),
              Expanded(
                  child: TextButton.icon(
                    icon: Icon(Icons.access_alarm_outlined,size: 20,),
                    label: Text('狗狗'),
                  )
              )
            ],
          ),
          Container(
            padding: EdgeInsets.only(left: 15,right: 15),
            height: 0.5,
            color: ColorsUtil.fromEnmu(ColorEnum.tableBack),
          )
        ],
      ),
    );

    return SliverToBoxAdapter(
      child: petType,
    );
  }

  // 宠物类型
  Widget descWidget() {
    var descType = Container(
      // alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: 15,right: 15),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('描述'),
          Container(

            height: 200,
            child: TextField(
              decoration: InputDecoration(
                hintText: '请输入简短的描述',
                hintStyle: ,
                border: InputBorder.none,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 15,right: 15),
            height: 0.5,
            color: ColorsUtil.fromEnmu(ColorEnum.tableBack),
          )
        ],
      ),
    );

    return SliverToBoxAdapter(
      child: descType,
    );
  }
}