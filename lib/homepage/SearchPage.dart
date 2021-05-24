import 'package:flutter/material.dart';
import 'package:flutter_720yun/Common/CommonPage.dart';
import 'package:flutter_720yun/homepage/HomePage.dart';
import '../NetWorking/NetWorking.dart';
import 'package:dio/dio.dart';
import '../model/HomePageModel.dart';
import '../Login/LoginPage.dart';

class SearchPageWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SearchPageState();
  }
}

class SearchPageState extends State<SearchPageWidget> {

  bool isSearch = false;
  List<SearchKeyWordModel> datas = [];
  List<HomePageModel> homeModels = [];

  FocusNode _focusNodeSearchKey = new FocusNode();

  //用户名输入框控制器，此控制器可以监听用户名输入框操作
  TextEditingController _searchController = new TextEditingController();

  //表单状态
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var isShowClear = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchKeyWordsNetworking();

    _searchController.addListener(() {
      if (_searchController.text.length > 0) {
        isShowClear = true;
      }else{
        isShowClear = false;
        isSearch = false;
        homeModels = [];
      }
      setState(() {

      });
    });

  }

  Widget seachBarWidget() {
    return Container(
      child: Row(
        children: [
          Expanded(child: Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            padding: EdgeInsets.only(left: 20,right: 0),
            height: 35,
            child:
              Row(
                children: [
                  Expanded(child:
                    TextField(
                    controller: _searchController,
                    focusNode: _focusNodeSearchKey,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (value) {
                      beginSearch();
                    },

                    decoration: InputDecoration.collapsed(
                      border: InputBorder.none,
                      hintText: '请输入搜索关键字',
                      hintStyle: TextStyle(color: ColorsUtil.fromEnmu(ColorEnum.desc).withOpacity(0.5), fontSize: 14.0),

                      //尾部添加清除按钮
                      // suffixIcon:(isShowClear)
                      //     ? IconButton(
                      //   icon: Icon(Icons.clear),
                      //   /// 点击清除按钮
                      //   onPressed: (){
                      //     // 清空输入框内容
                      //     homeModels = [];
                      //     _searchController.clear();
                      //     setState(() {
                      //
                      //     });
                      //   },
                      // ): null ,
                    ),
                  ),
                  ),Container(
                    child: (isShowClear)
                        ? IconButton(
                      icon: Icon(Icons.clear,color: Colors.black26,),
                      /// 点击清除按钮
                      onPressed: (){
                        // 清空输入框内容
                        homeModels = [];
                        _searchController.clear();
                        setState(() {

                        });
                      },
                    ): null
                    ),
                ],
              )
          ),
          ),
          TextButton(onPressed: () {
            Navigator.pop(context);
          }, child: Text("取消",
            style: TextStyle(
              fontSize: FontUtil.fs(FontSize.content),
              color: ColorsUtil.fromEnmu(ColorEnum.content),
            ),
          )
          )
        ],
      ),
    );
  }

  Widget keywordsListWidget(List<SearchKeyWordModel> datas) {
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 2.2
        ),
        itemCount: datas.length,
        itemBuilder: (context,index){
          var item = datas[index];
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                border:Border.all(
                  width: 1,
                  color: ColorsUtil.fromEnmu(ColorEnum.tableBack)
                )
            ),
            child: TextButton(
              child: Text(item.keyword,
                style: TextStyle(fontSize: FontUtil.fs(FontSize.content),
                  color: ColorsUtil.fromEnmu(ColorEnum.content),
                ),
              ),
              onPressed: () {
                /// 点击
                  _searchController.value = _searchController.value.copyWith(
                    text: item.keyword,
                    selection:
                    TextSelection(baseOffset: item.keyword.length, extentOffset: item.keyword.length),
                    composing: TextRange.empty,
                  );
                  beginSearch();
              },
            ),
          );
        });
  }

  beginSearch() {
    if (_searchController.text.length == 0) {
      return;
    }
    isSearch = true;
    searchActionNetworking();
    setState(() {

    });
  }

  Widget commontPageWidget() {
    if (isSearch) {
      return ListView.builder(
          itemCount: homeModels.length,
          itemBuilder: (context,index) {
            var data = homeModels[index];
            return homePageItemWidget(context,data,(topicId,value) {
              if (value is HomeLikeStatusModel) {
                homeModels = homeModels.map((e) {
                  var newModel = e;
                  if (newModel.topic_id == topicId) {
                    newModel.liked = value.like == 1 ? true : false;
                    if (newModel.liked) {
                      newModel.likes_num += 1;
                    }else if (newModel.liked == false){
                      if(newModel.likes_num > 0) {
                        newModel.likes_num -= 1;
                      }
                    }
                  }
                  return newModel;
                }).toList();
              }else if (value is HomeCollectionStatusModel){
                homeModels = homeModels.map((e) {
                  var newModel = e;
                  if (newModel.topic_id == topicId) {
                    newModel.collectioned = value.collection == 1 ? true : false;
                    if (newModel.collectioned) {
                      newModel.collection_num += 1;
                    }else if (newModel.collectioned == false){
                      if(newModel.collection_num > 0) {
                        newModel.collection_num -= 1;
                      }
                    }
                  }
                  return newModel;
                }).toList();
              }
              setState(() {

              });
            });
          }
      );
    }else{
      return Container(
        padding: EdgeInsets.only(left: 10,right: 10,top: 20,bottom: 20),
        child: keywordsListWidget(datas),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: seachBarWidget(),
        automaticallyImplyLeading: false,
        elevation: 0.5,
      ),
      body: GestureDetector(
        onTap: () {
          _focusNodeSearchKey.unfocus();
        },
        child: commontPageWidget()
      )
    );
  }

  Future<Null> searchKeyWordsNetworking() async {
    final url = NetWorkingConfig.path(NetPath.searchkeyword);
    // FormData formData = FormData.fromMap(map)
    await NetWorking.get(url, (data) {
      if (data['code'] == 200) {
        var keywords = (data['data'] as List).map((e) => SearchKeyWordModel.fromJson(e)).toList();
        datas = keywords;
        setState(() {

        });
      }
    }, (error) {
      // 失败
    });

  }

  Future<Null> searchActionNetworking() async {
    final keyword = _searchController.text;
    if (keyword.length == 0) {
      return;
    }
    final url = NetWorkingConfig.path(NetPath.search);
    var dic = paramDic;
    dic['keyword'] = keyword;
    FormData formData = FormData.fromMap(dic);
    await NetWorking.formDataPost(url, formData,(data){
      if (data['code'] == 200) {
        List<HomePageModel> datas = [];
        var models = data['data'];
        for (int i = 0;i < models.length; i++ ){
          datas.add(new HomePageModel.fromJson(models[i]));
        }
        homeModels = datas;
        setState(() {

        });
      }else{

      }
    },(error){

    });

  }



}

