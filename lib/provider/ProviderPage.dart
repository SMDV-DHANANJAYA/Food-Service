import 'package:cool_alert/cool_alert.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minimize_app/minimize_app.dart';
import 'package:nearmy/components/components.dart';
import 'package:nearmy/provider/pages/mainNavPages/ProviderMapPage.dart';
import 'package:nearmy/provider/pages/mainNavPages/ProviderOrdersPage.dart';
import 'package:nearmy/provider/pages/mainNavPages/ProviderProfilePage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProviderPageProvider extends ChangeNotifier{
  int _selectedIndexBottomNavBar = 1;

  GlobalKey<FancyBottomNavigationState> bottomNavigationKey;

  int get getSelectedIndexBottomNavBar => _selectedIndexBottomNavBar;

  void setSelectedIndexBottomNavBar(int value) async {
    _selectedIndexBottomNavBar = value;
    notifyListeners();
  }
}

class ProviderPage extends StatefulWidget {
  @override
  _ProviderPageState createState() => _ProviderPageState();
}

class _ProviderPageState extends State<ProviderPage>{

  @override
  void initState() {
    Provider.of<ProviderMapPageProvider>(context, listen: false).getProviderCurrentLocation();
    Provider.of<ProviderPageProvider>(context, listen: false).bottomNavigationKey = GlobalKey<FancyBottomNavigationState>();
    CustomData.getProviderId();
    Provider.of<ProviderMapPageProvider>(context,listen: false).setCustomMarkersIcon();
    //setMemoryValue();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void setMemoryValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getDouble("providerLatitude") != null && prefs.getDouble("providerLongitude") != null){
      Position position = new Position(latitude: prefs.getDouble("providerLatitude"),longitude: prefs.getDouble("providerLongitude"));
      Provider.of<ProviderMapPageProvider>(context, listen: false).setProviderPosition(position);
    }
  }

  final List<IconData> appBarIcon = [
    Icons.place,
    Icons.delivery_dining,
    Icons.person_sharp
  ];

  final List<String> appBarTitle = ["Find Buyers", "Orders", "Login"];

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
        appBar: context.watch<ProviderPageProvider>().getSelectedIndexBottomNavBar != 2 ?
        customAppBar(
          context: context,
          leadIcon: Icon(appBarIcon[context.watch<ProviderPageProvider>().getSelectedIndexBottomNavBar]),
          titleText: appBarTitle[context.watch<ProviderPageProvider>().getSelectedIndexBottomNavBar],
          action: context.watch<ProviderPageProvider>().getSelectedIndexBottomNavBar == 1 ? "about-us" : "normal",
        ) : null,
        body: IndexedStack(
          index: context.watch<ProviderPageProvider>().getSelectedIndexBottomNavBar,
          children: [
            const ProviderMapPage(),
            const OrdersPage(),
            const ProviderProfilePage(),
          ],
        ),
        bottomNavigationBar: FancyBottomNavigation(
          initialSelection: 1,
          key: Provider.of<ProviderPageProvider>(context, listen: false).bottomNavigationKey,
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
            context.read<ProviderPageProvider>().setSelectedIndexBottomNavBar(position);
          },
        ),
      ),
    );
  }
}
