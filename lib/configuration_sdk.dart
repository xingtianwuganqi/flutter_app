import 'dart:io';

class Configuration {
  static String appidStr = Platform.isIOS ? 'a5b0e8491845b3' : 'a641a7925cd0e3';

  static String appidkeyStr = Platform.isIOS
      ? '7eae0567827cfe2b22874061763f30c9'
      : '34957f626411ed7ac73916e8b4031128';

  static String rewarderPlacementID = Platform.isIOS ? 'b5b72b21184aa8' : 'b5b449fb3d89d7';
  static String interstitialPlacementID = Platform.isIOS ? 'b5bacad26a752a' : 'b5baca53984692';
  static String bannerPlacementID = Platform.isIOS ? 'b5bacaccb61c29' : 'b641a834fd5243';
  static String nativePlacementID = Platform.isIOS ? 'b5b0f5663c6e4a' : 'b5aa1fa2cae775';


  static String rewarderSceneID = Platform.isIOS ? 'f5e54970dc84e6' : '';

  static String nativeSceneID = Platform.isIOS ? 'f600938967feb5' : '';

  static String interstitialSceneID = Platform.isIOS ? 'f5e549727efc49' : '';

  static String bannerSceneID = Platform.isIOS ? 'f600938d045dd3' : '';
}
