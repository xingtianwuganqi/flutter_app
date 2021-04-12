
import 'package:dio/dio.dart';
import 'dart:async';

Dio dio = new Dio();

class NetWorking {

  static Future get(String url,{Map<String,dynamic> params}) async{
    try {
      var response = await dio.get(url,queryParameters: params);
      return response.data;
    }catch (e){
      return  e;
    }
  }

  static Future post(String url, {Map<String,dynamic> params}) async {
    try {
      var response = await dio.post(url,data:params);
      return response.data;
    }catch(e) {
      return e;
    }
  }
}
