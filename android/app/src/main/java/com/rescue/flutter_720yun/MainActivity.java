package com.rescue.flutter_720yun;

//import android.os.Bundle;
//import io.flutter.app.FlutterActivity;
//import io.flutter.plugins.GeneratedPluginRegistrant;
//
//public class MainActivity extends FlutterActivity {
//  @Override
//  protected void onCreate(Bundle savedInstanceState) {
//    super.onCreate(savedInstanceState);
//    GeneratedPluginRegistrant.registerWith(this);
//  }
//}

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

  @Override
  public void configureFlutterEngine(FlutterEngine flutterEngine){
    GeneratedPluginRegistrant.registerWith(flutterEngine);
  }
}