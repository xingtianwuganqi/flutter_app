import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
const MAX_COUNT = 0x7fffffff;
var headers = {"Origin": "https://720yun.com","Referer": "https://720yun.com"};

///
/// Item的点击事件
///
typedef void OnBannerItemClick(int position, BannerItem entity);

///
/// 自定义ViewPager的每个页面显示
///
typedef Widget CustomBuild(int position, BannerItem entity);


class BannerWidget extends StatefulWidget {

  final double height;
  final List<BannerItem> datas;
  int duration;
  double pointRadius;
  bool isHorizontal;

  OnBannerItemClick bannerPress;
  CustomBuild build;

  BannerWidget(
    this.height,
    this.datas,
  { Key key,
    this.duration = 5000,
    this.pointRadius = 3.0,
    this.isHorizontal = true,
    OnBannerItemClick this.bannerPress,
    CustomBuild this.build
  }) : super(key:key);


  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return BannerState();
  }
}

class BannerState extends State<BannerWidget> {

  Timer timer;
  int selectorIndex = 0;
  PageController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = PageController();
    double current = widget.datas.length > 0 ? (MAX_COUNT / 2) -((MAX_COUNT / 2) % widget.datas.length) : 0.0;
    _initPageAutoScroll();
  }

  @override
  void didUpdateWidget(BannerWidget oldWidget){
    super.didUpdateWidget(oldWidget);
    start();
  }

  _initPageAutoScroll() {
    start();
  }

  
  start() {
    stop();
    timer = Timer.periodic(Duration(milliseconds: widget.duration), (timer){
      if(widget.datas.length > 0 && controller != null && controller.page != null) {
        controller.animateToPage(controller.page.toInt() + 1,
            duration: Duration(milliseconds: 300), curve: Curves.linear);
      }
    });
  }

  stop() {
    timer?.cancel();
    timer = null;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    stop();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: widget.height,
      color: Colors.black12,
      child: Stack(
        children: <Widget>[
          getViewPage()
        ],
      ),
    );
  }

  Widget getViewPage() {
    return PageView.builder(
      itemCount: widget.datas.length > 0 ? MAX_COUNT : 0,
        controller: controller,
        onPageChanged: onPageChanged,
        itemBuilder: (context , index){
          return InkWell(
            onTap: () {
              if (widget.bannerPress != null){
                widget.bannerPress(selectorIndex,widget.datas[selectorIndex]);
              }
            },
            child: widget.build == null
            ? Image.network(widget.datas[index % widget.datas.length].itemImagePath,headers: headers,)
//          ? CachedNetworkImage(imageUrl:widget.datas[index % widget.datas.length].itemImagePath ,httpHeaders: headers,)
                : widget.build(index,widget.datas[index % widget.datas.length])
          );
        });
  }


  onPageChanged(index) {
    selectorIndex = index % widget.datas.length;
    setState(() {

    });
  }

}

class BannerItem {
  String itemImagePath;

  static BannerItem defaultBannerItem(String image) {
    BannerItem item = BannerItem();
    item.itemImagePath = image;
    return item;
  }
}