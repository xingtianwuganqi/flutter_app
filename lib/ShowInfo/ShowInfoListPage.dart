import 'package:flutter/material.dart';

class ShowInfoListWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ShowInfoListState();
  }
}

class ShowInfoListState extends State<ShowInfoListWidget> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
    // 创建Controller
  }

  Widget showInfoItem() {
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 10,left: 15,right: 15,bottom: 0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 15,
                  backgroundImage: NetworkImage("https://tva1.sinaimg.cn/large/006y8mN6gy1g7aa03bmfpj3069069mx8.jpg"),
                  child: Container(
                    alignment: Alignment(0, .5),
                    width: 30,
                    height: 30,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 10),
                  child: Column(
                    children: [
                      Text('昵称',style: TextStyle(color: Colors.black,fontSize: 14),overflow: TextOverflow.ellipsis),
                      Text('时间',style: TextStyle(color: Colors.black12,fontSize: 12),overflow: TextOverflow.ellipsis)
                    ],
                  )),
                Expanded(
                    child: Container(

                    )),
                IconButton(icon: Icon(Icons.more_horiz_outlined), onPressed: (){}),
              ],
            ),
          ),
          Container(
            color: Colors.blue,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
            child: PageView(
              children: [
                Center(
                  child: Text('测试1'),
                ),
                Center(
                  child: Text('测试2'),
                ),
                Center(
                  child: Text('测试3'),
                )
              ],
            ),
          ),
          // instraction
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 15,top: 10,right: 10,bottom: 0),
            child: Text('文本的对齐方式；可以选择左对齐、右对齐还是居中。注意，对齐的参考系是Text widget本身。本例中虽然是指定了居中对齐，但因为Text文本内容宽度不足一行，Text的宽度和文本内容长度相等，那么这时指定对齐方式是没有意义的，只有Text宽度大于文本内容长度时指定此属性才有意义。下面我们指定一个较长的字符串',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 14,color: Colors.black),
            ),
          ),
          // 评论
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 15,top: 10,right: 15),
            child: Text('添加评论',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 14,color: Colors.black),
            ),
          ),
          // 点赞，收藏，评论
          commentWidget(),
          Divider(thickness: 10,color: Colors.grey[100],)
        ],
      ),
    );
  }

  Widget commentWidget() {
    return Container(
      height: 40,
      child: Row(
        children: [
          Expanded(
              child: TextButton.icon(
                icon:Icon(Icons.panorama),
                label: Text('点赞'),
                onPressed: (){},
              )
          ),
          Expanded(
              child: TextButton.icon(
                icon:Icon(Icons.panorama),
                label: Text('收藏'),
                onPressed: (){},
              )
          ),
          Expanded(
              child: TextButton.icon(
                icon:Icon(Icons.panorama),
                label: Text('评论'),
                onPressed: (){},
              )
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return showInfoItem();
          }
      ),
    );
  }
}