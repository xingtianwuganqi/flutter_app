import 'package:flutter/material.dart';
import 'package:flutter_720yun/Common/CommonPage.dart';
import 'package:flutter_720yun/NetWorking/NetWorking.dart';
import 'package:flutter_720yun/model/HomePageModel.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class TagInfoPage extends StatefulWidget {
  ValueChanged<List<TagInfoModel>> changed;
  List<TagInfoModel> tags;

  TagInfoPage(this.tags, this.changed);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return TagInfoState();
  }
}

class TagInfoState extends State<TagInfoPage> {

  List<TagInfoModel> dataSource = [];
  List<TagInfoModel> _filters = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    tagsInfoNetworking();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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
                  label: Text(data.tag_name ?? "",
                    style: TextStyle(color: (data.isSelect ?? false) ? Colors.white : ColorsUtil.fromEnmu(ColorEnum.mark)),),
                  backgroundColor: (data.isSelect ?? false) ? ColorsUtil.fromEnmu(ColorEnum.system) : ColorsUtil.fromEnmu(ColorEnum.tableBack),
                  onPressed: (){
                    if (!(data.isSelect ?? false)) {
                      if (judgeDataCanAppend(data) == true) {
                        data.isSelect = true;
                        _filters.add(data);
                      }else{
                        return;
                      }
                    }else{
                      data.isSelect = false;
                      _filters.removeWhere((element) {
                        return element.id == data.id;
                      });
                    }
                    dataSource[index] = data;
                    setState(() {
                      var selectItems = dataSource.where((element) => element.isSelect == true).toList();
                      widget.changed(selectItems);
                    });
                  },
                );
              }).toList(),
            ),
            // Text('选中：${_filters.join(',')}'),
          ],
        )
      )
    );
  }

  bool judgeDataCanAppend(TagInfoModel data) {
    if (data.tag_type == 0) {
      return true;
    }
    var otherModel = _filters.where((element) => element.tag_type != 0).toList();
    if (otherModel != null && otherModel.length > 0) {
      var tag = otherModel.first;
      if (tag.id == data.id) {
        return true;
      }else{
        return false;
      }
    }else{
      return true;
    }
  }

  Future<Null> tagsInfoNetworking() async {
    EasyLoading.show();
    final url = NetWorkingConfig.path(NetPath.tagsInfo);
    await NetWorking.post(url,Map(), (data) {
      EasyLoading.dismiss();
      print(data);
      if (data['code'] == 200) {
        dataSource = (data['data'] as List).map((e) => TagInfoModel.fromJson(e)).toList();
        for (int i = 0; i < dataSource.length;i++) {
          var value = dataSource[i];
          for (int j = 0;j < widget.tags.length;j++) {
            if (value.id == widget.tags[j].id) {
              value.isSelect = true;
            }
          }
          dataSource[i] = value;
        }
        _filters = widget.tags;
        setState(() {

        });
      }
    }, (error) {
      EasyLoading.dismiss();
    });
  }
}