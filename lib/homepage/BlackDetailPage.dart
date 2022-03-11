import 'package:flutter/material.dart';
import 'package:flutter_720yun/Common/CommonPage.dart';
import 'package:flutter_720yun/NetWorking/NetWorking.dart';
import 'package:flutter_720yun/model/BlackPageModel.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

enum BlackType {
  detail,
  create
}

class BlackDetailPage extends StatefulWidget {
  BlackType blackType;
  final int blackId;
  BlackDetailPage({Key key,
  this.blackType,this.blackId
  }):super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return BlackDetailState();
  }
}

class BlackDetailState extends State<BlackDetailPage> {
  //焦点
  FocusNode _focusNodeUserName = new FocusNode();
  FocusNode _focusNodePassWord = new FocusNode();

  //用户名输入框控制器，此控制器可以监听用户名输入框操作
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _wxNumController = new TextEditingController();
  TextEditingController _nickNameController = new TextEditingController();
  TextEditingController _reasonController = new TextEditingController();
  // TextEditingController _wxNumController = new TextEditingController();
  // 领养人还是送养人
  bool isSwitch = false;

  //表单状态
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var _password = '';//用户名
  var _username = '';//密码
  var _isShowPwd = false;//是否显示密码
  var _isShowClear = false;//是否显示输入框尾部的清除按钮
  var _proSelect = true;
  var _deviceName = '';

  BlackListModel blackModel;
  List<BlackInfoModel> blackList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    blackDetailNetworking();

