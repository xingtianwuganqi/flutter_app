import 'package:flutter/material.dart';
import 'package:flutter_720yun/routers/router_banner.dart';
import 'package:flutter_720yun/routers/router_interstitial.dart';
import 'package:flutter_720yun/routers/router_native.dart';
import 'package:flutter_720yun/routers/router_reward.dart';

class AdTestPage extends StatelessWidget {
const AdTestPage({Key key}) : super(key: key);

@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: Colors.black,
body: Center(
child: Container(
alignment: Alignment.bottomLeft,
height: 500.0,
// width: 500,
child: Column(
crossAxisAlignment: CrossAxisAlignment.center,
mainAxisAlignment: MainAxisAlignment.spaceAround,
children: [
Text(
'AnyThink SDK Demo',
style: TextStyle(fontSize: 30.0, color: Colors.white),
),
Row(
mainAxisAlignment: MainAxisAlignment.spaceEvenly,
children: [
Expanded(
flex: 1,
child: Container(
margin: EdgeInsets.only(right: 10, left: 10),

// width: 200.0,
height: 100.0,
decoration: BoxDecoration(),
// color: Colors.white,
child: ElevatedButton(
style: ElevatedButton.styleFrom(primary: Colors.white),
onPressed: () {
// Navigator.pushNamed(context, "/rewardRouter");
Navigator.push(context, MaterialPageRoute(builder: (context){
return RewardRouter();
}));
},
child: Text("RewardVideo",
style: TextStyle(
color: Colors.black,
fontSize: 20.0,
)),
),
),
),
Expanded(
flex: 1,
child: Container(
margin: EdgeInsets.only(right: 10, left: 10),
// width: 200.0,
height: 100.0,
decoration: BoxDecoration(),
// color: Colors.white,
child: ElevatedButton(
style:
ElevatedButton.styleFrom(primary: Colors.white),
onPressed: () {
// Navigator.pushNamed(context, "/interstitialRouter");
Navigator.push(context, MaterialPageRoute(builder: (context){
return InterstitialRouter();
}));
},
child: Text("Interstitial",
style: TextStyle(
color: Colors.black,
fontSize: 20.0,
)),
),
))
],
),
Row(
mainAxisAlignment: MainAxisAlignment.spaceEvenly,
children: [
Expanded(
flex: 1,
child: Container(
margin: EdgeInsets.only(right: 10, left: 10),

// width: 200.0,
height: 100.0,
decoration: BoxDecoration(),
// color: Colors.white,
child: ElevatedButton(
style:
ElevatedButton.styleFrom(primary: Colors.white),
onPressed: () {
// Navigator.pushNamed(context, "/bannerRouter");
Navigator.push(context, MaterialPageRoute(builder: (context){
return BannerRouter();
}));
},
child: Text("Banner",
style: TextStyle(
color: Colors.black,
fontSize: 20.0,
)),
),
)),
Expanded(
flex: 1,
child: Container(
margin: EdgeInsets.only(right: 10, left: 10),

// width: 200.0,
height: 100.0,
decoration: BoxDecoration(),
// color: Colors.white,
child: ElevatedButton(
style:
ElevatedButton.styleFrom(primary: Colors.white),
onPressed: () {
// Navigator.pushNamed(context, "/nativeRouter");
Navigator.push(context, MaterialPageRoute(builder: (context){
return NativeRouter();
}));
},
child: Text("Native",
style: TextStyle(
color: Colors.black,
fontSize: 20.0,
)),
),
))
],
)
],
),
)));
}
}