// ///UI
// Widget homePageItemWidget(HomePageModel data) {
//   return Container(
//     child: Column(
//       children: [
//         userInfoWidget(data),
//         textInfoWidget(data),
//         imagesWidget(data),
//         addressWidget(data),
//         commentWidget(data),
//         Divider(height: 1,),
//       ],
//     ),
//   );
// }
//
// Widget userInfoWidget(HomePageModel data) {
//   return Container(
//     padding: EdgeInsets.only(top: 10,left: 15,right: 15,bottom: 0),
//     child: Row(
//       children: [
//         CircleAvatar(
//           radius: 18,
//           backgroundImage: NetworkImage("http://img.rxswift.cn/" + data.userInfo.avator),
//           child: Container(
//             alignment: Alignment(0, 0),
//             width: 36,
//             height: 36,
//           ),
//         ),
//         Container(
//             alignment: Alignment.centerLeft,
//             padding: EdgeInsets.only(left: 10),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(data.userInfo.username ?? "",
//                     textAlign: TextAlign.left,
//                     style: TextStyle(
//                         color: ColorsUtil.fromEnmu(ColorEnum.title),
//                         fontSize: FontUtil.fs(FontSize.title)),
//                     overflow: TextOverflow.ellipsis),
//                 Padding(padding: EdgeInsets.all(3)),
//                 Text(data.create_time ?? "",
//                     style: TextStyle(color: ColorsUtil.fromEnmu(ColorEnum.desc),
//                         fontSize: FontUtil.fs(FontSize.desc)),
//                     overflow: TextOverflow.ellipsis)
//               ],
//             )),
//         Expanded(
//             child: Container(
//
//             )),
//         IconButton(icon: Icon(Icons.more_horiz_outlined,
//           color: ColorsUtil.fromEnmu(ColorEnum.content),
//         ), onPressed: (){}),
//       ],
//     ),
//   );
// }
//
// /// 便签文字区
// Widget textInfoWidget(HomePageModel data) {
//   /// 标签
//   List<Widget> tags = [];
//
//   if (data.tagInfos != null ) {
//     if (data.tagInfos.isNotEmpty) {
//       tags = data.tagInfos.map((e) => Container(
//         decoration: BoxDecoration(
//             color: ColorsUtil.fromEnmu(ColorEnum.system),
//             borderRadius: BorderRadius.all(Radius.circular(3.0))
//         ),
//         padding: EdgeInsets.only(left: 5,right: 5,top: 1,bottom: 1),
//         child: Text(e.tag_name ?? "",
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 12,
//           ),
//         ),
//       )).toList();
//     }
//   }
//   return Container(
//     child: Column(
//       children: [
//         // 标签
//         Container(
//           // ignore: null_aware_before_operator
//           padding: EdgeInsets.only(left: 60,right: 15,top: 2,bottom: 2),
//           alignment: Alignment.centerLeft,
//           height: tags.length > 0 ? 26 : 3,
//           child: Row(
//             children: tags,
//           ),
//         ),
//         Container(
//           padding: EdgeInsets.only(left: 60,right: 10,top: 5,bottom: 5),
//           alignment: Alignment.centerLeft,
//           child: Text(data.content ?? '',
//             maxLines: 7,
//             style: TextStyle(
//               fontSize: FontUtil.fs(FontSize.content),
//               color: ColorsUtil.fromEnmu(ColorEnum.content),
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }

