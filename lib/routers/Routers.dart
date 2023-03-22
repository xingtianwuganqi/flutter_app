

import 'package:flutter_720yun/main.dart';
import 'package:flutter_720yun/routers/router_banner.dart';
import 'package:flutter_720yun/routers/router_interstitial.dart';
import 'package:flutter_720yun/routers/router_native.dart';
import 'package:flutter_720yun/routers/router_reward.dart';

final anyThinkRouters = {
  // "/": (context) => MyHome(),
  "/rewardRouter": (context) => RewardRouter(),
  "/interstitialRouter": (context) => InterstitialRouter(),
  "/bannerRouter": (context) => BannerRouter(),
  "/nativeRouter": (context) => NativeRouter(),
};