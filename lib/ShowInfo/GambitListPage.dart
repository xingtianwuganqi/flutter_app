import 'package:flutter/material.dart';
import 'package:flutter_720yun/ShowInfo/Models.dart';
import '../NetWorking/NetWorking.dart';

class GambitListWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return GambitListState();
  }
}

class GambitListState extends State<GambitListWidget> {

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
      body: RefreshIndicator(
        onRefresh: () async {
          // 开始刷新
          GambitListNetWroking();
        },
        child: ListView.builder(
          itemCount: gambitList.length,
          itemExtent: 50,
          itemBuilder: (context, index) {
            var data = gambitList[index];
            return ListTile(
              leading: Image.asset('assets/icons/icon_show_gb.png'),
              title: Container(
                transform: Matrix4.translationValues(-25, 0.0, 0.0),
                child: Text(data.descript,style: TextStyle(fontSize: 14,color: Colors.black)),
              ),
              // Text(data.descript,style: TextStyle(fontSize: 14,color: Colors.black)),
                //
              trailing:  Icon(Icons.keyboard_arrow_right),
            );
          }
        ),
      )
    );
  }

  Future<Null> GambitListNetWroking() async {
    final url = 'https://test.rxswift.cn/api/v1/gambitlist/';
    var data = await NetWorking.post(url);
    print(data);
    if (data['code'] == 200) {
      List<GambitModel> datas = [];
      var models = data['data'];
      for (int i = 0;i < models.length; i++ ){
        datas.add(new GambitModel.fromJson(models[i]));
      }
      gambitList = datas;
      setState(() {

      });
    }else{

    }
  }
}