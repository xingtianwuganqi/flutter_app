import 'package:platform_info/platform_info.dart';

class Configuration {
  static String appidStr = Platform.I.buildMode == BuildMode.debug ? 'a5aa1f9deda26d' : 'a641a7925cd0e3';

  static String appidkeyStr = Platform.I.buildMode == BuildMode.debug
      ? '4f7b9ac17decb9babec83aac078742c7'
      : '34957f626411ed7ac73916e8b4031128';

  static String rewarderPlacementID = Platform.I.buildMode == BuildMode.debug ? 'b5b449fb3d89d7' : 'b5b449fb3d89d7';
  static String interstitialPlacementID = Platform.I.buildMode == BuildMode.debug ? 'b5baca53984692' : 'b5baca53984692';
  static String bannerPlacementID = Platform.I.buildMode == BuildMode.debug ? 'b5baca4f74c3d8' : 'b641a834fd5243';
  static String nativePlacementID = Platform.I.buildMode == BuildMode.debug ? 'b5aa1fa2cae775' : 'b5aa1fa2cae775';


  static String rewarderSceneID = Platform.I.buildMode == BuildMode.debug ? '' : '';

  static String nativeSceneID = Platform.I.buildMode == BuildMode.debug ? '' : '';

  static String interstitialSceneID = Platform.I.buildMode == BuildMode.debug ? '' : '';

  static String bannerSceneID = Platform.I.buildMode == BuildMode.debug ? '' : '';
}