// Widget imagesWidget(HomePageModel data) {
//   if (data.imgs?.length > 4) {
//     return Container(
//       padding: EdgeInsets.only(left: 60,right: 20,top: 5,bottom: 5),
//       height: 250,
//       child: Column(
//         children: [
//           Expanded(
//             child: Container(
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Container(
//                       padding: EdgeInsets.only(right: 5,bottom: 5),
//                       child: Image.network(
//                           'http://img.rxswift.cn/' + data.imgs[0],
//                           fit:BoxFit.cover,
//                           width: double.infinity,
//                           height: double.infinity
//                         // width: (MediaQuery.of(context).size.width - 100) / 2,
//                         // height: 120,
//                       ),
//                     ),
//                   ),
//                   Expanded(child:
//                   Container(
//                     padding: EdgeInsets.only(left:5,bottom: 5),
//                     child: Image.network(
//                         'http://img.rxswift.cn/' + data.imgs[1],
//                         fit:BoxFit.cover,
//                         width: double.infinity,
//                         height: double.infinity
//                     ),
//
//                   )
//                   )
//                 ],
//               ),
//             ),
//           ),
//           Expanded(
//               child:
//               Container(
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child:
//                       Container(
//                         padding: EdgeInsets.only(right:5,top: 5),
//                         child: Image.network(
//                             'http://img.rxswift.cn/' + data.imgs[2],
//                             fit:BoxFit.cover,
//                             width: double.infinity,
//                             height: double.infinity
//                           // height: 120,
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                         child: Container(
//                           padding: EdgeInsets.only(left:5,top: 5),
//                           child: Image.network(
//                               'http://img.rxswift.cn/' + data.imgs[3],
//                               fit:BoxFit.cover,
//                               width: double.infinity,
//                               height: double.infinity
//                             // height: 120,
//
//                           ),
//                         )
//                     )
//                   ],
//                 ),
//               )
//           )
//         ],
//       ),
//     );
//   }else if (data.imgs?.length == 3) {
//     return Container(
//       padding: EdgeInsets.only(left: 60,right: 20,top: 5,bottom: 5),
//       // width: MediaQuery.of(context).size.width - 65,
//       height: 170,
//       child: Row(
//         children: [
//           Expanded(
//             child:
//             Container(
//               padding: EdgeInsets.only(right: 5),
//               child: Image.network(
//                   'http://img.rxswift.cn/' + data.imgs[0],
//                   fit:BoxFit.cover,
//                   width: double.infinity,
//                   height: double.infinity
//               ),
//             ),
//           ),
//           Expanded(
//               child:
//               Container(
//                 child: Column(
//                   children: [
//                     Expanded(
//                       child:
//                       Container(
//                         padding: EdgeInsets.only(left:5,bottom: 5),
//                         child: Image.network(
//                             'http://img.rxswift.cn/' + data.imgs[1],
//                             fit:BoxFit.cover,
//                             width: double.infinity,
//                             height: double.infinity
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                         child: Container(
//                           padding: EdgeInsets.only(left:5,top: 5),
//                           child: Image.network(
//                               'http://img.rxswift.cn/' + data.imgs[2],
//                               fit:BoxFit.cover,
//                               width: double.infinity,
//                               height: double.infinity
//                           ),
//                         )
//                     )
//                   ],
//                 ),
//               )
//           )
//         ],
//       ),
//     );
//   }else if (data.imgs.length == 2) {
//     return Container(
//
//       padding: EdgeInsets.only(left: 60,right: 20,top: 5,bottom: 5),
//       // width: MediaQuery.of(context).size.width - 65,
//       height: 170,
//       child: Row(
//         children: [
//           Expanded(
//             child:
//             Container(
//               padding: EdgeInsets.only(right: 5),
//               child: Image.network(
//                   'http://img.rxswift.cn/' + data.imgs[0],
//                   fit:BoxFit.cover,
//                   width: double.infinity,
//                   height: double.infinity
//               ),
//             ),
//           ),
//           Expanded(
//             child:
//             Container(
//               padding: EdgeInsets.only(left: 5),
//               child: Image.network(
//                   'http://img.rxswift.cn/' + data.imgs[1],
//                   fit:BoxFit.cover,
//                   width: double.infinity,
//                   height: double.infinity
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }else if (data.imgs?.length == 1) {
//     return Container(
//       padding: EdgeInsets.only(left: 60,right: 20,top: 5,bottom: 5),
//       // width: MediaQuery.of(context).size.width - 65,
//       height: 170,
//       child: Image.network(
//           'http://img.rxswift.cn/' + data.imgs[0],
//           fit:BoxFit.cover,
//           width: double.infinity,
//           height: double.infinity
//       ),
//     );
//   }
// }
//
// Widget addressWidget(HomePageModel data) {
//   return Container(
//     padding: EdgeInsets.only(left: 60,right: 15,top: 5,bottom: 5),
//     alignment: Alignment.centerLeft,
//     child: Text(data.address_info,
//       style: TextStyle(
//         fontSize: FontUtil.fs(FontSize.content),
//         color: ColorsUtil.fromEnmu(ColorEnum.desc),
//       ),
//     ),
//   );
// }
//
// Widget commentWidget(HomePageModel data) {
//   return Container(
//     padding: EdgeInsets.only(left: 60,right: 15),
//     height: 40,
//     child: Row(
//       children: [
//         Expanded(
//             child: TextButton.icon(
//               icon:Icon(Icons.panorama),
//               label: Text((data.likes_num ?? 0) > (0) ? data.likes_num.toString() : "点赞"),
//               onPressed: (){
//                 if (UserManager.instance.isLogin) {
//
//                 }else{
//                   Navigator.push(context, MaterialPageRoute(builder: (context){
//                     return LoginWidget();
//                   }));
//                 }
//               },
//             )
//         ),
//         Expanded(
//             child: TextButton.icon(
//               icon:Icon(Icons.panorama),
//               label: Text((data.collection_num ?? 0) > (0) ? data.collection_num.toString() : "收藏"),
//               onPressed: (){},
//             )
//         ),
//         Expanded(
//             child: TextButton.icon(
//               icon:Icon(Icons.panorama),
//               label: Text((data.commNum ?? 0) > (0) ? data.commNum.toString() : "收藏"),
//               onPressed: (){},
//             )
//         ),
//       ],
//     ),
//   );
// }