import 'package:flutter/material.dart';
import '../NetWorking/NetWorking.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter_720yun/model/ChannelModel.dart';
import 'package:transparent_image/transparent_image.dart';
import 'Banner.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:ui';
import 'home_banner.dart';
import 'package:flutter_720yun/model/BannerModel.dart';
import 'ChannelDatailPage.dart';
import 'WorthAttentionPage.dart';

final double ScreenW = window.physicalSize.width;

class findpage extends StatefulWidget {
  @override
  _findpageState createState() {
    // TODO: implement createState
    return new _findpageState();
  }
}

class _findpageState extends State<findpage> {

  // banner
  List<bannerModel> banners = <bannerModel>[];
  List<BannerItem> bannerItems = <BannerItem>[];
  // 数据源
  List<channel> datas = <channel>[];
  // 专题数据
  List<special> specialData = <special>[];
  // 热门教程
  List<special> hotData = <special>[];
  // 访谈数据
  List<special> authorData = <special>[];
  // 值得关注
  List<followed> followData = <followed>[];

  List<Widget> followWidgets = <Widget>[];

  var headers = {"Origin": "https://720yun.com","Referer": "https://720yun.com"};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (banners.length == 0) {
      network();
    }
    print(window.devicePixelRatio);// 设备像素比
    print(window.physicalSize);// 获取屏幕尺寸
  }

  /*

  ListView.builder(
                  itemCount: datas.length,
                    itemBuilder: (context ,index){
                      return ListTile(title: Text("$index"),);
                    }),
   */

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('发现'),
      ),
      body: new Scrollbar(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
//              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                BannerWidget(
                    (ScreenW - 64) / 2 * 40 / 75,
                    bannerItems
                ),
