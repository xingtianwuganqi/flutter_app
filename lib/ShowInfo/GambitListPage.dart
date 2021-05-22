import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_720yun/model/ShowModel.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../NetWorking/NetWorking.dart';
import '../Common/CommonPage.dart';
import 'ShowInfoSinglePage.dart';

class GambitListWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return GambitListState();
  }
}

class GambitListState extends State<GambitListWidget> with AutomaticKeepAliveClientMixin{

  //导航栏切换时保持原有状态
  @override
  bool get wantKeepAlive => true;

  var isFirstLoad = true;

  List<GambitModel> gambitList = [];

  @override
  void initState() {
    super.initState();
    // 创建Controller
    GambitListNetWroking();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      EasyRefresh(
        header: MaterialHeader(),
        footer: MaterialFooter(
          enableInfiniteLoad: false,
        ),
        firstRefresh: isFirstLoad,
        firstRefreshWidget: SpinKitRing(color: ColorsUtil.fromEnmu(ColorEnum.system),size: 30,lineWidth: 3,),
        emptyWidget: null,
        child: ListView.builder(
          itemCount: gambitList.length,
          cacheExtent: 50,
          itemBuilder: (context, index) {
            var data = gambitList[index];
            return Column(
              children: [
                GestureDetector(
                  child: ListTile(
                  leading: Image.asset('assets/icons/icon_show_gb.png'),
                  title: Container(
                    transform: Matrix4.translationValues(-25, 0.0, 0.0),
                    child: Text(data.descript != null ? data.descript : '',style: TextStyle(fontSize: FontUtil.fs(FontSize.content),color: ColorsUtil.fromEnmu(ColorEnum.content))),
                    ),
                    trailing:  Icon(Icons.keyboard_arrow_right,color: ColorsUtil.fromEnmu(ColorEnum.mark))
                  ),
                  onTap:() {
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return ShowInfoSingleWidget(gambitId: data.id);
                    }));
                },),
                Divider(height: 0.5,
                  color: ColorsUtil.fromEnmu(ColorEnum.tableBack),
                  indent: 15,
                )
              ],
            );
          }
        ),
        onRefresh: () async {
          // 开始刷新
          await GambitListNetWroking();
        },
      ),
    );
  }

  Future<Null> GambitListNetWroking() async {
    final url = NetWorkingConfig.path(NetPath.gambitlist);
    await NetWorking.post(url, (data) {
      print(data);
      if (data['code'] == 200) {
        List<GambitModel> datas = [];
        var models = data['data'];
        for (int i = 0;i < models.length; i++ ){
          datas.add(new GambitModel.fromJson(models[i]));
        }
        gambitList = datas;
        setState(() {
          isFirstLoad = false;
        });
      }else{
        isFirstLoad = false;
      }
    }, (error) {

    });
  }
}