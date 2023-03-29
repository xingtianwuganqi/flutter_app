import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_720yun/Common/CommonPage.dart';
import 'package:flutter_720yun/NetWorking/NetWorking.dart';
import 'package:flutter_720yun/homepage/FindPetDetailPage.dart';
import 'package:flutter_720yun/model/FindPetListModel.dart';
import 'package:flutter_720yun/routers/router_reward.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../UserInfo/NewUserInfoPage.dart';
import '../routers/router_banner.dart';
import '../routers/router_home.dart';
import '../routers/router_interstitial.dart';
import '../routers/router_native.dart';

class FindPetPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return FindPetState();
  }
}

class FindPetState extends State<FindPetPage> {
  List<FindPetListModel> _findList = [];
  int _page = 1;
  bool isFirstLoad = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findPetListNetworking(1);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        EasyRefresh(
        header: MaterialHeader(),
        footer: MaterialFooter(
          enableInfiniteLoad: false
        ),
        child: ListView.builder(
          itemCount: _findList.length,
          itemBuilder: (context,index){
          var data = _findList[index];
          if (data.findId == -1) {
            return findHeaderWidget();
          }else{
            return findPetItem(data);
          }
          }),
        firstRefresh: isFirstLoad,
        firstRefreshWidget: SpinKitRing(color: ColorsUtil.fromEnmu(ColorEnum.system),size: 30,lineWidth: 3,),
        emptyWidget:
        _findList.length > 0 ? null : EmptyPage(() async {
        await findPetListNetworking(1);
        }),
        // null,
        onRefresh:() async {
        await findPetListNetworking(1);
        },
        onLoad: () async{
        await findPetListNetworking(_page);
        },
        )
      ],
    );
    // TODO: implement build
  }

  Widget findHeaderWidget() {
    return Container(
      margin: EdgeInsets.only(left: 15,top: 10,right: 15, bottom: 10),
      height: 60,
        decoration: BoxDecoration(
          color: ColorsUtil.fromEnmu(ColorEnum.system),
          borderRadius: BorderRadius.all(Radius.circular(8))
        ),
      child: Row(
        children: [
          Padding(padding: EdgeInsets.only(left: 15)),
          Text("找宠小助手",style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.w700),),
          Expanded(child: Container()),
          Stack(
            children: [
              Image.asset('assets/icons/icon_find_line.png',width: 200,height: 70,fit: BoxFit.fitWidth,),
              Positioned(
                height: 60,
                width: 110,
                right: 15,
                  child:
                Container(
                  alignment: Alignment.center,
                  child:Directionality(
                    textDirection: TextDirection.rtl,
                    child: ElevatedButton.icon(
                        style: ButtonStyle(textStyle: MaterialStateProperty.all(
                          TextStyle(color: ColorsUtil.hexColor(0x683A3B),fontWeight: FontWeight.w700,fontSize: 14)),
                          backgroundColor: MaterialStateProperty.all(ColorsUtil.hexColor(0xFFF0D6))
                          ),
                          icon: Icon(Icons.arrow_circle_right_sharp,color: ColorsUtil.hexColor(0x6D4241),size: 20,),
                          label: Text("去找宠"),
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return AdTestPage();
                          }));
                        },
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget findPetItem(FindPetListModel data) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.only(left: 15,top: 10,bottom: 10),
        child: Column(
          children: [
            userInfoWidget(data),
            petTypeWdiget(data),
          ],
        ),
      ),
    );
  }
  
  Widget userInfoWidget(FindPetListModel data) {
    var width = MediaQuery.of(context).size.width - 112;
    return Container(
      child: Row(
        children: [
          GestureDetector(
            child: CircleAvatar(
              radius: 18,
              backgroundImage:
              ((data.userInfo.avator != null && data.userInfo.avator.length > 0) ?
              CachedNetworkImageProvider(ToolConfig.loadImgUrl(data.userInfo.avator,bType: ThumbType.thumbNail)) :
              AssetImage('assets/icons/icon_plh.png')),
              //   :
              // AssetImage('assets/icons/icon_plh.png'),
              child: Container(
                alignment: Alignment(0, 0),
                width: 36,
                height: 36,
              ),
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return NewUserInfoPage(pageType: MyPageType.otherPage,userId: data.userInfo.id);
              }));
            },
          ),
          Container(
            width: width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(padding: EdgeInsets.only(left: 10,bottom: 2),child:  Text(data.userInfo.username ?? "",style:
                TextStyle(fontSize: FontUtil.fs(FontSize.title),fontWeight: FontWeight.w600,color: ColorsUtil.fromEnmu(ColorEnum.title)),),),
                Padding(padding: EdgeInsets.only(left: 10,top: 2),child:  Text(ToolConfig.timeT(data.update_time) ?? "",style:
    TextStyle(fontSize: FontUtil.fs(FontSize.time),color: ColorsUtil.fromEnmu(ColorEnum.content)),)),
              ],
            ),
          ),
          IconButton(icon: Icon(Icons.more_horiz_rounded),)
        ],
      ),
    );
  }

  Widget petTypeWdiget(FindPetListModel model) {
    return Container(
      padding: EdgeInsets.only(top: 2,bottom: 2),
      child: Row(
        children: [
          Padding(padding: EdgeInsets.only(right: 5),
            child: Text("想领养",style:
            TextStyle(fontSize: FontUtil.fs(FontSize.content),
                color: ColorsUtil.fromEnmu(ColorEnum.content)),
            ),
          ),
          Wrap(
            spacing: 10,
            children:
              [Container(
                decoration: BoxDecoration(
                    color: ColorsUtil.fromEnmu(ColorEnum.system),
                    borderRadius: BorderRadius.all(Radius.circular(3.0))
                ),
                padding: EdgeInsets.only(left: 5,right: 5,top: 2,bottom: 2),
                child: Text(model.pet_type == 1 ? "猫咪" : "狗狗",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              )]
            ),
        ],
      ),
    );
  }

  Widget textDescWidget() {
    return Container(

    );
  }

  Future<void> findPetListNetworking(int page) async {
    _page = page;
    final url = NetWorkingConfig.path(NetPath.findPetList);
    var dic = new Map<String, dynamic>.from(paramDic);
    dic["page"] = page;
    dic["size"] = 10;
    await NetWorking.formDataPost(url, dic, (data) {
      if (data['code'] == 200) {
        var models = data['data'];
        var dataSourses = (models as List).map((e) => FindPetListModel.fromJson(e)).toList();
        if (_page == 1) {
          var findHeader = FindPetListModel(findId: -1);
          _findList = [findHeader] + dataSourses;
        }else{
          _findList = _findList + dataSourses;
        }
        if (dataSourses.length > 0) {
          _page += 1;
        }

      }
      isFirstLoad = false;
      setState(() {

      });
    }, (error) {
      setState(() {

      });
    });
  }
}