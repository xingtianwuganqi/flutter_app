import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_720yun/Common/CommonPage.dart';
import 'package:flutter_720yun/model/UserModel.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../NetWorking/NetWorking.dart';

class ViolationsListWidget extends StatefulWidget {

  Report_type reportType;
  int reportId;
  ViolationsListWidget({Key key,@required this.reportType,@required this.reportId}): super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ViolationListState();
  }
}

class ViolationListState extends State<ViolationsListWidget> {

  List<ViolationModel> dataSource = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listNetworking();
  }

  Widget violationCell(int index,ViolationModel data) {
    return GestureDetector(
      child: Container(
        alignment: Alignment.center,
        child: Row(
          children: [
            Icon(data.selected ? Icons.lens : Icons.lens_outlined,size: 20,color: ColorsUtil.fromEnmu(ColorEnum.system),),
            Padding(padding: EdgeInsets.only(left: 10)),
            Text(data.vio_name ?? '',style: TextStyle(fontSize: FontUtil.fs(FontSize.content),color: ColorsUtil.fromEnmu(ColorEnum.content)),),
          ],
        ),
      ),
      onTap: () {
        reloadList(index);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('投诉举报'),
        elevation: 0.5,
      ),
      body: Container(
        padding: EdgeInsets.only(left: 15,right: 15),
        child: CustomScrollView(

          slivers: [
            // 如果不是Sliver家族的Widget，需要使用SliverToBoxAdapter做层包裹
            SliverToBoxAdapter(
              child: Container(
                alignment: Alignment.centerLeft,
                height: 30,
                child: Text('请选择对应理由，理由与内容不符，会延迟处理',style: TextStyle(fontSize: FontUtil.fs(FontSize.desc),color: ColorsUtil.fromEnmu(ColorEnum.mark)),),
              ),
            ),
            SliverGrid(
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        var data = dataSource[index];
                    return violationCell(index,data);
                  },
                  childCount: dataSource.length,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
                  childAspectRatio: 3.5,
                )
            ),
            SliverToBoxAdapter(
              child: Container(
                alignment: Alignment.center,
                height: 70,
                child: Column(
                  children: [
                    Container(
                      color: ColorsUtil.fromEnmu(ColorEnum.system),
                      height: 40,
                      width: MediaQuery.of(context).size.width - 30,
                      child: TextButton(
                        child: Text('提交',
                          style: TextStyle(fontSize: FontUtil.fs(FontSize.content),
                              color: Colors.white),
                        ),
                        onPressed: () {
                          pushClick();
                        },
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "了解",
                            style: TextStyle(fontSize: FontUtil.fs(FontSize.desc), color: ColorsUtil.fromEnmu(ColorEnum.mark)),
                          ),
                          TextSpan(
                            text: "用户协议",
                            style: TextStyle(fontSize: FontUtil.fs(FontSize.desc), color: ColorsUtil.fromEnmu(ColorEnum.system)),
                            // 设置点击事件
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {

                              },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
  /// 网络请求
  Future<Null> listNetworking() async {
    final url = NetWorkingConfig.path(NetPath.violations);
    await NetWorking.post(url, (data) {
      if (data['code'] == 200) {
        var models = data['data'];
        for(int i = 0; i < models.length; i ++) {
          var model = models[i];
          dataSource.add(ViolationModel.fromJson(model));
        }
        setState(() {

        });
      }
    }, (error) {

    });
  }
  /// 刷新列表
  Void reloadList(int index) {

    for (int i = 0; i < dataSource.length; i ++) {
      var model = dataSource[i];
      if (i == index) {
        if (model.selected == true) {
          model.selected = false;
        }else{
          model.selected = true;
        }
      }else{
        model.selected = false;
      }
      dataSource[i] = model;
      setState(() {

      });
    }
  }

  ///提交按钮
  Future<Null> pushClick() async{
    var reType = 1;
    switch (widget.reportType) {
      case Report_type.rescue_page:
        reType = 1;
        break;
      case Report_type.rescue_comment:
        reType = 2;
        break;
      case Report_type.rescue_reply:
        reType = 3;
        break;
      case Report_type.show_page:
        reType = 4;
        break;
      case Report_type.show_comment:
        reType = 5;
        break;
      case Report_type.show_reply:
        reType = 6;
        break;
      default:
        break;
    }

    int violation_id;
    for (int i = 0; i < dataSource.length; i ++) {
      var model = dataSource[i];
      if (model.selected) {
        violation_id = model.id;
        break;
      }
    }

    if (violation_id == null) {
      EasyLoading.showToast('请选择要举报的类型');
      return null;
    }

    final url = NetWorkingConfig.path(NetPath.report);
    final dic = {"report_type": reType,
      "report_id": widget.reportId ,
      "user_id": UserManager.instance.userInfo.id,
      "violation_id": violation_id,
      "token": UserManager.instance.token
    };

    FormData formData = FormData.fromMap(dic);
    await NetWorking.formDataPost(url, formData, (data) {
      if (data['code'] == 200) {
        EasyLoading.showToast('提交成功');
        Future.delayed(Duration(seconds: 2),() {
          Navigator.pop(context);
        });
      }else{
        EasyLoading.showToast('提交失败');
      }
    }, (error) {
      EasyLoading.showToast('提交失败');
      print(error);
    });
  }
}