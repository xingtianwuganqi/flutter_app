import 'package:flutter/material.dart';
import 'package:flutter_720yun/Common/CommonPage.dart';
import 'package:flutter_720yun/homepage/HomePage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_printer/flutter_printer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../NetWorking/NetWorking.dart';
import 'package:dio/dio.dart';
import '../configuration_sdk.dart';
import '../model/HomePageModel.dart';
import '../Login/LoginPage.dart';
import '../topsize.dart';
import 'TopicDetail.dart';
import 'package:shared_preferences/shared_preferences.dart';


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
  List<String> searchHistory = [];
  List<HomePageModel> homeModels = [];

  FocusNode _focusNodeSearchKey = new FocusNode();

  //用户名输入框控制器，此控制器可以监听用户名输入框操作
  TextEditingController _searchController = new TextEditingController();

  //表单状态
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var isShowClear = false;
  var _page = 1;
  bool isFirstLoad = true;


  ///加载图片的标识
  bool isLoadingImage = true;

  bool notificationFunction(Notification notification) {
    ///通知类型
    switch (notification.runtimeType) {
      case ScrollStartNotification:
        Printer.printMapJsonLog("开始滚动");
        ///在这里更新标识 刷新页面 不加载图片
        isLoadingImage = false;
        break;
      case ScrollUpdateNotification:
        Printer.printMapJsonLog("正在滚动");
        break;
      case ScrollEndNotification:
        Printer.printMapJsonLog("滚动停止");

        ///在这里更新标识 刷新页面 加载图片
        setState(() {
          isLoadingImage = true;
        });
        break;
      case OverscrollNotification:
        Printer.printMapJsonLog("滚动到边界");
        break;
    }
    return true;
  }

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
                    cursorColor: ColorsUtil.fromEnmu(ColorEnum.desc),
                    onSubmitted: (value) {
                      beginSearch(1);
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
    return Container(
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              child: searchHistory.length == 0 ? null: Column(
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    child: Row(
                      children: [
                        Text('历史搜索',style: TextStyle(fontSize: FontUtil.fs(FontSize.content),
                            fontWeight: FontWeight.w600,
                            color: ColorsUtil.fromEnmu(ColorEnum.title)),
                        ),
                        Expanded(flex: 1,child: Container(),),
                        IconButton(icon: Icon(Icons.delete),color: Colors.grey, onPressed: (){
                          // 移除本地搜索历史
                          removeHistory();
                          searchHistory = [];
                          setState(() {

                          });
                        })
                      ],
                    )
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Wrap(
                      spacing: 15,
                      children: List.generate(searchHistory.length, (index) {
                        var text = searchHistory[index];
                        return RawChip(
                          label: Text(text,
                              style: TextStyle(color: ColorsUtil.fromEnmu(ColorEnum.content))),
                          backgroundColor: ColorsUtil.fromEnmu(ColorEnum.defIcon),
                          onPressed: (){
                            /// 点击
                            _searchController.value = _searchController.value.copyWith(
                              text: text,
                              selection:
                              TextSelection(baseOffset: text.length, extentOffset: text.length),
                              composing: TextRange.empty,
                            );
                            beginSearch(1);
                          },
                        );
                      }).toList(),
                    ) ,
                  )
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: datas.length == 0 ? null: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(top: 7,bottom: 7),
                    child: Text('热门搜索',style: TextStyle(fontSize: FontUtil.fs(FontSize.content),
                        fontWeight: FontWeight.w600,
                        color: ColorsUtil.fromEnmu(ColorEnum.title)),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Wrap(
                      spacing: 15,
                      children: List.generate(datas.length, (index) {
                        var data = datas[index];
                        return RawChip(
                          label: Text(data.keyword ?? '',
                              style: TextStyle(color: ColorsUtil.fromEnmu(ColorEnum.content))),
                          backgroundColor: ColorsUtil.fromEnmu(ColorEnum.defIcon),
                          onPressed: (){
                            /// 点击
                            _searchController.value = _searchController.value.copyWith(
                              text: data.keyword,
                              selection:
                              TextSelection(baseOffset: data.keyword?.length ?? 0, extentOffset: data.keyword?.length ?? 0),
                              composing: TextRange.empty,
                            );
                            beginSearch(1);
                          },
                        );
                      }).toList(),
                    ) ,
                  )
                ],
              ),
            ),
            // Text('选中：${_filters.join(',')}'),
          ],
        )
    );
  }

  saveSearchWord(String keyword) async{
    if (keyword.length > 0) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      try{
        List<String>? keywords = prefs.getStringList('searchKeyWords');
        if (keywords != null) {
          // 有值的话先移除
          if (keywords.contains(keyword)) {
            keywords.remove(keyword);
          }
          keywords.insert(0, keyword);
          // 最多保留20条记录
          if (keywords.length == 21) {
            keywords.removeLast();
          }
          prefs.setStringList('searchKeyWords', keywords);
          print(keywords);
          setState(() {
            searchHistory = keywords;
          });
        }else{
          var keywords = [keyword];
          prefs.setStringList('searchKeyWords',keywords);
          setState(() {
            searchHistory = keywords;
          });
        }
      }catch(e){
        print("happen catch");
      }
    }
  }

  void removeHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try{
      prefs.remove('searchKeyWords');
    }catch(e){

    }
  }

  void readSearchHistory() async{
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? keywords = prefs.getStringList('searchKeyWords');
      if (keywords != null) {
        setState(() {
          searchHistory = keywords;
        });
      }
    }catch(e){

    }
  }

  beginSearch(int page) {
    if (_searchController.text.length == 0) {
      return;
    }
    isSearch = true;
    if (page == 1) {
      isFirstLoad = true;
    }else{
      isFirstLoad = false;
    }
    searchActionNetworking(page);
    setState(() {

    });
  }

  Widget commontPageWidget() {
    if (isSearch) {
      return refreshBody();
    }else{
      return Container(
        padding: EdgeInsets.all(15),
        child: keywordsListWidget(datas),
      );
    }
  }

  Widget refreshBody() {
    return EasyRefresh(
      header: MaterialHeader(),
      footer: MaterialFooter(
        enableInfiniteLoad:false,
      ),
      child: ListView.builder(
          itemCount: homeModels.length,
          itemBuilder: (context,index) {
            var data = homeModels[index];

              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return TopicDetailWidget(data.topic_id ?? 0);
                  }));
                },
                child: homePageItemWidget(context,data,(topicId,value) {
                  if (value is HomeLikeStatusModel) {
                    homeModels = homeModels.map((e) {
                      var newModel = e;
                      if (newModel.topic_id == topicId) {
                        newModel.liked = value.like == 1 ? true : false;
                        if (newModel.liked ?? false) {
                          if (newModel.likes_num != null) {
                            var num = newModel.likes_num ?? 0;
                            num += 1;
                            newModel.likes_num = num;
                          }else{
                            newModel.likes_num = 1;
                          }

                        }else if (newModel.liked == false){
                          var num = newModel.likes_num ?? 0;
                          if (num > 0) {
                            num -= 1;
                            newModel.likes_num = num;
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
                        if (newModel.collectioned ?? false) {
                          if (newModel.collection_num != null) {
                            var num = newModel.collection_num ?? 0;
                            num += 1;
                            newModel.collection_num = num;
                          }else{
                            newModel.collection_num = 1;
                          }
                        }else if (newModel.collectioned == false){
                          var num = newModel.collection_num ?? 0;
                          if (num > 0) {
                            num -= 1;
                            newModel.collection_num = num;
                          }
                        }
                      }
                      return newModel;
                    }).toList();
                  }else if(value is int) {
                    homeModels = homeModels.map((e) {
                      var newModel = e;
                      if (newModel.topic_id == topicId) {
                        newModel.commNum = value;
                      }
                      return newModel;
                    }).toList();
                  }
                  setState(() {

                  });
                }),
              );
            }
      ),
      // firstRefresh: isFirstLoad,
      // firstRefreshWidget: SpinKitRing(color: ColorsUtil.fromEnmu(ColorEnum.system),size: 30,lineWidth: 3,),
      emptyWidget: isFirstLoad ? null : (homeModels.length > 0   ? null : EmptyPage(() async{
        await beginSearch(1);
      })),
      onRefresh: () async {
        await beginSearch(1);
      },
      onLoad: () async{
        await beginSearch(_page);
      },
    );
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
    await NetWorking.get(url, (data) {
      if (data['code'] == 200) {
        var keywords = (data['data'] as List).map((e) => SearchKeyWordModel.fromJson(e)).toList();
        datas = keywords;
        readSearchHistory();
        setState(() {

        });
      }
    }, (error) {
      // 失败
    });

  }

  Future<Null> searchActionNetworking(int page) async {
    _page = page;
    final keyword = _searchController.text;
    saveSearchWord(_searchController.text);
    if (keyword.length == 0) {
      return;
    }
    final url = NetWorkingConfig.path(NetPath.search);
    /*
    parameter["keyword"] = keyword
            parameter["token"] = UserManager.shared.token
            parameter["page"] = page
            parameter["size"] = 10
     */
    var dic = new Map<String, dynamic>.from(paramDic);
    dic['keyword'] = keyword;
    dic['page'] = _page;
    dic['size'] = 10;
    await NetWorking.formDataPost(url, dic, (data) {
      print(data);
      if (data['code'] == 200) {
        List<HomePageModel> datas = [];
        var models = data['data'];
        for (int i = 0; i < models.length; i++) {
          datas.add(new HomePageModel.fromJson(models[i]));
        }
        _page == 1 ? homeModels = datas : homeModels = homeModels + datas;
        if (datas.length > 0) {
          _page += 1;
        }

        setState(() {
          isFirstLoad = false;
        });
      } else {
        EasyLoading.showToast(data['message'] ?? '');
      }
    }, (error) {
      EasyLoading.showToast('网络出错');
    });
  }
}
