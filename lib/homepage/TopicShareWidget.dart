import 'package:flutter/material.dart';
import 'package:flutter_720yun/Common/CommonPage.dart';

class TopicShareWidget extends StatelessWidget {
  List<TopicShareModel> items = [
    TopicShareModel(title: "生成海报",img: "icon_share_hb"),
    TopicShareModel(title: "分享链接",img: "icon_share_share"),
    TopicShareModel(title: "复制链接",img: "icon_share_url"),
  ];
  ValueChanged clickCallBack;
  TopicShareWidget(this.clickCallBack);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      color: Colors.white,
      width: double.infinity,
      height: 200,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 130,
            color: ColorsUtil.fromEnmu(ColorEnum.defIcon),
            child: GridView.builder(
                physics: new NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.7
                ),itemCount:items.length,
                itemBuilder: (context,index){
                  var item = items[index];
                  return GestureDetector(
                    child: shareItemWidget(item),
                    onTap: () {
                      clickCallBack(index);
                    },
                  );
                }),
          ),
          Container(
            height: 70,
            alignment: Alignment.topCenter,
            child: TextButton(
              child: Text(
                "取消",style: TextStyle(color: ColorsUtil.fromEnmu(ColorEnum.content),
                  fontSize: FontUtil.fs(FontSize.content),fontWeight: FontWeight.bold),
              ),onPressed: (){
                clickCallBack(-1);
              },
            ),
          )
        ],
      ),
    );
  }

  Widget shareItemWidget(TopicShareModel model) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 10,bottom: 10),
            decoration: new BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                border: Border.all(
                    width: 1,
                    color: ColorsUtil.fromEnmu(ColorEnum.tableBack)
                ),
              color: Colors.white,
              ),
            child: Image.asset('assets/icons/${model.img}.png',width: 70,height: 70),
          ),
          Text(model.title,style: TextStyle(color: ColorsUtil.fromEnmu(ColorEnum.content),fontSize: FontUtil.fs(FontSize.desc)),)
        ],
      ),
    );
  }
}

class TopicShareModel {
  final title;
  final img;
  TopicShareModel({
    this.title,
    this.img
  });
}