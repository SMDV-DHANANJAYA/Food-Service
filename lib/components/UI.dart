import 'dart:async';
import 'dart:io';

class UI{
  static Future<bool> checkInternetState() async {
    try {
      final _result = await InternetAddress.lookup('google.com');
      if (_result.isNotEmpty && _result[0].rawAddress.isNotEmpty) {
        return true;
      }
      else{
        return false;
      }
    } on SocketException catch (_) {
      return false;
    }
  }
}