import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_720yun/Common/CommonPage.dart';
import 'package:flutter_720yun/NetWorking/NetWorking.dart';
import 'package:flutter_720yun/ShowInfo/ShowInfoListPage.dart';
import 'package:flutter_720yun/ShowInfo/ShowInfoSinglePage.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_printer/flutter_printer.dart';
import '../model/MessageModel.dart';
import '../homepage/TopicDetail.dart';
class MessageListWidget extends StatefulWidget {

  String title;
  int msgType;
  ValueChanged changed;

  MessageListWidget(
      this.title,
      this.msgType,
      this.changed,
      );

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MessageListState();
  }
}



class MessageListState extends State<MessageListWidget> {

  bool isFirstLoad = true;
  List<MessageListModel> msgList = [];
  int page = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    widget.changed(1);
  }

  Widget userInfoWidget(MessageListModel data) {
    return /// 个人信息
      Container(
        padding: EdgeInsets.only(top: 10,left: 15,right: 15,bottom: 10),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: ToolConfig.loadImage(data.from_info?.avator ?? ''),
              child: Container(
                alignment: Alignment(0, .5),
                width: 40,
                height: 40,
              ),
            ),
            Container(
                padding: EdgeInsets.only(left: 10,right: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data.from_info != null ? data.from_info?.username ?? "" : "",
                      style: TextStyle(
                        color: ColorsUtil.fromEnmu(ColorEnum.title),
                        fontSize: FontUtil.fs(FontSize.content),
                        fontWeight: FontWeight.w600
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Padding(padding: EdgeInsets.all(3)),
                    Text( ToolConfig.timeT(data.create_time ?? ''),
                        style: TextStyle(
                            color: ColorsUtil.fromEnmu(ColorEnum.desc),
                            fontSize: FontUtil.fs(FontSize.time)),
                        overflow: TextOverflow.ellipsis)
                  ],
                )),
          ],
        ),
      );
  }
  
  Widget contentWidget(MessageListModel data) {
    /*
    if msg_type == 1 || msg_type == 5 {
                self.descLab.text = "赞了这条帖子"
            }else if msg_type == 2 || msg_type == 6 {
                self.descLab.text = "收藏了这条帖子"
            }else if msg_type == 3 || msg_type == 4 || msg_type == 7 || msg_type == 8 {
                guard let model = reactor.currentState.model else {
                    return
                }
                if model.reply_type == 1 {
                    self.descLab.attributedText = Tool.shared.getContentAttribute(text: "评论说：" + (model.commentInfo?.content ?? ""), fontSize: 14, textColor: UIColor.color(.content)!)

                }else{
                    self.descLab.text = "回复说：" + (model.replyInfo?.content ?? "")
                }
            }
     */
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.only(left: 15,right:15,bottom: 10,top: 5),
      child: contentText(data),
    );
  }

  Widget contentText(MessageListModel data) {
    if (data.msg_type == 1 || data.msg_type == 5 || data.msg_type == 10) {
      return Text('赞了这条帖子',
        textAlign: TextAlign.left,
        style:  TextStyle(
            fontSize: FontUtil.fs(FontSize.content),
            color: ColorsUtil.fromEnmu(ColorEnum.content)
        ),
      );
    }else if (data.msg_type == 2 || data.msg_type  == 6 || data.msg_type == 11) {
      return Text('收藏了这条帖子',
        textAlign: TextAlign.left,
        style: TextStyle(
            fontSize: FontUtil.fs(FontSize.content),
            color: ColorsUtil.fromEnmu(ColorEnum.content)
        ),
      );
    }else if (data.msg_type == 3 || data.msg_type == 4 || data.msg_type == 7 || data.msg_type == 8 || data.msg_type == 12 || data.msg_type == 13) {
      if (data.reply_type == 1) {
        return Text('评论说：' + (data.commentInfo != null ? data.commentInfo?.content ?? "" : "")  ,
          textAlign: TextAlign.left,
          style: TextStyle(
              fontSize: FontUtil.fs(FontSize.content),
              color: ColorsUtil.fromEnmu(ColorEnum.content)
          ),
        );
      }else {
        return Text('回复说：' + (data.replyInfo != null ? data.replyInfo?.content ?? "" : ""),
          textAlign: TextAlign.left,
          style: TextStyle(
              fontSize: FontUtil.fs(FontSize.content),
              color: ColorsUtil.fromEnmu(ColorEnum.content)
          ),
        );
      }
    }else{
      return Text('');
    }
  }

  Widget infoWidget(MessageListModel data) {
    if (data.topicInfo != null) {
      /// 标签
      List<Widget> tags = [];

      if (data.topicInfo?.tagInfos != null ) {
        if ((data.topicInfo?.tagInfos?.length ?? 0) > 0) {
          tags = data.topicInfo!.tagInfos!.map((e) => Container(
            decoration: BoxDecoration(
                color: ColorsUtil.fromEnmu(ColorEnum.system),
                borderRadius: BorderRadius.all(Radius.circular(3.0))
            ),
            padding: EdgeInsets.only(left: 5,right: 5,top: 2,bottom: 2),
            child: Text(e.tag_name ?? "",
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          )).toList();
        }
      }
      return Container(
        margin: EdgeInsets.only(left: 15,right: 15),
        height: 80,
        color: ColorsUtil.fromEnmu(ColorEnum.defIcon),
        child: Row(
          children: [
            Container(
              color: Colors.white,
              margin: EdgeInsets.only(left: 1,top: 1,bottom: 1),
              child: (data.topicInfo?.imgs != null) ?  CachedNetworkImage(imageUrl: ToolConfig.loadImgUrl((data.topicInfo?.imgs?.first ?? '')) ,width: 78,height: 78,fit: BoxFit.cover,) : Image.asset('assets/icons/icon_plh.png',fit: BoxFit.cover,width: 78,height: 78),
            ),
            Expanded(
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 10,top: 3),
                      height: tags.length > 0 ? null : 3 ,
                      child:  Column(
                        children: [
                          Wrap(
                            spacing: 10,
                            children:tags,
                          )
                        ],
                      ),
                    ),
                    Expanded(
                        child: Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.only(top: 6,bottom: 5,left: 10,right: 10),
                          child: Text(data.topicInfo != null ? data.topicInfo?.content ?? '' : '',
                            style: TextStyle(
                              fontSize: FontUtil.fs(FontSize.desc),
                              color: ColorsUtil.fromEnmu(ColorEnum.desc)
                            ),
                            maxLines: tags.length > 0 ? 2 : 3,
                           overflow: TextOverflow.ellipsis,
                          ),
                        )
                    )
                  ],
                )
            )
          ],
        ),
      );
    }else if (data.showInfo != null){
      return Container(
        margin: EdgeInsets.only(left: 15,right: 15),
        height: 80,
        color: ColorsUtil.fromEnmu(ColorEnum.defIcon),
        child: Row(
          children: [
            Container(
              color: Colors.white,
              margin: EdgeInsets.only(left: 1,top: 1,bottom: 1),
              child: (data.showInfo?.imgs != null) ? CachedNetworkImage(
                imageUrl: ToolConfig.loadImgUrl((data.showInfo?.imgs?.first ?? '')),
                width: 78,
                height: 78,
                fit: BoxFit.cover,) :  Image.asset('assets/icons/icon_plh.png',fit: BoxFit.cover,width: 78,height: 78),
            ),
            Expanded(
                child: Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(top: 10,bottom: 10,left: 10,right: 10),
                  child: Text((data.showInfo?.instruction != null) ? data.showInfo?.instruction ?? "" : '' ,
                    style: TextStyle(
                        fontSize: FontUtil.fs(FontSize.desc),
                        color: ColorsUtil.fromEnmu(ColorEnum.desc)
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
            )
          ],
        ),
      );
    }else if (data.findInfo != null){
      return Container(
        margin: EdgeInsets.only(left: 15,right: 15),
        height: 80,
        color: ColorsUtil.fromEnmu(ColorEnum.defIcon),
        child: Row(
          children: [
            Container(
              color: Colors.white,
              margin: EdgeInsets.only(left: 1,top: 1,bottom: 1),
              child: Image.asset('assets/icons/icon_plh.png',fit: BoxFit.cover,width: 78,height: 78),
            ),
            Expanded(
                child: Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(top: 10,bottom: 10,left: 10,right: 10),
                  child: Text((data.findInfo?.desc != null) ? data.findInfo?.desc ?? '' : '' ,
                    style: TextStyle(
                        fontSize: FontUtil.fs(FontSize.desc),
                        color: ColorsUtil.fromEnmu(ColorEnum.desc)
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
            )
          ],
        ),
      );
    }else{
      return Container();
    }
  }
  
  Widget bottomLineWidget() {
    return Container(
      child: Column(
        children: [
          Padding(padding: EdgeInsets.only(top: 10)),
          Divider(height: 0.5,color: ColorsUtil.fromEnmu(ColorEnum.defIcon),),
        ],
      ),
    );
  }
  
  
  Widget messageList(MessageListModel data) {
    return Container(
      child: Column(
        children: [
          userInfoWidget(data),
          contentWidget(data),
          infoWidget(data),
          bottomLineWidget(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        elevation: 0.5,
      ),
      body: EasyRefresh(
        header: MaterialHeader(),
        footer: MaterialFooter(
          enableInfiniteLoad: false,
        ),
        firstRefresh: isFirstLoad,
        firstRefreshWidget: FirstLoadWidget(),
        emptyWidget: msgList.length > 0 ? null : EmptyPage(() async{
          await messageListNetworking(1);
        }),
        child: ListView.builder(
          itemCount: msgList.length,
            itemBuilder: (context,index){
            var data = msgList[index];
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                child: messageList(data),
                onTap: () {
                  if (data.showInfo != null) {
                    /// 跳转到秀宠
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return ShowInfoSingleWidget(showId: data.showInfo?.show_id ?? 0);
                      }));
                  }else{
                    /// 跳转到领养
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return TopicDetailWidget(data.topicInfo?.topic_id ?? 0);
                    }));
                  }
                },
              );
            }),
        onRefresh: () async{
          await messageListNetworking(1);
        },
        onLoad: () async {
          await messageListNetworking(page);
        },
      ),
    );
  }
  /*
  dic["token"] = UserManager.shared.token
            dic["page"] = page
            dic["size"] = size
            dic["msg_type"] = msgType
   */
  Future<Null> messageListNetworking(num) async {
    page = num;
    final url = NetWorkingConfig.path(NetPath.authorMessage);
    final dic = {'page': page,'size': 10,'token': UserManager.instance.token,'msg_type': widget.msgType};
    await NetWorking.formDataPost(url, dic, (data) {
      if (data['code'] == 200) {
        var models = data['data'];
        List<MessageListModel> items = [];
        for (int i = 0;i < models.length;i ++) {
          var item = MessageListModel.fromJson(models[i]);
          items.add(item);
        }
        page > 1 ? msgList += items : msgList = items;
        if (items.length > 0) {
          page += 1;
        }
      }else{

      }
      setState(() {
        isFirstLoad=false;
      });
    }, (error) {
      setState(() {
        isFirstLoad=false;
      });
    });
  }
}