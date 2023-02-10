import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:nearmy/components/components.dart';
import 'package:nearmy/model/Banner.dart';
import 'package:nearmy/model/Product.dart';
import 'package:nearmy/provider/model/Provider.dart';
import 'package:nearmy/user/model/User.dart';
import 'package:nearmy/user/pages/mainNavPages/UserMapPage.dart';
import 'package:path/path.dart';

class UserAPICall{

  // ignore: missing_return
  static Future<List<Banners>> getBannersData() async {
    try{
      Dio dio = new Dio();
      List<Banners> data = [];
      var response = await dio.get("https://nearmy.xyz/nearmy_api/userAPI/banners.php");
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
  static Future<List<Providers>> getProvidersData() async {
    try{
      FormData formdata = FormData.fromMap({
        "type": 'all',
      });
      Dio dio = new Dio();
      List<Providers> data = [];
      var response = await dio.post(
        "https://nearmy.xyz/nearmy_api/userAPI/providers.php",
        data: formdata,
      );
      if(response.statusCode == 200){
        if(jsonDecode(response.data) != "no data fround"){
          data = (jsonDecode(response.data) as List).map((e) => Providers.fromJson(e)).toList();
          /*UserMapPageProvider map = new UserMapPageProvider();
          map.setMapMarkers(data);*/
        }
      }
      return data;
    }
    on DioError catch (e){
      print(e.response);
    }
  }

  // ignore: missing_return
  static Future<List<Providers>> getNearProvidersData() async {
    try{
      FormData formdata = FormData.fromMap({
        'type' : 'near',
        'mylatitude' : UserMapPageProvider().getUserPosition.latitude,
        'mylongitude' : UserMapPageProvider().getUserPosition.longitude
      });
      Dio dio = new Dio();
      List<Providers> data = [];
      var response = await dio.post(
        "https://nearmy.xyz/nearmy_api/userAPI/providers.php",
        data: formdata,
      );
      if(response.statusCode == 200){
        if(jsonDecode(response.data) != "no data fround"){
          data = (jsonDecode(response.data) as List).map((e) => Providers.fromJson(e)).toList();
        }
      }
      return data;
    }
    on DioError catch (e){
      print(e.response);
    }
  }

  // ignore: missing_return
  static Future<List<Product>> getProductsData(int id) async {
    try{
      FormData formdata = FormData.fromMap({
        'user_id' : id
      });
      Dio dio = new Dio();
      List<Product> data = [];
      var response = await dio.post(
        "https://nearmy.xyz/nearmy_api/userAPI/products.php",
        data: formdata,
      );
      if(response.statusCode == 200){
        if(jsonDecode(response.data) != "no data fround"){
          data = (jsonDecode(response.data) as List).map((e) => Product.fromJsonUser(e)).toList();
        }
      }
      return data;
    }
    on DioError catch (e){
      print(e.response);
    }
  }

  // ignore: missing_return
  static Future<void> submitRate(int providerID,int count) async {
    try{
      FormData formdata = FormData.fromMap({
        "provider_id": providerID,
        "count": count
      });
      Dio dio = new Dio();
      var response = await dio.post(
        "https://nearmy.xyz/nearmy_api/userAPI/addRate.php",
        data: formdata,
      );
      if(response.statusCode == 200){
        if(jsonDecode(response.data) == true){
          print(true);
        }
        else{
          print(false);
        }
      }
    }
    on DioError catch (e){
      print(e.response);
    }
  }

  // ignore: missing_return
  static Future<int> createUser(User user) async {
    try{
      FormData formdata = FormData.fromMap({
        "name": user.userName,
        "email": user.email,
        "password": user.password,
        "file": await MultipartFile.fromFile(
            user.imageUrl,
            filename: basename(user.imageUrl)
        ),
      });

      Dio dio = new Dio();
      var response = await dio.post("https://nearmy.xyz/nearmy_api/userAPI/createUser.php",data: formdata);

      if(response.statusCode == 200){
        return jsonDecode(response.data);
      }
    }
    on DioError catch (e){
      print(e.response);
    }
  }

  // ignore: missing_return
  static Future<int> loginUser(User user) async {
    try{
      FormData formdata = FormData.fromMap({
        'email' : user.email,
        'password' : user.password
      });
      Dio dio = new Dio();
      var response = await dio.post(
        "https://nearmy.xyz/nearmy_api/userAPI/loginUser.php",
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
  static Future<User> getUserData() async {
    try{
      Dio dio = new Dio();
      int userId = await CustomData.getUserId();
      FormData formdata = FormData.fromMap({
        'id' : userId
      });
      User user;
      var response = await dio.post(
        "https://nearmy.xyz/nearmy_api/userAPI/getUserData.php",
        data: formdata,
      );
      if(response.statusCode == 200){
        if(jsonDecode(response.data) != "no data fround"){
          user = new User.fromJson(jsonDecode(response.data));
          return user;
        }
      }
    }
    on DioError catch (e){
      print(e.response);
    }
  }

  // ignore: missing_return
  static Future<bool> deleteUserProfile() async {
    try{
      Dio dio = new Dio();
      int userId = await CustomData.getUserId();
      FormData formdata = FormData.fromMap({
        'id' : userId
      });
      var response = await dio.post(
        "https://nearmy.xyz/nearmy_api/userAPI/deleteUserProfile.php",
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
  static Future<bool> submitOrder(List<Product> userCart,double fullCount,Position position) async {
    String itemList = "";

    userCart.forEach((product) {
      itemList += product.productId.toString() + ":" + product.quantity.toString() + "|";
    });

    itemList = itemList.substring(0,itemList.length - 1);

    DateTime dateTime = DateTime.now();

    String date = dateTime.year.toString() + ":" + dateTime.month.toString() + ":" + dateTime.day.toString();
    String time = DateFormat("jms").format(dateTime);
    int userId = await CustomData.getUserId();
    String providerId = userCart[0].providerId.toString();

    String userPosition = position.latitude.toString() + "," + position.longitude.toString();

    FormData formdata = FormData.fromMap({
      'date' : date,
      'time' : time,
      'userId' : userId,
      'providerId' : providerId,
      'fullAmount' : fullCount,
      'userLocation' : userPosition,
      'itemList' : itemList,
    });

    try{
      Dio dio = new Dio();
      var response = await dio.post(
        "https://nearmy.xyz/nearmy_api/userAPI/submitOrder.php",
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
  static Future<bool> waveToProvider(int providerId, Position userPosition) async {
    try{
      String position = userPosition.latitude.toString() + "," + userPosition.longitude.toString();
      Dio dio = new Dio();
      DateTime dateTime = DateTime.now();
      String date = dateTime.year.toString() + ":" + dateTime.month.toString() + ":" + dateTime.day.toString();
      String time = DateFormat("jms").format(dateTime);
      FormData formdata = FormData.fromMap({
        'providerId' : providerId,
        'userPosition' : position,
        'date' : date,
        'time' : time,
      });
      var response = await dio.post(
        "https://nearmy.xyz/nearmy_api/userAPI/waveToProvider.php",
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

  /*// ignore: missing_return
  static Future<bool> updateUserLocation(Position position) async {
    try{
      print("location update karanawa");
      int id = await CustomData.getUserId();
      String location = position.latitude.toString() + "," + position.longitude.toString();
      Dio dio = new Dio();
      FormData formdata = FormData.fromMap({
        'location' : location,
        'userId' : id
      });
      var response = await dio.post(
        "https://nearmy.xyz/nearmy_api/userAPI/updateUserLocation.php",
        data: formdata,
      );
      if(response.statusCode == 200){
        return true;
      }
    }
    on DioError catch (e){
      print(e.response);
    }
  }*/
}