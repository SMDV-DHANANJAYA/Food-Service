import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nearmy/components/aboutUsPage.dart';
import 'package:nearmy/provider/pages/otherPages/ProviderAddProductPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<Widget> appBarWidgets = [];

// ignore: missing_return
List<Widget> getAppBarWidgets(String type){
  switch(type){
    case "normal":
      appBarWidgets.clear();
      appBarWidgets.add(IconButton(
        icon: Icon(Icons.more_vert),
        onPressed: (){
        },
      ));
      return appBarWidgets;
      break;
    case "about-us":
      appBarWidgets.clear();
      appBarWidgets.add(
        PopupMenuButton<String>(
          icon: Icon(Icons.more_vert),
          onSelected: (String result) {
            switch (result) {
              case 'about-us':
                Navigator.of(CustomContext.context).push(MaterialPageRoute(
                    builder: (BuildContext context) => AboutUsPage())
                );
                break;
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              value: 'about-us',
              textStyle: GoogleFonts.roboto(
                color: Colors.black,
              ),
              height: 35.0,
              child: CustomText(
                text: "About Us",
                color: Colors.black,
                size: 18.0,
              ),
            ),
          ],
        ),
      );
      return appBarWidgets;
      break;
    case "add-product":
      appBarWidgets.clear();
      appBarWidgets.add(IconButton(
        icon: Icon(Icons.add),
        onPressed: (){
          Navigator.of(CustomContext.context).push(MaterialPageRoute(
              builder: (BuildContext context) => ProviderAddProductPage())
          );
        },
      ));
      return appBarWidgets;
      break;
  }
}

class CustomData{
  int providerId;

  int userId;

  static int orderCount = 0;

  static int waveCount = 0;

  static bool notificationState = false;

  static Future<int> getProviderId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt("providerProfileId");
  }

  static Future<int> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt("userProfileId");
  }
}

class CustomContext{
  static BuildContext context;
}

class CustomText extends StatelessWidget {
  final String text;
  final Color color;
  final double space;
  final double size;
  final bool resize;
  final int lineCount;

  CustomText({@required this.text,this.color = Colors.white,this.space,this.size,this.resize = false,this.lineCount});

  @override
  Widget build(BuildContext context) {
    return !resize ?
    Text(
      text,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.roboto(
        color: color,
        letterSpacing: space,
        fontSize: size,
      ),
    ):
    AutoSizeText(
      text,
      maxLines: lineCount,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.roboto(
        color: color,
        letterSpacing: space,
        fontSize: size,
      ),
    );
  }
}

AppBar customAppBar({@required BuildContext context, @required Icon leadIcon,@required String titleText,String action = "normal"}) {

  return AppBar(
    backgroundColor: Colors.orange,
    centerTitle: true,
    toolbarHeight: calculateSize(context, "height") ? 50 : 60,
    elevation: 5,
    leading: leadIcon,
    title: CustomText(text: titleText,space: 3.0,),
    actions: getAppBarWidgets(action),
  );
}

bool calculateSize(BuildContext context,String side){
  if(side == "width"){
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    return shortestSide < 600;
  }
  if(side == "height"){
    var longestSide = MediaQuery.of(context).size.longestSide;
    return longestSide < 800;
  }
  return null;
}