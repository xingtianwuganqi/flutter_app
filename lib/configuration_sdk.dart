import 'package:platform_info/platform_info.dart';

class Configuration {
  static String appidStr = Platform.I.buildMode == BuildMode.debug ? 'a62b013be01931' : 'a641a7925cd0e3';

  static String appidkeyStr = Platform.I.buildMode == BuildMode.debug
      ? 'c3d0d2a9a9d451b07e62b509659f7c97'
      : '34957f626411ed7ac73916e8b4031128';

  static String rewarderPlacementID = Platform.I.buildMode == BuildMode.debug ? 'b5b72b21184aa8' : 'b5b449fb3d89d7';
  static String interstitialPlacementID = Platform.I.buildMode == BuildMode.debug ? 'b5bacad26a752a' : 'b5baca53984692';
  static String bannerPlacementID = Platform.I.buildMode == BuildMode.debug ? 'b62b03bacdcf28' : 'b641a834fd5243';
  static String nativePlacementID = Platform.I.buildMode == BuildMode.debug ? 'b5b0f5663c6e4a' : 'b5aa1fa2cae775';


  static String rewarderSceneID = Platform.I.buildMode == BuildMode.debug ? 'f5e54970dc84e6' : '';

  static String nativeSceneID = Platform.I.buildMode == BuildMode.debug ? 'f600938967feb5' : '';

  static String interstitialSceneID = Platform.I.buildMode == BuildMode.debug ? 'f5e549727efc49' : '';

  static String bannerSceneID = Platform.I.buildMode == BuildMode.debug ? 'f600938d045dd3' : '';
}
