import 'package:flutter/material.dart';
import 'package:flutter_720yun/Common/CommonPage.dart';
import 'package:flutter_720yun/NetWorking/NetWorking.dart';
import 'package:flutter_720yun/model/FindPetListModel.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class FindPetPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return FindPetState();
  }
}

class FindPetState extends State<FindPetPage> {
  List<FindPetListModel> _findList = [];
  int _page = 1;
  bool isFirstLoad = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findPetListNetworking(1);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        EasyRefresh(
        header: MaterialHeader(),
        footer: MaterialFooter(
          enableInfiniteLoad: false
        ),
        child: ListView.builder(
          itemCount: _findList.length,
          itemBuilder: (context,index){
          var data = _findList[index];
          if (data.findId == -1) {
            return findHeaderWidget();
          }else{
            return Container();
          }
          }),
        firstRefresh: isFirstLoad,
        firstRefreshWidget: SpinKitRing(color: ColorsUtil.fromEnmu(ColorEnum.system),size: 30,lineWidth: 3,),
        emptyWidget:
        _findList.length > 0 ? null : EmptyPage(() async {
        await findPetListNetworking(1);
        }),
        // null,
        onRefresh:() async {
        await findPetListNetworking(1);
        },
        onLoad: () async{
        await findPetListNetworking(_page);
        },
        )
      ],
    );
    // TODO: implement build
  }

  Widget findHeaderWidget() {
    return Container(
      height: 86,
        decoration: BoxDecoration(
          color: ColorsUtil.fromEnmu(ColorEnum.system),
          borderRadius: BorderRadius.circular(Radius.circular(8) as double)
        ),
      child: Row(
        children: [
          Text("找宠小助手",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700),),
          Expanded(child: Container()),
          Stack(

          )
        ],
      ),
    );
  }

  Future<void> findPetListNetworking(int page) async {
    _page = page;
    final url = NetWorkingConfig.path(NetPath.findPetList);
    var dic = new Map<String, dynamic>.from(paramDic);
    dic["page"] = page;
    dic["size"] = 10;
    await NetWorking.formDataPost(url, dic, (data) {
      print(data);
      if (data['code'] == 200) {
        var models = data['data'];
        var dataSourses = (models as List).map((e) => FindPetListModel.fromJson(e)).toList();
        if (_page == 1) {
          var findHeader = FindPetListModel(findId: -1);
          _findList = [findHeader] + dataSourses;
        }else{
          _findList = _findList + dataSourses;
        }
        if (dataSourses.length > 0) {
          _page += 1;
        }

      }
      isFirstLoad = false;
      setState(() {

      });
    }, (error) {
      print(error);
      setState(() {

      });
    });
  }
}