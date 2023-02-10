import 'package:cool_alert/cool_alert.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minimize_app/minimize_app.dart';
import 'package:nearmy/components/components.dart';
import 'package:nearmy/user/pages/mainNavPages/UserLogInPage.dart';
import 'package:nearmy/user/pages/mainNavPages/UserMapPage.dart';
import 'package:nearmy/user/pages/mainNavPages/UserMenuPage.dart';
import 'package:nearmy/user/pages/mainNavPages/UserProfilePage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPageProvider extends ChangeNotifier{
  int _selectedIndexBottomNavBar = 1;

  int get getSelectedIndexBottomNavBar => _selectedIndexBottomNavBar;

  void setSelectedIndexBottomNavBar(int value) async {
    _selectedIndexBottomNavBar = value;
    notifyListeners();
  }
}

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage>{

  @override
  void initState() {
    Provider.of<UserMapPageProvider>(context, listen: false).getUserCurrentLocation();
    CustomData.getUserId();
    setUserMemoryValues();
    Provider.of<UserMapPageProvider>(context,listen: false).setCustomMarkersIcon();
    //setMemoryValue();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void setMemoryValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getDouble("userLatitude") != null && prefs.getDouble("userLongitude") != null){
      Position position = new Position(latitude: prefs.getDouble("userLatitude"),longitude: prefs.getDouble("userLongitude"));
      Provider.of<UserMapPageProvider>(context, listen: false).setUserPosition(position);
    }
  }

  void setUserMemoryValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getBool("userAccountLogin") != null && prefs.getBool("userAccountLogin")){
      Provider.of<UserLogInPageProvider>(context,listen: false).setIsUserLoginToAccount(true);
    }
    else{
      Provider.of<UserLogInPageProvider>(context,listen: false).setIsUserLoginToAccount(false);
    }
  }

  final List<IconData> appBarIcon = [
    Icons.place,
    Icons.home,
    Icons.person_sharp
  ];

  final List<String> appBarTitle = ["Find Providers", "Home", "Login"];

  @override
  Widget build(BuildContext context) {
    CustomContext.context = context;
    return WillPopScope(
      onWillPop: () => CoolAlert.show(
        context: context,
        type: CoolAlertType.confirm,
        backgroundColor: Colors.orange,
        onConfirmBtnTap: () async {
          Navigator.of(context).pop();
          MinimizeApp.minimizeApp();
          //SystemNavigator.pop(animated: true);
        },
        confirmBtnTextStyle: GoogleFonts.roboto(
          color: Colors.white,
          fontSize: 15.0,
        ),
        onCancelBtnTap: () => Navigator.of(context).pop(),
        cancelBtnTextStyle: GoogleFonts.roboto(
          color: Colors.black,
          fontSize: 15.0,
        ),
        confirmBtnText: "Exit",
        confirmBtnColor: Colors.orange,
      ),
      child: Scaffold(
        appBar: (context.watch<UserPageProvider>().getSelectedIndexBottomNavBar != 2) || (!context.watch<UserLogInPageProvider>().isUserLoginToAccount) ?
        customAppBar(
          context: context,
          leadIcon: Icon(appBarIcon[context.watch<UserPageProvider>().getSelectedIndexBottomNavBar]),
          titleText: appBarTitle[context.watch<UserPageProvider>().getSelectedIndexBottomNavBar],
          action: context.watch<UserPageProvider>().getSelectedIndexBottomNavBar == 1 ? "about-us" : "normal",
        ) : null,
        body: IndexedStack(
          index: context.watch<UserPageProvider>().getSelectedIndexBottomNavBar,
          children: [
            const UserMapPage(),
            const UserProvidersPage(),
            context.watch<UserLogInPageProvider>().isUserLoginToAccount ? const UserProfilePage() : UserLogInPage(),
          ],
        ),
        bottomNavigationBar: FancyBottomNavigation(
          initialSelection: 1,
          barBackgroundColor: Colors.orange,
          activeIconColor: Colors.orange,
          inactiveIconColor: Colors.white,
          circleColor: Colors.white,
          tabs: [
            TabData(iconData: appBarIcon[0], title: ""),
            TabData(iconData: appBarIcon[1], title: ""),
            TabData(iconData: appBarIcon[2], title: "")
          ],
          onTabChangedListener: (position) {
            context.read<UserPageProvider>().setSelectedIndexBottomNavBar(position);
          },
        ),
      ),
    );
  }
}