//                HomeBanner(banners),
                _buildHor(),
                specialContrainer(),
                courseWidget(),
                authorWidget(),
                followWidget(),
              ],
            ),
          )
      )
    );
  }

  // channel
  Widget _buildHor() {
    return SizedBox(
      height: 100,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: datas.length,
          itemBuilder: (context,index){
            return _getContainer(datas[index]);
          },
          ),
    );
  }

  Widget _getContainer(channel data) {
    return new Container(
      padding: EdgeInsets.all(5),
      width: 100.0,
      height: 100.0,
      child: _channelBtn(data),
    );
  }

  Widget _channelBtn (channel data) {
    return GestureDetector(
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
//          Image.network(data.channelThumb,headers: headers,),
          CachedNetworkImage(imageUrl: data.channelThumb,httpHeaders: headers,),
          Text(data.channelName,style: TextStyle(fontSize: 12,color: Colors.white),)
        ],
      ),
      onTap: () => channelTap(data),
    );
  }
  
  channelTap(channel data) {
//    print(data.channelId);
    Navigator.push(context,
      new MaterialPageRoute(builder: (ctx){
        return new ChannelDetail(data.channelId, data.channelName);
      }),
    );
  }


  Widget specialContrainer() {
    return new Column(
      children: <Widget>[
        Padding(padding: EdgeInsets.only(top: 30),),
//        Padding(padding: EdgeInsets.all(10),
//          child: Text("全景专题",textAlign: TextAlign.left,style: TextStyle(fontSize: 18,color: Colors.black),),
//        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          textDirection: TextDirection.ltr,
          children: <Widget>[
//            Text("全景专题",textAlign: TextAlign.left,style: TextStyle(fontSize: 18,color: Colors.black),),
//            FlatButton(child: Text("更多",style: TextStyle(fontSize: 10,color: Colors.black),),)
            Expanded(
              flex: 2,
                child: Text("全景专题",textAlign: TextAlign.left,style: TextStyle(fontSize: 18,color: Colors.black),),
            ),
            Spacer(
              flex: 1,
            ),
            Expanded(
              flex: 1,
                child: FlatButton(child: Text("更多", textAlign: TextAlign.right,style: TextStyle(fontSize: 10,color: Colors.black),),))
          ],
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: specialData.length,
              itemBuilder: (context,index){
                return Padding(padding: EdgeInsets.only(left: 5,right: 5),
                  child:
//                  Image.network(specialData[index].thumb,headers: headers,height: 200,width: 200 * 75 / 40),
                    CachedNetworkImage(imageUrl: specialData[index].thumb,httpHeaders: headers,width: 200 * 75 / 40,height: 200,),
                );
              })
        )
      ],
    );
  }

  Widget courseWidget() {
    return Column(
      children: <Widget>[
        Padding(padding: EdgeInsets.only(top: 30),),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Text("热门教程",textAlign: TextAlign.left,style: TextStyle(fontSize: 18,color: Colors.black),),
            ),
            Spacer(
              flex: 2,
            ),
            Expanded(
                flex: 1,
                child: FlatButton(child: Text("更多", textAlign: TextAlign.right,style: TextStyle(fontSize: 10,color: Colors.black),),))
          ],
        ),
        Container(
          height: hotData.length.toDouble() * 110,
          child: ListView.builder(
              physics: new NeverScrollableScrollPhysics(),
            itemCount: hotData.length,
              itemExtent: 100,
              itemBuilder: (context ,index){
                return courseItemWidget(index);
              }),
        ),
      ],
    );
  }

  Widget courseItemWidget(index) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(padding: EdgeInsets.only(top: 10),),
              Expanded(
                flex: 2,
                child: Container(
                  child: Text(hotData[index].title,textAlign: TextAlign.left,style: TextStyle(fontSize: 16,color: Colors.black),),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                    child:Row(
                      children: <Widget>[
                        Expanded(
                            flex: 1,
                            child: Text(hotData[index].nickname,
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 12,
                                  color: Colors.black),
                            )
                        ),
                        Expanded(
                          flex: 1,
                          child: Text("${hotData[index].viewCount.toString()}阅读",
                            textAlign: TextAlign.right,
                            style: TextStyle(fontSize: 12,
                                color: Colors.black),
                          ),
                        )
                      ],
                    )
                ),
              ),
            ],
          )
        ),
        Expanded(
          flex: 1,
          child:
//          Image.network(hotData[index].thumb,headers: headers,height: 80,width: 80 * 75 / 40,),
            CachedNetworkImage(imageUrl: hotData[index].thumb,httpHeaders: headers,height: 80,width: 80 * 75 / 40,),
        ),
      ],
    );
  }

  Widget authorWidget() {
    return Column(
      children: <Widget>[
        Padding(padding: EdgeInsets.only(top: 30),),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Text("热门教程",textAlign: TextAlign.left,style: TextStyle(fontSize: 18,color: Colors.black),),
            ),
            Spacer(
              flex: 2,
            ),
            Expanded(
                flex: 1,
                child: FlatButton(child: Text("更多", textAlign: TextAlign.right,style: TextStyle(fontSize: 10,color: Colors.black),),))
          ],
        ),
        SizedBox(
          height: 260,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount:authorData.length ,
              itemExtent:200 * 75 / 40 ,
              itemBuilder: (context,index){
                return authorItem(index);
              }
              ),
        )
      ],
    );
  }
  Widget authorItem(index) {
    return Padding(
      padding: EdgeInsets.only(right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
//          Image.network(authorData[index].thumb,headers: headers,height: 200,width: 200 * 75 / 40),
          CachedNetworkImage(imageUrl: authorData[index].thumb,httpHeaders: headers,height: 200,width: 200 * 75 / 40,),
          Padding(padding: EdgeInsets.only(top: 10),
            child: Text(authorData[index].title,
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 16,color: Colors.black,),
                overflow: TextOverflow.ellipsis),
          ),
          Padding(padding: EdgeInsets.only(top: 10),
            child: Text(authorData[index].nickname,
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 12,color: Colors.black),
                overflow: TextOverflow.ellipsis),
          ),

        ],
      ),
    );
  }

  Widget followWidget() {
    return Column(
      children: <Widget>[
        Padding(padding: EdgeInsets.only(top: 30),),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Text("值得关注",textAlign: TextAlign.left,style: TextStyle(fontSize: 18,color: Colors.black),),
            ),
            Spacer(
              flex: 2,
            ),
            Expanded(
                flex: 1,
                child: FlatButton(child: Text("更多", textAlign: TextAlign.right,style: TextStyle(fontSize: 10,color: Colors.black),),))
          ],
        ),
        SizedBox(
          height: 260,
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: followWidgets,
          )
        )
      ],
    );
  }

  Widget followItem(index) {
    return GestureDetector(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
//            Image.network(followData[index].thumb,headers: headers,width: (window.physicalSize.width - 110)/6 ,height: (window.physicalSize.width - 110)/6,fit: BoxFit.cover,),
            CachedNetworkImage(imageUrl: followData[index].thumb,httpHeaders: headers,width: (window.physicalSize.width - 110)/6,height: (window.physicalSize.width - 110)/6,fit:  BoxFit.cover,),
            Text("${followData[index].title}",style: TextStyle(fontSize: 12,color: Colors.white),)
          ],
        ),
      onTap: () => worthAttention(followData[index]),
    );
  }

  void worthAttention(followed data) {
    Navigator.push(context,
      new MaterialPageRoute(builder: (context){
        return WorthAttentionPage(data);
      })
    );
  }


  void network() async{
    final url = "https://api-app.720yun.com/foundPage/recommend";
    var data = await NetWorking.get(url);
//    print(data);
//    print(data['data']['category']);

    var banner = data["data"]["findBanner"];
    var channels = data['data']['category'];
    var specials = data["data"]["special"];
    var courses = data['data']['course'];
    var authors = data['data']['author'];
    var follows = data['data']['followed'];

    for (int i = 0;i < channels.length; i ++) {
      datas.add(new channel.fromJson(channels[i]));
    }

    for (int i = 0;i < banner.length; i++ ){
      banners.add(new bannerModel.fromJson(banner[i]));
    }

    for (int i = 0; i < specials.length; i ++){
      specialData.add(new special.fromJson(specials[i]));
    }

    for (int i = 0; i < courses.length; i ++ ){
      hotData.add(new special.fromJson(courses[i]));
    }

    for (int i = 0; i< authors.length; i++){
      authorData.add(new special.fromJson(authors[i]));
    }
    
    for (int i = 0; i < follows.length; i ++) {
      followData.add(new followed.fromJson(follows[i]));
    }

    for (int i = 0; i< followData.length; i++) {
      followWidgets.add(followItem(i));
    }

    for (int i = 0;i < banners.length;i++){
      bannerItems.add(BannerItem.defaultBannerItem(banners[i].thumb));
    }


//
//    print(hotData);
//    print(bannerItems);
    print(followWidgets);
    setState(() {

    });
  }

}