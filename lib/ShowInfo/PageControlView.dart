import 'package:flutter/material.dart';

class DWPageView extends StatefulWidget {
  DWPageView({
    // 宽度 必传
    required this.width,
    // 高度 必传
    required this.height,
    // 总页数 必传
    required this.numberOfPages,
    // 当前页数
    this.currentPage = 0,
    // 未选颜色 默认灰色
    this.pageColor = Colors.grey,
    // 选中颜色 默认白色
    this.tintColor = Colors.white,
    // 间隔 默认5
    this.space = 5,
    // 指示器宽度 默认5
    this.pageWidth = 5,
    // 指示器高度 默认5
    this.pageHeight = 5,
    // 选中指示器宽度 默认5
    this.currentPageWidth = 5,
    // 选中指示器高度 默认5
    this.currentPageHeight = 5,
    // 指示器圆角度 默认2
    this.radius = 2,
    // 排序的方向 默认横着排序
    this.scrollDirection = Axis.horizontal,

    required Key key,
  }) : super( key: key);

  final int numberOfPages;
  final int currentPage;
  final Color pageColor;
  final Color tintColor;
  final double space;
  final double width;
  final double height;
  final double pageWidth;
  final double pageHeight;
  final double currentPageWidth;
  final double currentPageHeight;
  final double radius;
  final Axis scrollDirection;

  @override
  DWPageViewState createState() {
    return DWPageViewState();
  }
}

class DWPageViewState extends State<DWPageView> {
  ScrollController _scrollController = new ScrollController();
  late int _currentPage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _currentPage = widget.currentPage;
    });
  }

  void selectedIndex(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: widget.width,
      height: widget.height,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: widget.scrollDirection,
        itemCount: widget.numberOfPages,
        itemBuilder: ((context, index) {
          if (index == _currentPage) {
            return Center(
              child: Container(
                margin: new EdgeInsets.fromLTRB(0, 0, widget.scrollDirection == Axis.horizontal ? widget.space : 0, widget.scrollDirection != Axis.horizontal ? widget.space : 0),
                width: widget.currentPageWidth,
                height: widget.currentPageHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(widget.radius)),
                  color: widget.tintColor,
                ),
              ),
            );
          }
          return Center(
            child: Container(
              margin: new EdgeInsets.fromLTRB(0, 0, widget.scrollDirection == Axis.horizontal ? widget.space : 0, widget.scrollDirection != Axis.horizontal ? widget.space : 0),
              width: widget.pageWidth,
              height: widget.pageHeight,
              decoration: BoxDecoration(
                color: widget.pageColor,
                borderRadius: BorderRadius.all(Radius.circular(widget.radius)),
              ),
            ),
          );
        }),
      ),
    );
  }
}

