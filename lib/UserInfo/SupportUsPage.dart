import 'package:flutter/material.dart';
import 'package:flutter_720yun/Common/CommonPage.dart';
import 'package:flutter_720yun/manager/rewarder_sdk.dart';

class SupportUsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SupportUsState();
  }
}

class SupportUsState extends State<SupportUsPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    RewarderManager.loadRewardedVideo();
  }

  @override
  Widget build(BuildContext context) {
    var btnWidth = MediaQuery.of(context).size.width - 30;
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("支持我们"),
        elevation: 0.2,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 15,right: 15,top: 15),
              child: Text("真命天喵是一个免费的宠物领养送养信息平台，广告产生的收益将用来维持平台的运行，您的支持与善举，将会帮助到更多的宠物找到温暖的家！（请看完广告视频，才能获得收益）",
                style: TextStyle(
                    fontSize: FontUtil.fs(FontSize.content),
                    fontWeight: FontWeight.w500,
                    color: ColorsUtil.fromEnmu(ColorEnum.content)
                ),
              ),
            ),
            Expanded(child: Container()),
            ElevatedButton(
                onPressed: (){
                  RewarderManager.showSceneRewardedAd();
                },
                child: Text("支持我们",
                    style: TextStyle(
                        fontSize: FontUtil.fs(FontSize.content),
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                    )
                ),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(ColorsUtil.fromEnmu(ColorEnum.system)),
                  minimumSize: MaterialStateProperty.all(Size(btnWidth, 44)),
              ),
            )
          ],
        ),
      ),
    );
  }
}