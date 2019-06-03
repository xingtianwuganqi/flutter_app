import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_720yun/model/BannerModel.dart';
import 'dart:ui';

final double ScreenW = window.physicalSize.width;

class HomeBanner extends StatefulWidget {
  final List<bannerModel> bannerItems;
//  final OnTapBannerItem onTap;

  HomeBanner(this.bannerItems,{Key key}) //this.onTap,
      :super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _BannerState();
  }
}

class _BannerState extends State<HomeBanner> {
  int virtualIndex = 0;
  int realIndex = 1;
  PageController controller;
  Timer timer;
  var headers = {"Origin": "https://720yun.com","Referer": "https://720yun.com"};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = PageController(initialPage: realIndex);
    timer = Timer.periodic(Duration(seconds: 5), (timer){ // 自动滚动
      controller.animateToPage(realIndex + 1,
          duration: Duration(milliseconds: 300),
          curve: Curves.linear);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: ScreenW * 40 / 75,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          PageView(
            controller: controller,
            onPageChanged: _onPageChanged,
            children: _buildItems(),
          )
        ],
      ),
    );
  }

  List<Widget> _buildItems() {
    List<Widget> items = [];
    if (widget.bannerItems.length > 0) {
      // 头部添加一个尾部Item，模拟循环
      items.add(_buildItem(widget.bannerItems[widget.bannerItems.length - 1]));
      // 正常添加Item
      items.addAll(widget.bannerItems.map((model) => _buildItem(model)).toList(growable: false));
      // 尾部
      items.add(_buildItem(widget.bannerItems[0]));
    }
  }

  Widget _buildItem(bannerModel model) {
    return GestureDetector(
//      onTap: ,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.network(model.thumb,headers: headers,fit: BoxFit.cover,),

        ],
      ),
    );
  }

  _onPageChanged(int index) {
    realIndex = index;
    int count = widget.bannerItems.length;
    if (index == 0) {
      virtualIndex = count - 1;
      controller.jumpToPage(count);
    }else if (index == count + 1){
      virtualIndex = 0;
      controller.jumpToPage(1);
    }else{
      virtualIndex = index - 1;
      setState(() {

      });
    }
  }


}


//typedef void OnTapBannerItem(bannerModel model);