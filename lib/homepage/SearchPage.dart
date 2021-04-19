import 'package:flutter/material.dart';
import 'package:flutter_720yun/Common/CommonPage.dart';
import '../NetWorking/NetWorking.dart';
import 'package:dio/dio.dart';
import '../model/HomePageModel.dart';


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
      print(_searchController.text);
      if (_searchController.text.length > 0) {
        isShowClear = true;
      }else{
        isShowClear = false;
        isSearch = false;
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
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            padding: EdgeInsets.only(left: 20,right: 20),
            height: 35,
            child:TextField(
              controller: _searchController,
              focusNode: _focusNodeSearchKey,
              textInputAction: TextInputAction.search,
              onSubmitted: (value) {
                print(value);
                beginSearch();
              },

              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '请输入搜索关键字',
                  hintStyle: TextStyle(color: ColorsUtil.fromEnmu(ColorEnum.desc).withOpacity(0.5), fontSize: 14.0),
                //尾部添加清除按钮
                suffixIcon:(isShowClear)
                    ? IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: (){
                    // 清空输入框内容
                    _searchController.clear();
                  },
                ): null ,
              ),
            ),
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
      return Container(
        padding: EdgeInsets.only(left: 10,right: 10,top: 20,bottom: 20),
        child: Center(
          child: Text('搜索'),
        ),
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
    final url = NetWorkingConfig.baseUrl() + "/api/v1/searchkeywords/";
    // FormData formData = FormData.fromMap(map)
    var data = await NetWorking.get(url);
    print(data);
    if (data['code'] == 200) {
      print(data);
      var keywords = (data['data'] as List).map((e) => SearchKeyWordModel.fromJson(e)).toList();
      datas = keywords;
      setState(() {

      });
    }
  }

  Future<Null> searchActionNetworking() async {
    print('begin');
    final keyword = _searchController.text;
    if (keyword.length == 0) {
      return;
    }
    print('start');
    print(keyword);
    final url = NetWorkingConfig.baseUrl() + "/api/v1/search/";
    FormData formData = FormData.fromMap({'keyword': keyword});
    var data = await NetWorking.formDataPost(url, formData);
    print(data);
    // if (data['code'] == 200) {
    //   print(data);
    //   // var keywords = (data['data'] as List).map((e) => SearchKeyWordModel.fromJson(e)).toList();
    //   // datas = keywords;
    //   // setState(() {
    //   //
    //   // });
    // }
  }
}