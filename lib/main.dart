import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nearmy/HomePage.dart';
import 'package:nearmy/provider/ProviderPage.dart';
import 'package:nearmy/provider/pages/mainNavPages/ProviderLogInPage.dart';
import 'package:nearmy/provider/pages/mainNavPages/ProviderMapPage.dart';
import 'package:nearmy/provider/pages/otherPages/ProviderAddProductPage.dart';
import 'package:nearmy/provider/pages/otherPages/ProviderProductPage.dart';
import 'package:nearmy/provider/pages/otherPages/ProviderSignUpPage.dart';
import 'package:nearmy/user/UserPage.dart';
import 'package:nearmy/user/pages/mainNavPages/UserLogInPage.dart';
import 'package:nearmy/user/pages/mainNavPages/UserMapPage.dart';
import 'package:nearmy/user/pages/mainNavPages/UserMenuPage.dart';
import 'package:nearmy/user/pages/otherPages/CartPage.dart';
import 'package:nearmy/user/pages/otherPages/UserSignUpPage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/ErrorPage.dart';
import 'components/UI.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom, SystemUiOverlay.top]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
  ));
  /*runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UserSignUpPageProvider()),
          ChangeNotifierProvider(create: (_) => UserLogInPageProvider()),
          ChangeNotifierProvider(create: (_) => CartProvider()),
          ChangeNotifierProvider(create: (_) => UserMapPageProvider()),
          ChangeNotifierProvider(create: (_) => UserMenuPageProvider()),
          ChangeNotifierProvider(create: (_) => UserPageProvider()),
          ChangeNotifierProvider(create: (_) => ProviderPageProvider()),
          ChangeNotifierProvider(create: (_) => ProviderSignUpPageProvider()),
          ChangeNotifierProvider(create: (_) => ProviderMapPageProvider()),
          ChangeNotifierProvider(create: (_) => ProviderLogInPageProvider()),
          ChangeNotifierProvider(create: (_) => ProviderProductPageProvider()),
          ChangeNotifierProvider(create: (_) => ProviderAddProductPageProvider()),
        ],
        child: const MyApp(),
      ),
    ),
  );*/
  /*runApp(
    Phoenix(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UserSignUpPageProvider()),
          ChangeNotifierProvider(create: (_) => UserLogInPageProvider()),
          ChangeNotifierProvider(create: (_) => CartProvider()),
          ChangeNotifierProvider(create: (_) => UserMapPageProvider()),
          ChangeNotifierProvider(create: (_) => UserMenuPageProvider()),
          ChangeNotifierProvider(create: (_) => UserPageProvider()),
          ChangeNotifierProvider(create: (_) => ProviderPageProvider()),
          ChangeNotifierProvider(create: (_) => ProviderSignUpPageProvider()),
          ChangeNotifierProvider(create: (_) => ProviderMapPageProvider()),
          ChangeNotifierProvider(create: (_) => ProviderLogInPageProvider()),
          ChangeNotifierProvider(create: (_) => ProviderProductPageProvider()),
          ChangeNotifierProvider(create: (_) => ProviderAddProductPageProvider()),
        ],
        child: const MyApp(),
      ),
    ),
  );*/
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserSignUpPageProvider()),
        ChangeNotifierProvider(create: (_) => UserLogInPageProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => UserMapPageProvider()),
        ChangeNotifierProvider(create: (_) => UserMenuPageProvider()),
        ChangeNotifierProvider(create: (_) => UserPageProvider()),
        ChangeNotifierProvider(create: (_) => ProviderPageProvider()),
        ChangeNotifierProvider(create: (_) => ProviderSignUpPageProvider()),
        ChangeNotifierProvider(create: (_) => ProviderMapPageProvider()),
        ChangeNotifierProvider(create: (_) => ProviderLogInPageProvider()),
        ChangeNotifierProvider(create: (_) => ProviderProductPageProvider()),
        ChangeNotifierProvider(create: (_) => ProviderAddProductPageProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {

  const MyApp();

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  String type = "";

  @override
  void initState() {
    checkUserType();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void checkUserType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getBool("providerAccountLogin") != null && prefs.getBool("providerAccountLogin")){
      type = "provider";
    }
    else if(prefs.getBool("userAccountLogin") != null && prefs.getBool("userAccountLogin")){
      type = "user";
    }
    else{
      type = "welcome";
    }
    setState((){});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      /*locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,*/
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Color(0xFFEBEBEB),
      ),
      home: FutureBuilder(
        future: UI.checkInternetState(),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          // ignore: missing_return
          if(snapshot.hasData){
            if(snapshot.data){
              if(type == "user"){
                return UserPage();
              }
              else if(type == "provider"){
                return ProviderPage();
              }
              else{
                return HomePage();
              }
            }
            else{
              return const ErrorPage();
            }
          }
          else {
            return Scaffold(
              body: Center(
                child: SizedBox(
                  height: 70.0,
                  width: 70.0,
                  child: CircularProgressIndicator(
                    strokeWidth: 5.0,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}