import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nearmy/model/Banner.dart';
import 'package:nearmy/model/Product.dart';
import 'package:nearmy/provider/model/Order.dart';
import 'package:nearmy/provider/model/Provider.dart';
import 'package:nearmy/provider/model/Wave.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import '../components/components.dart';

class ProviderAPICall{

  // ignore: missing_return
  static Future<List<Banners>> getBannersData() async {
    try{
      Dio dio = new Dio();
      List<Banners> data = [];
      var response = await dio.get("");
      if(response.statusCode == 200){
        if(jsonDecode(response.data) != "no data fround"){
          data = (jsonDecode(response.data) as List).map((e) => Banners.fromJson(e)).toList();
        }
      }
      return data;
    }
    on DioError catch (e){
      print(e.response);
    }
  }

  // ignore: missing_return
  static Future<int> loginProvider(Providers provider) async {
    try{

      FormData formdata = FormData.fromMap({
        'email' : provider.email,
        'password' : provider.password,
        'location' : provider.location
      });
      Dio dio = new Dio();
      var response = await dio.post(
        "",
        data: formdata,
      );
      if(response.statusCode == 200){
        return jsonDecode(response.data) as int;
      }
    }
    on DioError catch (e){
      print(e.response);
    }
  }

  // ignore: missing_return
  static Future<int> createProvider(Providers provider) async {
    try{
      FormData formdata = FormData.fromMap({
        "name": provider.name,
        "email": provider.email,
        "type": provider.category,
        "rate": provider.rate,
        "location": provider.location,
        "address": provider.address,
        "password": provider.password,
        "state": provider.state,
        "file": await MultipartFile.fromFile(
            provider.imageUrl,
            filename: basename(provider.imageUrl)
        ),
      });

      Dio dio = new Dio();
      var response = await dio.post("",data: formdata);

      if(response.statusCode == 200){
        return jsonDecode(response.data);
      }
    }
    on DioError catch (e){
      print(e.response);
    }
  }

  // ignore: missing_return
  static Future<List<Orders>> getOrdersData() async {
    try{

      int id = await CustomData.getProviderId();

      FormData formdata = FormData.fromMap({
        'providerId' : id
      });
      Dio dio = new Dio();
      var response = await dio.post(
        "",
        data: formdata,
      );
      List<Orders> data = [];
      if(response.statusCode == 200){
        if(jsonDecode(response.data) != "no data fround"){
          data = (jsonDecode(response.data) as List).map((e) => Orders.fromJson(e)).toList();
          if(data.length > CustomData.orderCount){
            CustomData.orderCount = data.length;
            print("" + CustomData.orderCount.toString());
            FlutterRingtonePlayer.playNotification();
            if (await Vibration.hasVibrator()) {
              Vibration.vibrate();
            }
          }
        }
      }
      return data;
    }
    on DioError catch (e){
      print(e.response);
    }
  }

  // ignore: missing_return
  static Future<List<Wave>> getProviderWaveData() async {
    try{
      int id = await CustomData.getProviderId();

      FormData formdata = FormData.fromMap({
        'providerId' : id
      });
      Dio dio = new Dio();
      List<Wave> data = [];
      var response = await dio.post(
        "",
        data: formdata,
      );
      if(response.statusCode == 200){
        if(jsonDecode(response.data) != "no data fround"){
          data = (jsonDecode(response.data) as List).map((e) => Wave.fromJson(e)).toList();
          if(data.length > CustomData.waveCount){
            CustomData.waveCount = data.length;
            print("" + CustomData.waveCount.toString());
            FlutterRingtonePlayer.playNotification();
            if (await Vibration.hasVibrator()) {
              Vibration.vibrate();
            }
          }
        }
      }
      return data;
    }
    on DioError catch (e){
      print(e.response);
    }
  }

  // ignore: missing_return
  static Future<bool> deleteProviderProfile() async {
    try{
      int id = await CustomData.getProviderId();
      FormData formdata = FormData.fromMap({
        'id' : id
      });
      Dio dio = new Dio();
      var response = await dio.post(
        "",
        data: formdata,
      );
      if(response.statusCode == 200){
        if(jsonDecode(response.data)){
          return true;
        }
        else{
          return false;
        }
      }
    }
    on DioError catch (e){
      print(e.response);
    }
  }

