import 'package:flutter/material.dart';
import 'package:flutter_720yun/NetWorking/NetWorking.dart';
import 'package:flutter_720yun/homepage/BlackDetailPage.dart';
import 'package:flutter_720yun/model/BlackPageModel.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_720yun/Common/CommonPage.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';


class BlackListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return BlackListState();
  }
}

class BlackListState extends State<BlackListPage> {

  List<BlackListModel> datas = [];
  bool isFirstLoad = true;
  int _page = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    blackListNetworking(1);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("黑名单"),
        elevation: 0.5,
      ),
      body: refreshBody(),
    );
  }

  Widget refreshBody() {
    return EasyRefresh(
      header: MaterialHeader(),
      footer: MaterialFooter(
        enableInfiniteLoad:false,
      ),
      child: ListView.builder(
          itemCount: datas.length,
          itemBuilder: (context,index) {
            var data = datas[index];
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return BlackDetailPage(blackType: BlackType.detail,blackId: data.id);
                }));
              },
              child: blackItem(data)
            );
          }
      ),
      // firstRefresh: isFirstLoad,
      // firstRefreshWidget: SpinKitRing(color: ColorsUtil.fromEnmu(ColorEnum.system),size: 30,lineWidth: 3,),
      emptyWidget: isFirstLoad ? null : (datas.length > 0   ? null : EmptyPage(() async{
        await blackListNetworking(1);
      })),
      onRefresh: () async {
        await blackListNetworking(1);
      },
      onLoad: () async{
        await blackListNetworking(_page);
      },
    );
  }

  Widget blackItem(BlackListModel model) {
    return Column(
      children: [
          Container(
          width: double.infinity,
          height: 60,
          child: Row(
            children: [
              (model.wx_num != null && model.wx_num.length > 0) ?
              Padding(
                padding: EdgeInsets.only(left: 15,right: 15,top: 10,bottom: 10),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: 20,
                      child: Text(model.contact,
                        maxLines:1,
                        overflow:TextOverflow.ellipsis,
                        style: TextStyle(fontSize: FontUtil.fs(FontSize.content),
                            color: ColorsUtil.fromEnmu(ColorEnum.title)
                        )
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: 20,
                      child: Text(model.wx_num,
                          maxLines:1,
                          overflow:TextOverflow.ellipsis,
                          style: TextStyle(fontSize: FontUtil.fs(FontSize.desc),
                              color: ColorsUtil.fromEnmu(ColorEnum.desc)
                          )
                      ),
                    )
                  ],
                ),
              ): Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(left: 15,right: 15),
                  child: Text(model.contact,
                      maxLines:1,
                      overflow:TextOverflow.ellipsis,
                      style: TextStyle(fontSize: FontUtil.fs(FontSize.content),
                          color: ColorsUtil.fromEnmu(ColorEnum.title)
                      )
                  )
              ),
              Expanded(child: Container(
                child: Text(
                  model.desc,
                  maxLines:2,
                  overflow:TextOverflow.ellipsis,
                  style: TextStyle(fontSize: FontUtil.fs(FontSize.desc),
                    color: ColorsUtil.fromEnmu(ColorEnum.desc)
                  ),
                ),
              ),),
              Container(
                padding: EdgeInsets.only(left: 15,right: 15),
                child: Text(
                    model.black_type == 1 ? "领养人" : "送养人",
                    maxLines:1,
                    overflow:TextOverflow.ellipsis,
                    style: TextStyle(fontSize: FontUtil.fs(FontSize.content),
                        color: ColorsUtil.fromEnmu(ColorEnum.desc)
                    )
                ),
              )
            ],
          ),
        ),
        Divider(height: 1,color: ColorsUtil.fromEnmu(ColorEnum.defIcon),)
      ],
    );
  }

  Future<Null> blackListNetworking(page) async {
    _page = page;
    EasyLoading.show();
    final url = NetWorkingConfig.path(NetPath.blackList);
    var dic = new Map<String, dynamic>.from(paramDic);
    dic['page'] = _page;
    dic['size'] = 10;
    print(dic);
    await NetWorking.formDataPost(url, dic, (data) {
      print(data);
      EasyLoading.dismiss();
      if (data['code'] == 200) {
        if((data['data'] as List).length == 0) {
          return;
        }
        var models = (data['data'] as List).map((e) {
          return BlackListModel.fromJson(e);
        }).toList();
        if (page == 1) {
          datas = models;
        }else{
          datas = datas + models;
        }
        if (models.length > 0) {
          _page += 1;
        }

        setState(() {

        });
      }else{

      }
    }, (error) {
      EasyLoading.showToast('请求失败');
    });
  }
}