    _phoneController.addListener(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('举报'),
        elevation: 0.5,
        actions: [
          TextButton(
              onPressed: (){
                pushButtonClick();
              }, child: Text('举报',
            style: TextStyle(fontSize: FontUtil.fs(FontSize.content),
                color: ColorsUtil.fromEnmu(ColorEnum.system)),)
          )
        ],
      ),
      body: ListView.builder(
        itemCount: blackList.length,
        cacheExtent: 60,
        itemBuilder: (context,index) {
          var data = blackList[index];
          if (data.desc == "line") {
            return Divider(thickness: 10,height: 10,color: ColorsUtil.fromEnmu(ColorEnum.defIcon),);
          }else if (data.desc == "手机号" || data.desc == "微信号" || data.desc == "微信昵称") {
            TextEditingController currentController;
            if (data.desc == "手机号") {
              currentController = _phoneController;
            }else if ( data.desc == "微信号" ) {
              currentController = _wxNumController;
            }else if (data.desc == "微信昵称") {
              currentController = _nickNameController;
            }
            return Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 15,right: 15),
                  height: 50,
                  width: double.infinity,
                  child: Row(
                    children: [
                      Text(data.desc,style: TextStyle(
                          fontSize: FontUtil.fs(FontSize.content),
                          color: ColorsUtil.fromEnmu(ColorEnum.content)
                      ),),
                      Expanded(
                        child: TextField(
                          textAlign: TextAlign.right,
                          controller: currentController,
                          style: TextStyle(color: ColorsUtil.fromEnmu(ColorEnum.content),
                              fontSize: FontUtil.fs(FontSize.content)),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: data.placeholder,
                            hintStyle: TextStyle(color: ColorsUtil.fromEnmu(ColorEnum.mark),
                                fontSize: FontUtil.fs(FontSize.content)
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 0.5,
                  color: ColorsUtil.fromEnmu(ColorEnum.defIcon),
                )
              ],
            );
          }else if (data.desc == "身份") {
            return Container(
              padding: EdgeInsets.only(left: 15,right: 15),
              height: 50,
              child: Row(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(data.desc),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Text('领养人',style: TextStyle(color: ColorsUtil.fromEnmu(ColorEnum.note),
                            fontSize: FontUtil.fs(FontSize.content))),
                        Switch(
                          value: isSwitch,
                          activeColor: Colors.blue,
                          inactiveThumbColor: Colors.blue,
                          onChanged: (value) {
                            isSwitch = !isSwitch;
                            setState(() {

                            });
                          },
                        ),
                        Text("送养人",style: TextStyle(color: ColorsUtil.fromEnmu(ColorEnum.note),
                            fontSize: FontUtil.fs(FontSize.content)))
                      ],
                    ),
                  )
                ],
              ),
            );
          }else if (data.desc == "举报理由"){
            return Container(
              padding: EdgeInsets.only(left: 15,right: 15),
              height: 140,
              width: double.infinity,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 30,
                    child: Text(data.desc),
                  ),
                  Expanded(
                    child:
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      padding: EdgeInsets.only(top: 5,left: 5,right: 5,bottom: 5),
                        constraints: BoxConstraints(maxHeight: 100, minHeight: 100),
                        alignment: Alignment.topLeft,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8.0)),
                            border: Border.all(
                                width: 1,
                                color: ColorsUtil.fromEnmu(ColorEnum.tableBack)
                            )
                        ),
                        child: TextField(
                      controller: _reasonController,
                      maxLength: null,
                      decoration: InputDecoration.collapsed(
                        border: InputBorder.none,
                        hintText: "请输入举报理由",
                        hintStyle: TextStyle(color: ColorsUtil.fromEnmu(ColorEnum.mark),
                            fontSize: FontUtil.fs(FontSize.content)
                        )
                      ),
                        )
                    )
                  )
                ],
              ),
            );
          }else{
            return Container(
              padding: EdgeInsets.only(left: 15,right: 15),
              height: 140,
              width: double.infinity,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 30,
                    child: Text(data.desc),
                  ),
                  Expanded(
                      child:
                      Container(
                          
                      )
                  )
                ],
              ),
            );
          }
        }
        ),
    );
  }


  Future<Null> blackDetailNetworking() async {
    EasyLoading.show();
    final url = NetWorkingConfig.path(NetPath.blackDetail);
    var dic = new Map<String,dynamic>.from(paramDic);
    dic['blackId'] = widget.blackId;
    NetWorking.formDataPost(url, dic, (data) {
      EasyLoading.dismiss();
      if (data['code'] == 200) {
        var model = data['data'];
        var blackInfo = BlackListModel.fromJson(model);
        blackModel = blackInfo;
        loadBlackList(blackInfo);
      }
    }, (error) {
      EasyLoading.dismiss();
    });
  }

  void loadBlackList(BlackListModel model) {
    var contact = widget.blackType == BlackType.create ? null: model.contact;
    var wx_num = widget.blackType == BlackType.create ? null: model.wx_num;
    var nickName = widget.blackType == BlackType.create ? null: model.name;
    var body = widget.blackType == BlackType.create ? null: (model.black_type == 1 ? "领养人" : "送养人");
    var reason = widget.blackType == BlackType.create ? null: model.desc;
    var images = widget.blackType == BlackType.create ? null: model.images;

    var list =
     [
       BlackInfoModel(desc: "手机号",placeholder: "请输入失信人手机号",value: contact,type: widget.blackType),
       BlackInfoModel(desc: "微信号",placeholder: "请输入失信人微信号",value: wx_num,type: widget.blackType),
       BlackInfoModel(desc: "微信昵称",placeholder: "请输入失信人微信昵称",value: nickName,type: widget.blackType),
       BlackInfoModel(desc: "line",placeholder: "",value: null,type: widget.blackType),
       BlackInfoModel(desc: "身份",placeholder: "",value: body,type: widget.blackType),
       BlackInfoModel(desc: "line",placeholder: "",value: null,type: widget.blackType),
       BlackInfoModel(desc: "举报理由",placeholder: "请输入失信人手机号",value: reason,type: widget.blackType),
       BlackInfoModel(desc: "line",placeholder: "",value: null,type: widget.blackType),
       BlackInfoModel(desc: "举报证据",placeholder: "",value: images,type: widget.blackType)
    ];

    blackList = list;
    setState(() {

    });

  }

  // 举报按钮点击
  void pushButtonClick() {
    if (_phoneController.text.trim().length == 0) {
      EasyLoading.showToast("请输入失信人手机号");
      return;
    }


    if (_reasonController.text.trim().length == 0) {
      EasyLoading.showToast("请输入失信人微信号");
      return;
    }


  }
}