  // ignore: missing_return
  static Future<Providers> getProviderData() async {
    int id = await CustomData.getProviderId();
    try{
      FormData formdata = FormData.fromMap({
        'id' : id
      });
      print("provider ID " + id.toString());
      Dio dio = new Dio();
      Providers provider;
      var response = await dio.post(
        "",
        data: formdata,
      );
      if(response.statusCode == 200){
        if(jsonDecode(response.data) != "no data fround"){
          provider = new Providers.fromJsonProfile(jsonDecode(response.data));
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("CartProviderName",provider.name);
          return provider;
        }
      }
    }
    on DioError catch (e){
      print(e.response);
    }
  }

  // ignore: missing_return
  static Future<bool> setWaveComplete(int id) async {
    try{
      Dio dio = new Dio();
      FormData formdata = FormData.fromMap({
        'id' : id
      });
      var response = await dio.post(
        "",
        data: formdata,
      );
      if(response.statusCode == 200){
        CustomData.waveCount = CustomData.waveCount - 1;
        print("" + CustomData.waveCount.toString());
        return true;
      }
    }
    on DioError catch (e){
      print(e.response);
    }
  }

  // ignore: missing_return
  static Future<List<Product>> getOrderProducts(int id) async {
    try{

      FormData formdata = FormData.fromMap({
        'orderId' : id
      });
      Dio dio = new Dio();
      List<Product> data = [];
      var response = await dio.post(
        "",
        data: formdata,
      );
      if(response.statusCode == 200){
        if(jsonDecode(response.data) != "no data fround"){
          data = (jsonDecode(response.data) as List).map((e) => Product.fromJsonProvider(e)).toList();
        }
      }
      return data;
    }
    on DioError catch (e){
      print(e.response);
    }
  }

  // ignore: missing_return
  static Future<bool> updateProviderLocation(Position position) async {
    try{
      int id = await CustomData.getProviderId();
      if(id != null){
        String location = position.latitude.toString() + "," + position.longitude.toString();
        Dio dio = new Dio();
        FormData formdata = FormData.fromMap({
          'location' : location,
          'providerId' : id
        });
        var response = await dio.post(
          "",
          data: formdata,
        );
        if(response.statusCode == 200){
          return true;
        }
      }
    }
    on DioError catch (e){
      print(e.response);
    }
  }

  // ignore: missing_return
  static Future<bool> completeOrder(int orderId) async {
    try{
      Dio dio = new Dio();
      FormData formdata = FormData.fromMap({
        'orderId' : orderId
      });
      var response = await dio.post(
        "",
        data: formdata,
      );
      if(response.statusCode == 200){
        CustomData.orderCount = CustomData.orderCount - 1;
        print("" + CustomData.orderCount.toString());
        return true;
      }
    }
    on DioError catch (e){
      print(e.response);
    }
  }

  // ignore: missing_return
  static Future<List<Product>> getProviderProducts() async {
    try{
      int id = await CustomData.getProviderId();
      FormData formdata = FormData.fromMap({
        'providerId' : id
      });
      Dio dio = new Dio();
      List<Product> data = [];
      var response = await dio.post(
        "",
        data: formdata,
      );
      if(response.statusCode == 200){
        if(jsonDecode(response.data) != "no data fround"){
          data = (jsonDecode(response.data) as List).map((e) => Product.fromJsonUser(e)).toList();
          print("length is " + data.length.toString());
        }
      }
      return data;
    }
    on DioError catch (e){
      print(e.response);
    }
  }

  // ignore: missing_return
  static Future<bool> addProviderNewProduct(Product product) async {
    try{
      Dio dio = new Dio();
      FormData formdata = FormData.fromMap({
        "name": product.name,
        "price": product.price,
        "quantity": product.quantity,
        "providerId": product.providerId,
        "file": await MultipartFile.fromFile(
            product.imageUrl,
            filename: basename(product.imageUrl)
        ),
      });
      var response = await dio.post(
        "",
        data: formdata,
      );
      if(response.statusCode == 200){
        if(jsonDecode(response.data)){
          return true;
        }
        else{
          return false;
        }
      }
    }
    on DioError catch (e){
      print(e.response);
    }
  }

  // ignore: missing_return
  static Future<bool> deleteProviderProduct(int productId) async {
    try{
      Dio dio = new Dio();
      int id = await CustomData.getProviderId();
      FormData formdata = FormData.fromMap({
        "productId": productId,
        "providerId": id,
      });
      var response = await dio.post(
        "",
        data: formdata,
      );
      if(response.statusCode == 200){
        if(jsonDecode(response.data)){
          return true;
        }
        else{
          return false;
        }
      }
    }
    on DioError catch (e){
      print(e.response);
    }
  }
}