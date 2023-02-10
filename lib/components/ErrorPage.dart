import 'package:flutter/material.dart';
import 'package:nearmy/HomePage.dart';
import 'package:nearmy/components/components.dart';

import 'UI.dart';

class ErrorPage extends StatefulWidget {

  const ErrorPage();

  @override
  _ErrorPageState createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {

  bool isShowLoading = false;

  Future<void> checkConnection() async {
    bool value = await UI.checkInternetState();
    Future.delayed(const Duration(seconds: 2), (){
      setState(() {
        isShowLoading = false;
      });
      if(value){
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => HomePage())
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: CustomText(
          text: "!!! Error !!!",
          color: Colors.orange,
          size: 40.0,
          space: 3,
          lineCount: 2,
          resize: true,
        ),
        toolbarHeight: 100.0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.wifi_off,
              color: Colors.black,
              size: MediaQuery.of(context).size.width / 2.5,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: isShowLoading ?
              SizedBox(
                height: 70.0,
                width: 70.0,
                child: CircularProgressIndicator(
                  strokeWidth: 5.0,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                ),
              ) :
              FloatingActionButton.extended(
                heroTag: "TryAgainButton",
                label: CustomText(
                  text: "Try Again",
                ),
                backgroundColor: Colors.orange,
                onPressed: () async {
                  setState(() {
                    isShowLoading = true;
                  });
                  checkConnection();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
