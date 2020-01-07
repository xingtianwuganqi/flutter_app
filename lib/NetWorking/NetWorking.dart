
import 'package:dio/dio.dart';
import 'dart:async';

Dio dio = new Dio();

class NetWorking {

  static Future get(String url,{Map<String,dynamic> params}) async{
    try {
      Options options = Options();
      options.headers =  {
        "App-Key": "aUWCj8QTNX2REohWFEawgioK6LBwm72W",
        "Referer": "https://720yun.com",
        "Origin":"https://720yun.com"
      };
      var response = await dio.get(url,queryParameters: params,options: options);
      return response.data;
    }catch (e){
      return  e;
    }
  }

  static Future post(String url, {Map<String,dynamic> params}) async {
    try {
      var response = await dio.post(url,queryParameters: params);
      return response.data;
    }catch(e) {
      return e;
    }
  }
}
