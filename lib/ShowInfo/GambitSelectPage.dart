import 'package:flutter/material.dart';
import 'package:flutter_720yun/model/ShowModel.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../NetWorking/NetWorking.dart';
import '../Common/CommonPage.dart';

class GambitSelectPage extends StatefulWidget {

  final ValueChanged changed;
  final GambitModel defGambit;
  GambitSelectPage({Key key,this.defGambit,@required this.changed}): super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return GambitSelectState();
  }
}

class GambitSelectState extends State<GambitSelectPage> {

  //导航栏切换时保持原有状态
  // @override
  // bool get wantKeepAlive => true;

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
      appBar: AppBar(
        title: Text("添加话题"),
        elevation: 0.5,
      ),
      // backgroundColor: ColorsUtil.fromEnmu(ColorEnum.defIcon),
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
            // cacheExtent: 50,
            itemBuilder: (context, index) {
              var data = gambitList[index];
              return Column(
                children: [
                  GestureDetector(
                    child:ListTile(
                      leading: Image.asset('assets/icons/icon_show_gb.png'),
                      title: Container(
                        transform: Matrix4.translationValues(-25, 0.0, 0.0),
                        child: Text(data.descript != null ? data.descript : '',style: TextStyle(fontSize: FontUtil.fs(FontSize.content),color: ColorsUtil.fromEnmu(ColorEnum.content))),
                      ),
                      trailing:  Icon(data.isSelect ? Icons.lens : Icons.lens_outlined,size: 20,color: ColorsUtil.fromEnmu(ColorEnum.system),),
                    ),
                    onTap: () {
                      selectGambitAction(data);
                    },
                  ),
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

  void selectGambitAction(GambitModel model) {
    gambitList = gambitList.map((e) {
      var newModel = e;
      if (e.id == model.id) {
        newModel.isSelect = !newModel.isSelect;
        return newModel;
      }else{
        newModel.isSelect = false;
        return newModel;
      }
    }).toList();
    if (model.isSelect) {
      widget.changed(model);
    }else{
      widget.changed(null);
    }
    setState(() {

    });
  }

  Future<Null> GambitListNetWroking() async {
    final url = NetWorkingConfig.path(NetPath.gambitlist);
    await NetWorking.post(url, (data) {
      print(data);
      if (data['code'] == 200) {
        List<GambitModel> datas = [];
        var models = data['data'];
        for (int i = 0;i < models.length; i++ ){
          var model = new GambitModel.fromJson(models[i]);
          if (model.id == widget.defGambit.id) {
            model.isSelect = true;
          }else{
            model.isSelect = false;
          }
          datas.add(model);
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