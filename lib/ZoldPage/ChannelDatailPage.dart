import 'package:flutter/material.dart';
import 'package:flutter_720yun/NetWorking/NetWorking.dart';
import 'package:flutter_720yun/ZoldPage/DetailModel.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ChannelDetail extends StatefulWidget {
  final int Id;
  final String titleDetail;
  ChannelDetail(this.Id,this.titleDetail,{Key key}) : super(key : key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ChannelDetailState();
  }
}

class ChannelDetailState extends State<ChannelDetail> {


  List<IconData> _icons = [];
  List<detailModel> dataList = [];
  var headers = {"Origin": "https://720yun.com","Referer": "https://720yun.com"};
  final imgHeader = "https://ssl-thumb.720static.com/@";
  final imgBottomer = "?imageMogr2/thumbnail/240";
  ScrollController _scrollController = ScrollController();
  int _page = 1;
  bool _isLoading = false;

  int totalCount = 0;
  String description = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    networking();
    panoDescription();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        print("滑到了底部");
        getMore();
      }
    });

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }

  /*
    RefreshIndicator(
          child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5
              ),
              itemCount: dataList.length,
              itemBuilder: (context,index){
                return itemwidget(dataList[index]);
              },
              controller: _scrollController,
              ),
          onRefresh: networking,
      ),
   */

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.titleDetail),
      ),
      body: totalWidget()
    );
  }

  Widget totalWidget() {
    return RefreshIndicator(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 20,left: 20,right: 20),
                    child: Text(description),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10,left: 20,bottom: 20),
                    child: Text(totalCount.toString()+"幅作品",textAlign: TextAlign.left,),
                  )

                ],
              ),
            ),
            SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
              ),
              delegate: new SliverChildBuilderDelegate((context,index){
                return itemwidget(dataList[index]);
              },
                childCount: dataList.length,

              ),
            )
          ],
          controller: _scrollController,
        ),
        onRefresh: networking);
  }

  //"https://ssl-thumb.720static.com/@/resource/prod/b35i74ed923/51d25azgcbg/17896762/imgs/thumb.jpg?imageMogr2/thumbnail/240"
  Widget itemwidget(detailModel model) {
    return Container(
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
//          Image.network(imgHeader+model.property.thumbUrl+imgBottomer, headers: headers,),
          CachedNetworkImage(imageUrl: imgHeader+model.property.thumbUrl+imgBottomer,httpHeaders: headers,),
          Positioned(
            left: 10,
            right: 10,
            bottom: 10,
            child: Text(model.property.name,
              style: TextStyle(fontSize: 12,
                  color: Colors.white),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis
              ,),
          )
        ],
      ),
    );
  }

  Future<Null> panoDescription() async{
    final url = "https://apiv4.720yun.com//channels";
    var data = await NetWorking.get(url);
    print(data);
    List<channelModel> channelList = [];
    if (data["success"] == 1) {
      var list = data["data"];
      for (int i = 0;i < list.length; i++) {
        var channel = channelModel.fromJson(list[i]);
        channelList.add(channel);
        if (channel.id == widget.Id) {
          description = channel.remark;
        }
      }
    }
  }

  Future<Null> networking() async {
    if (_isLoading == true) {
      return null;
    }
    _page = 1;
    _isLoading = true;
    final url = "https://apiv4.720yun.com/products";
    var dic = {"channelId":widget.Id,"page": _page};
    var data = await NetWorking.get(url,params: dic);
    if (data["success"] == 1) {
      var list = data["data"]["list"];
      totalCount = data["data"]["count"];
      dataList.clear();
      for (int i = 0; i < list.length;i++) {
        var dataDetail = detailModel.fromJson(list[i]);
        dataList.add(dataDetail);

      }
      _isLoading = false;
    }

    setState(() {

    });
  }

  Future<Null> getMore() async {
    if (_isLoading == true) {
      return null;
    }
    _page = _page + 1;
    _isLoading = true;
    final url = "https://apiv4.720yun.com/products";
    var dic = {"channelId":widget.Id,"page": _page};
    var data = await NetWorking.get(url,params: dic);
    if (data["success"] == 1) {
      var list = data["data"]["list"];
      for (int i = 0; i < list.length;i++) {
        var dataDetail = detailModel.fromJson(list[i]);
        dataList.add(dataDetail);

      }
      _isLoading = false;
    }

    setState(() {

    });
  }
}
