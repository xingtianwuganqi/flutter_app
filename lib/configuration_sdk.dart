import 'package:platform_info/platform_info.dart';

class Configuration {
  static String appidStr = Platform.I.buildMode == BuildMode.debug ? 'a62b013be01931' : 'a641a7925cd0e3';

  static String appidkeyStr = Platform.I.buildMode == BuildMode.debug
      ? 'c3d0d2a9a9d451b07e62b509659f7c97'
      : '34957f626411ed7ac73916e8b4031128';

  static String rewarderPlacementID = Platform.I.buildMode == BuildMode.debug ? 'b62b03c000844f' : 'b6427e89198d2a';
  static String interstitialPlacementID = Platform.I.buildMode == BuildMode.debug ? 'b62b0397ba87a8' : 'b6427ea8e97ae1';
  static String bannerPlacementID = Platform.I.buildMode == BuildMode.debug ? 'b62b03bacdcf28' : 'b641a834fd5243';
  static String nativePlacementID = Platform.I.buildMode == BuildMode.debug ? 'b62ea2e2ae729e' : 'b6427ea4423ea0';


  static String rewarderSceneID = Platform.I.buildMode == BuildMode.debug ? '' : '';

  static String nativeSceneID = Platform.I.buildMode == BuildMode.debug ? '' : '';

  static String interstitialSceneID = Platform.I.buildMode == BuildMode.debug ? '' : '';

  static String bannerSceneID = Platform.I.buildMode == BuildMode.debug ? '' : '';
}
