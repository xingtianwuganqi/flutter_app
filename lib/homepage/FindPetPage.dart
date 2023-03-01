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

    // TODO: implement build
    return EasyRefresh(
      header: MaterialHeader(),
        footer: MaterialFooter(
          enableInfiniteLoad: false
        ),
        child: ListView.builder(
          itemCount: _findList.length,
            itemBuilder: (context,index){
          return Container();
        }),
      firstRefresh: isFirstLoad,
      firstRefreshWidget: SpinKitRing(color: ColorsUtil.fromEnmu(ColorEnum.system),size: 30,lineWidth: 3,),
      emptyWidget: _findList.length > 0 ? null : EmptyPage(() async {
        await findPetListNetworking(1);
      }),
      onRefresh:() async {
        await findPetListNetworking(1);
      },
      onLoad: () async{
        await findPetListNetworking(_page);
      },
    );
  }

  Future<void> findPetListNetworking(int page) async {
    _page = page;
    final url = NetWorkingConfig.path(NetPath.findPetList);
    var dic = new Map<String, dynamic>.from(paramDic);
    dic["page"] = page;
    dic["size"] = 10;
    await NetWorking.formDataPost(url, dic, (data) {
      if (data['code'] == 200) {
        var models = data['data'];
        var datas = (models as List).map((e) => FindPetListModel.fromJson(e));
        if (_page == 1) {
          _findList = data;
        }else{
          _findList = _findList + data;
        }
        if (datas.length > 0) {
          _page += 1;
        }
        setState(() {
          isFirstLoad = false;
        });

      }
    }, (error) {

    });
  }
}