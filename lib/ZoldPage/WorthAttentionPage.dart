// import 'package:flutter/material.dart';
// import 'package:flutter_720yun/NetWorking/NetWorking.dart';
// import 'package:flutter_720yun/ZoldPage/ChannelModel.dart';
// import 'dart:ui';
// import 'package:flutter_720yun/ZoldPage/DetailModel.dart';
// import 'package:flutter_720yun/ZoldPage/WorthModel.dart';
// import 'package:cached_network_image/cached_network_image.dart';
//
// double ScreenW = 0.0;
// var headers = {"Origin": "https://720yun.com","Referer": "https://720yun.com"};
//
// class WorthAttentionPage extends StatefulWidget {
//
//   final followed followData;
//
//   WorthAttentionPage(this.followData,{Key key}) : super(key:key);
//
//   @override
//   State<StatefulWidget> createState() {
//     // TODO: implement createState
//     return WorthAttentionPageState();
//   }
// }
//
// class WorthAttentionPageState extends State<WorthAttentionPage> {
//
//   worthHeadModel _headModel;
//   int page = 1;
//   List<worthModel> dataList = [];
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     worthAttentionHead();
//     worthAttentionList();
//   }
//
//   /*
//   Scaffold(
//       appBar: AppBar(
//         title: Text("值得关注"),
//       ),
//     );
//    */
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     double contentSize = MediaQuery.of(context).size.width;
//     ScreenW = contentSize;
//     return CustomScrollView(
//       slivers: <Widget>[
//         SliverAppBar(
//           actions: <Widget>[
//
//           ],
//           title: Text(widget.followData.title),
//           pinned: true,
//           expandedHeight: contentSize * 31.27 / 75,
//           flexibleSpace: FlexibleSpaceBar(
//             background:CachedNetworkImage(imageUrl:_headModel?.thumb ?? "" ,httpHeaders: headers,) // Image.network(_headModel?.thumb ?? ""  ,headers:headers,fit: BoxFit.cover,),
// //            titlePadding: EdgeInsets.only(left: 10,right: 10,bottom: 10),
// //            centerTitle: false,
// //            title: Text( _headModel?.remark ?? "",textAlign: TextAlign.left,style: TextStyle(fontSize: 10,color: Colors.white),),
//           ),
//           floating: false,
//         ),
//         SliverList(
//             delegate: SliverChildBuilderDelegate((context,index){
//               return listItem(dataList[index]);
//             },
//             childCount: dataList.length
//             ),
//         )
//       ],
//     );
//   }
//
//
//   Widget listItem(worthModel model) {
//     return Column(
//       children: <Widget>[
//         Container(
//           color: Colors.white,
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Expanded(
//                 flex:2,
//                 child: Padding(padding: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
//                   child: ClipRRect(
//                     borderRadius:BorderRadius.circular(15.0),
//                     child: Image.network(model.thumb,headers: headers,width: 30,height: 30,fit: BoxFit.cover,),
//                   )
// //                  Container(decoration: BoxDecoration(
// //                    color: Colors.white,
// //                    border: Border.all(color: Colors.white,width: 1),
// //                    borderRadius: BorderRadius.circular(15.0),
// //                  ),child: Image.network(model.thumb,headers: headers,width: 30,height: 30,fit: BoxFit.cover,),
// //                  ),
//                 )
// //                  child: Padding(padding: EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 10),
// //                    child: Image.network(model.thumb,headers: headers,width: 30,height: 30,fit: BoxFit.cover,),)
//               ),
//               Expanded(
//                 flex: 8,
//                 child:
//                 Padding(
//                   padding: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       Padding(
//                         padding: EdgeInsets.only(left: 5,top: 1),
//                         child: Text(
//                           model.nickname,
//                           style: TextStyle(fontSize: 12,
//                             color: Colors.black45,
//                             decoration: TextDecoration.none,
//                           ),
//                           softWrap: false,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.only(top: 5),
//                         child: Text(model.remark,style: TextStyle(fontSize: 12,color: Colors.black45,decoration: TextDecoration.none,),softWrap: false,overflow: TextOverflow.ellipsis),
//                       )
//                     ],
//                   ),
//                 )
//               ),
//               Expanded(
//                 flex: 2,
//                 child: FlatButton(
//                   child: Text("关注"),
//                   color: Colors.blue,
//                   textColor: Colors.white,
//                 ) ,
//               )
//
//             ],
//           ),
//         ),
//         Container(
//           color: Colors.white,
//           child:
//             Padding(padding: EdgeInsets.only(left: 5,top: 5,right: 5,bottom: 5),
//               child: Row(
//                 children: <Widget>[
//                   Expanded(
//                     flex: 1,
//                     child: Padding(padding: EdgeInsets.only(left: 5,right: 5),
//                       child: CachedNetworkImage(imageUrl: model.products[0].thumb,httpHeaders: headers,height: (ScreenW - 40) / 3,width: (ScreenW - 40) / 3,), ////Image.network(model.products[0].thumb,height: (ScreenW - 84) / 6,width: (ScreenW - 84) / 6,headers: headers,fit: BoxFit.cover,),
//                     ),
//                   ),
//
//                   Expanded(
//                     flex: 1,
//                     child: Padding(padding: EdgeInsets.only(left: 5,right: 5),
//                       child: CachedNetworkImage(imageUrl: model.products[1].thumb,httpHeaders: headers,height: (ScreenW - 40) / 3,width: (ScreenW - 40) / 3,),//Image.network(model.products[1].thumb,height: (ScreenW - 84) / 6,width: (ScreenW - 84) / 6,headers: headers,fit: BoxFit.cover,),
//                     ),
//                   ),
//                   Expanded(
//                     flex: 1,
//                     child: Padding(padding: EdgeInsets.only(left: 5,right: 5),
//                       child: CachedNetworkImage(imageUrl: model.products[2].thumb,httpHeaders: headers,height: (ScreenW - 40) / 3,width: (ScreenW - 40) / 3,),//Image.network(model.products[2].thumb,height: (ScreenW - 84) / 6,width: (ScreenW - 84) / 6,headers: headers,fit: BoxFit.cover,),
//                     ),
//                   ),
//                 ],
//               )
//             )
//         )
//       ],
//     );
//   }
//
//
//   Future<Null> worthAttentionHead() async {
//     final url = "https://api-app.720yun.com/foundPage/attention/details";
//     final dic = {"dataId": widget.followData.dataId};
//
//     var data = await NetWorking.get(url,params: dic);
//     if (data["success"] == 1) {
//       var model = data["data"];
//       _headModel = worthHeadModel.fromJson(model);
//     }
//
//     setState(() {
//
//     });
//   }
//
//   Future<Null> worthAttentionList() async {
//     final url = "https://api-app.720yun.com/foundPage/attention";
//     final params = {"dataId": widget.followData.dataId,"page": page};
//
//     var data = await NetWorking.get(url,params: params);
//     print(data);
//
//     if (data["success"] == 1) {
//       var listData = data["data"]["list"];
//       for (int i = 0; i < listData.length;i ++) {
//         var model = worthModel.fromJson(listData[i]);
//         dataList.add(model);
//       }
//     }
//
//     setState(() {
//
//     });
//
//   }
//
//
//
// }