
import 'package:flutter/material.dart';
import 'package:flutter_720yun/Common/CommonPage.dart';
import 'package:flutter_720yun/NetWorking/NetWorking.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../model/FindPetListModel.dart';
import 'AddressSelectPage.dart';

class FindPetDetailPage extends StatefulWidget {
  /*
  1.发布成功，更新effective未失效，刷新列表
  2.删除数据
   */
  final ValueChanged changed;
  const FindPetDetailPage(this.changed);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return FindPetDetailState();
  }
}

class FindPetDetailState extends State<FindPetDetailPage> {

  // FindPetDetailModel detailModel;
  int petType = 1;
  FindPetDetailModel model = FindPetDetailModel(pet_type: 1);
  EditPageType pageType = EditPageType.create;
  final TextEditingController descController = TextEditingController();
  final TextEditingController contactController = TextEditingController();

  FocusNode _descFocus = FocusNode();
  FocusNode _contactFocus = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadFindPetInfoNetworking();

    descController.addListener(() {
      model.desc = descController.text.trim();
    });

    contactController.addListener(() {
      model.contact = contactController.text.trim();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    descController.dispose();
    contactController.dispose();
    _contactFocus.dispose();
    _descFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("找宠小助手"),
        elevation: 0.2,
        actions: [
          pageType == EditPageType.create ? Container() : IconButton(onPressed: () {
            resignFirstFocus();
            updateEffective(model);
          }, icon: Icon(Icons.more_horiz_rounded)),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          findPetHeader(model),
          petTypeWidget(model),
          descWidget(model),
          addressWidget(model),
          contactWidget(model),
          pushBtnWidget(model)
        ],
      ),
    );
  }

  // 更新有效无效
  void updateEffective(FindPetDetailModel model) {
    var desc = "";
    var action = '';
    if (model.effective == 0) {
      desc = "打开找宠信息后，您的找宠信息将在找宠列表显示。";
      action = "打开";
    }else{
      desc = '关闭找宠信息后，您的信息将在找宠列表隐藏。您可以再次编辑或打开找宠信息，使您的找宠信息在找宠列表中显示！';
      action = "关闭";
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      builder: (context){
        return Container(
          width: MediaQuery.of(context).size.width,
          height: 190,
          color: Colors.white,
          child: ListView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              Container(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Text(desc,
                    style: TextStyle(color: ColorsUtil.fromEnmu(ColorEnum.content),fontSize: FontUtil.fs(FontSize.content),
                    ),),
                ),
              ),
              Divider(height: 0.5,color: ColorsUtil.fromEnmu(ColorEnum.tableBack),),
              TextButton(onPressed: (){
                Navigator.pop(context);
                updateEffectiveNetworking(model.effective ?? 0);
              }, child: Text(action,style: TextStyle(fontSize: FontUtil.fs(FontSize.title)),)),
              Divider(height: 0.5,color: ColorsUtil.fromEnmu(ColorEnum.tableBack),),
              TextButton(onPressed: (){
                Navigator.pop(context);
              }, child: Text('取消',style: TextStyle(fontSize: FontUtil.fs(FontSize.title)),)),
            ],
          ),
        );
      },
    );
  }

  // MARK: 头部视图
  Widget findPetHeader(FindPetDetailModel model) {
    var header = Container(
      color: ColorsUtil.hexColor(0xF0EBDA),
      padding: EdgeInsets.only(left: 15,right: 15),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Image.asset('assets/icons/icon_cat_header.png',width: 50,height: 50,),
        ),
          Expanded(child:  
            Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 15,left: 15,right: 15,bottom: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    color: ColorsUtil.hexColor(0xCBCFB5),
                  ),
                  child: Container(
                    margin: EdgeInsets.only(top: 10,left: 10,right: 10,bottom: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      color: Colors.white,
                    ),
                    child: Padding(padding: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
                      child: Text('没有找到想要的宠物？\n可以提交相关信息给小助手\n有合适的宠物后会通知您~',
                        style: TextStyle(fontSize: FontUtil.fs(FontSize.content),
                            color: ColorsUtil.fromEnmu(ColorEnum.content),height: 1.3),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 1,
                    child: (model.effective == 0) ? Image.asset('assets/icons/icon_find_hadclose@3x.png',
                      width: 70,
                      height: 70,
                    ): Container(),
                )
              ],
            )
          )
        ],
      ),
    );

    return SliverToBoxAdapter(
      child: header,
    );
  }

  // 宠物类型
  Widget petTypeWidget(FindPetDetailModel model) {
    var petWidgt = Container(
      padding: EdgeInsets.only(left: 15,right: 15),
      color: Colors.white,
      height: 50,
      child: Column(
        children: [
          Row(
            children: [
              Text('种类：',style: TextStyle(color: ColorsUtil.fromEnmu(ColorEnum.title),
                  fontSize: FontUtil.fs(FontSize.content),
                  fontWeight: FontWeight.bold
              ),),
              Expanded(
                child: TextButton.icon(
                  // icon: Icon(Icons.access_alarm_outlined,size: 20,),
                  icon: petType == 1 ? Image.asset('assets/icons/icon_pet_select@3x.png',width: 20,height: 20,) : Image.asset('assets/icons/icon_pet_unselect@3x.png',width: 20,height: 20,),
                  label: Text('猫咪',style: TextStyle(fontSize: FontUtil.fs(FontSize.mark),
                    color: ColorsUtil.fromEnmu(ColorEnum.desc))),
                  onPressed: () {
                    changePetType(1);
                  },
                ),
              ),
              Expanded(
                  child: TextButton.icon(
                    icon: petType == 1 ? Image.asset('assets/icons/icon_pet_unselect@3x.png',width: 20,height: 20,) : Image.asset('assets/icons/icon_pet_select@3x.png',width: 20,height: 20,),
                    label: Text('狗狗',style: TextStyle(fontSize: FontUtil.fs(FontSize.mark),
                      color: ColorsUtil.fromEnmu(ColorEnum.desc)
                    ),),
                    onPressed: () {
                      changePetType(2);
                    },
                  )
              )
            ],
          ),
          Container(
            padding: EdgeInsets.only(left: 15,right: 15),
            height: 0.5,
            color: ColorsUtil.fromEnmu(ColorEnum.tableBack),
          )
        ],
      ),
    );

    return SliverToBoxAdapter(
      child: petWidgt,
    );
  }

  // 改变宠物类型
  void changePetType(int type) {
    petType = type;
    model.pet_type = petType;
    setState(() {

    });
  }

  // 宠物类型
  Widget descWidget(FindPetDetailModel model) {
    var descType = Container(
      // alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: 15,right: 15),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(padding: EdgeInsets.only(top: 10,bottom: 5),
            child: Text('描述',style: TextStyle(color: ColorsUtil.fromEnmu(ColorEnum.title),
              fontSize: FontUtil.fs(FontSize.content),
              fontWeight: FontWeight.bold
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              //设置四周圆角 角度
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
              //设置四周边框
              border: new Border.all(width: 1, color: ColorsUtil.fromEnmu(ColorEnum.tableBack)),
            ),
            height: 150,
            padding: EdgeInsets.all(10),
            child:
             // Expanded(child:
              TextField(
                decoration: InputDecoration.collapsed(
                  hintText: '请输入简短的描述',
                  hintStyle: TextStyle(color: ColorsUtil.fromEnmu(ColorEnum.desc)),
                  // border: InputBorder.none,
                ),
                controller: descController,
                maxLines: null,
                cursorColor: ColorsUtil.fromEnmu(ColorEnum.desc),
                focusNode: _descFocus,
                keyboardType: TextInputType.multiline,
              ),
            // ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5),
            padding: EdgeInsets.only(left: 15,right: 15),
            height: 0.5,
            color: ColorsUtil.fromEnmu(ColorEnum.tableBack),
          )
        ],
      ),
    );

    return SliverToBoxAdapter(
      child: descType,
    );
  }


  Widget addressWidget(FindPetDetailModel model) {
    var addressType = Container(
      // alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: 15,right: 15),
      color: Colors.white,
      height: 50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(padding: EdgeInsets.only(right: 10),
                child: Text('地址：',style: TextStyle(color: ColorsUtil.fromEnmu(ColorEnum.title),
                    fontSize: FontUtil.fs(FontSize.content),
                    fontWeight: FontWeight.bold
                ),
                ),
              ),
              Expanded(child:
                GestureDetector(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    height: 49,
                    child:
                    Text((model.address == null || model.address?.length == 0) ? '请选择地址' : model.address ?? "", style: TextStyle(color: ColorsUtil.fromEnmu(ColorEnum.desc),
                      fontSize: FontUtil.fs(FontSize.content),

                    )
                    ),
                  ),
                  onTap: () {
                    resignFirstFocus();
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context){
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.8,
                          color: Colors.white,
                          child: AddressSelectPage((address) {
                            model.address = address;
                            setState(() {

                            });
                          },),
                        );
                      },
                    );
                  },
                )
              )
            ],
          ),
          Container(
            padding: EdgeInsets.only(left: 15,right: 15),
            height: 0.5,
            color: ColorsUtil.fromEnmu(ColorEnum.tableBack),
          )
        ],
      ),
    );

    return SliverToBoxAdapter(
      child: addressType,
    );
  }

  /*

   */

  Widget contactWidget(FindPetDetailModel model) {
    var contactType = Container(
      padding: EdgeInsets.only(left: 15,right: 15),
      color: Colors.white,
      height: 50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(padding: EdgeInsets.only(right: 10),
                child: Text('联系方式：',style: TextStyle(color: ColorsUtil.fromEnmu(ColorEnum.title),
                    fontSize: FontUtil.fs(FontSize.content),
                    fontWeight: FontWeight.bold
                ),
                ),
              ),
              Expanded(child: Container(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: '请输入联系方式',
                    hintStyle: TextStyle(color: ColorsUtil.fromEnmu(ColorEnum.desc)),
                    border: InputBorder.none,
                  ),
                  controller: contactController,
                  focusNode: _contactFocus,
                ),
              ))
            ],
          ),
          Container(
            padding: EdgeInsets.only(left: 15,right: 15),
            height: 0.5,
            color: ColorsUtil.fromEnmu(ColorEnum.tableBack),
          )
        ],
      ),
    );

    return SliverToBoxAdapter(
      child: contactType,
    );
  }

  Widget pushBtnWidget(FindPetDetailModel model) {
    var desc = pageType == EditPageType.create ? "提交" : "修改并提交";
    var pushBtn = Container(
      padding: EdgeInsets.only(top: 15,left: 15,right: 15),
      color: Colors.white,
      height: 60,
      child: TextButton(
        child: Text(desc,style: TextStyle(fontSize: FontUtil.fs(FontSize.title,),
            color: Colors.white,fontWeight: FontWeight.bold
          ),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(ColorsUtil.fromEnmu(ColorEnum.system))
        ),
        onPressed: () {
          resignFirstFocus();
          checkDataSources();
        },
      ),
    );

    return SliverToBoxAdapter(
      child: pushBtn,
    );
  }

  void showAlert() {
    var alert = AlertDialog(
      title: Text("特别提醒"),
      //title 的内边距，默认 left: 24.0,top: 24.0, right 24.0
      //默认底部边距 如果 content 不为null 则底部内边距为0
      //            如果 content 为 null 则底部内边距为20
      titlePadding: EdgeInsets.all(10),
      //标题文本样式
      titleTextStyle: TextStyle(color: Colors.black87, fontSize: 16),
      //中间显示的内容
      content: Text("请勿相信以任何名义(包括运费、押金、定金等)要求的提前转帐与打款的行为，不要提前转账或打款，若是红包领养，请当面给送养人。请提高警惕，以防被骗！",
        style: TextStyle(
          color: ColorsUtil.hexColor(0xF6831F),
          fontSize: FontUtil.fs(FontSize.content),
          height: 1.4
        ),
      ),
      //中间显示的内容边距
      //默认 EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0)
      contentPadding: EdgeInsets.all(10),
      //中间显示内容的文本样式
      contentTextStyle: TextStyle(color: Colors.black54, fontSize: 14),
      //底部按钮区域
      actions: <Widget>[
        TextButton(
          child: Text("取消",
            style: TextStyle(
              color: ColorsUtil.fromEnmu(ColorEnum.content),
              fontSize: FontUtil.fs(FontSize.content),
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        TextButton(
          child: Text("继续发布",
            style: TextStyle(
              color: ColorsUtil.fromEnmu(ColorEnum.content),
              fontSize: FontUtil.fs(FontSize.content),
            ),
          ),
          onPressed: () {
            //关闭 返回true
            Navigator.of(context).pop(true);
            pushActionNetworking();
          },
        ),
      ],
    );
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void checkDataSources() {
    if (model.desc == null || model.desc?.length == 0) {
      EasyLoading.showToast("请填写简单描述");
      return;
    }
    if (model.address == null || model.address?.length == 0) {
      EasyLoading.showToast("请选择地址");
      return;
    }
    if (model.contact == null || model.contact?.length == 0) {
      EasyLoading.showToast("请填写联系方式");
      return;
    }
    showAlert();
  }

  void resignFirstFocus() {
    _descFocus.unfocus();
    _contactFocus.unfocus();
  }

  Future<void> loadFindPetInfoNetworking() async {
    final url = NetWorkingConfig.path(NetPath.loadFintPetInfo);
    var dic = new Map<String, dynamic>.from(paramDic);
    dic["token"] = UserManager.instance.token;
    await NetWorking.formDataPost(url, dic, (data) {
      if (data['code'] == 200) {

        pageType = EditPageType.detail;
        model = FindPetDetailModel.fromJson(data['data']);
        // 赋初始值
        petType = model.pet_type ?? 0;
        descController.text = model.desc ?? '';
        contactController.text = model.contact ?? '';
      }else{
        pageType = EditPageType.create;
      }
      setState(() {

      });
    }, (error) {

    });
  }

  Future<void> updateEffectiveNetworking(int effective) async {
    final url = NetWorkingConfig.path(NetPath.changeFindPetEffective);
    var dic = new Map<String, dynamic>.from(paramDic);
    dic['token'] = UserManager.instance.token;
    dic['effective'] = effective == 1 ? 0 : 1;
    await NetWorking.formDataPost(url, dic, (data) {
      if (data['code'] == 200) {
          model.effective = effective == 1 ? 0 : 1;
          if (model.effective == 1) {
            widget.changed(1);
          }else{
            widget.changed(model);
          }
          setState(() {

          });
      }else{

      }
    }, (error) {

    });
  }

  Future<void> pushActionNetworking() async {

    final url = NetWorkingConfig.path(NetPath.createFindPet);
    var dic = new Map<String, dynamic>.from(paramDic);
    dic['token'] = UserManager.instance.token;
    dic['pet_type'] = petType;
    dic['address'] = model.address;
    dic['desc'] = model.desc;
    dic['contact'] = model.contact;
    EasyLoading.show(status: '正在发布...');
    await NetWorking.formDataPost(url, dic, (data) {
      EasyLoading.dismiss();
      EasyLoading.showToast("发布成功");
      if (data['code'] == 200) {
        widget.changed(1);
        Future.delayed(Duration(seconds: 1),(){
          Navigator.pop(context);
        });
      }
    }, (error) {

    });
    /*
    parameter["token"] = UserManager.shared.token
            parameter["pet_type"] = pet_type
            parameter["address"] = address
            parameter["desc"] = desc
            parameter["contact"] = contact
     */

  }
}

enum EditPageType {
  create,
  detail,
}