import 'package:flutter/material.dart';
import 'package:flutter_720yun/NetWorking/NetWorking.dart';
import 'package:flutter_720yun/model/HomePageModel.dart';

class TagInfoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return TagInfoState();
  }
}

class TagInfoState extends State<TagInfoPage> {

  List<TagInfoModel> dataSource = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tagsInfoNetworking();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('标签'),
        elevation: 0.5,
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          children: <Widget>[
            Wrap(
              spacing: 15,
              children: List.generate(dataSource.length, (index) {
                var data = dataSource[index];
                return RawChip(
                  label: Text(data.tag_name),
                  onPressed: (){
                    // 点击

                  },
                );
              }).toList(),
            ),
            // Text('选中：${_filters.join(',')}'),
          ],
        ),
      )
    );
  }

  Future<Null> tagsInfoNetworking() async {
    final url = NetWorkingConfig.path(NetPath.tagsInfo);
    await NetWorking.post(url, (data) {
      print(data);
      if (data['code'] == 200) {
        dataSource = (data['data'] as List).map((e) => TagInfoModel.fromJson(e)).toList();
        setState(() {

        });
      }
    }, (error) {

    });
  }
}