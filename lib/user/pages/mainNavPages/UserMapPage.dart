import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nearmy/API/UserAPICall.dart';
import 'package:nearmy/components/components.dart';
import 'package:nearmy/provider/model/Provider.dart';
import 'package:provider/provider.dart';
import '../otherPages/MenuItemPage.dart';

class UserMapPageProvider extends ChangeNotifier{
  bool _isLoadingMap = true;

  bool _markersLoading = false;

  // ignore: cancel_subscriptions
  StreamSubscription<Position> positionStream;

  List<String> _markersName = ["1.png","2.png","3.png","4.png","5.png","6.png","7.png","8.png"];

  static List<BitmapDescriptor> _customMarkers = [];

  static List<Marker> _markerPlaces = [];

  static Position _userPosition;

  Position get getUserPosition => _userPosition;

  bool get getIsMapLoading => _isLoadingMap;

  bool get isMarkerLoading => _markersLoading;

  List<Marker> get getMarkerPlaces => _markerPlaces;

  FlutterLocalNotificationsPlugin localNotification;

  void setUserPosition(Position position){
    _userPosition = position;
    notifyListeners();
  }

  void setIsMarkerLoadingState(bool value){
    _markersLoading = value;
    notifyListeners();
  }

  void setLoadingStateMap(bool value){
    _isLoadingMap = value;
    notifyListeners();
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
  }

  void setCustomMarkersIcon() async {
    for(int x = 0; x < _markersName.length; x++){
      int imageValue = x;
      final Uint8List markerIcon = await getBytesFromAsset("assets/mapIcons/"+ (imageValue+1).toString() +".png", 170);
      _customMarkers.add(BitmapDescriptor.fromBytes(markerIcon));
    }
  }

  void showProvidersOptions(Providers provider){
    showModalBottomSheet(
      context: CustomContext.context,
      builder: (context) => Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height / 6,
        decoration: BoxDecoration(
          color: Colors.orange,
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              spreadRadius: 1.0,
              blurRadius: 2.0,
            ),
          ],
        ),
        child: Column(
          children: [
            Center(
              child: IconButton(
                icon: Icon(Icons.arrow_drop_down),
                iconSize: 50,
                color: Colors.white,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FloatingActionButton.extended(
                  heroTag: "ProfileWaveHeroMap",
                  backgroundColor: Colors.white,
                  label: Row(
                    children: [
                      CustomText(
                        text: "Wave Us",
                        color: Colors.orange,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Icon(Icons.accessibility,color: Colors.orange,),
                      ),
                    ],
                  ),
                  onPressed: () {
                    Navigator.of(CustomContext.context).pop();
                    CoolAlert.show(
                        context: context,
                        type: CoolAlertType.confirm,
                        backgroundColor: Colors.orange,
                        confirmBtnColor: Colors.orange,
                        title: "Confirm Wave",
                        confirmBtnText: "Confirm",
                        confirmBtnTextStyle:
                        GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: 15.0,
                        ),
                        onConfirmBtnTap: () async {
                          Navigator.of(CustomContext.context).pop();
                          CoolAlert.show(
                            context: CustomContext.context,
                            type: CoolAlertType.loading,
                            backgroundColor: Colors.orange,
                            title: "Waving to ${provider.name}",
                            text: "Please Wait...",
                          );
                          if (_userPosition.latitude != null &&
                              _userPosition.longitude != null) {
                            bool result = await UserAPICall.waveToProvider(
                                provider.providerId, _userPosition);
                            Navigator.of(CustomContext.context).pop();
                            if (result) {
                              CoolAlert.show(
                                  context: CustomContext.context,
                                  type: CoolAlertType.success,
                                  backgroundColor: Colors.orange,
                                  confirmBtnColor: Colors.orange,
                                  title: "Wave Completed",
                                  confirmBtnTextStyle:
                                  GoogleFonts.roboto(
                                    color: Colors.white,
                                    fontSize: 15.0,
                                  )
                              );
                            } else {
                              CoolAlert.show(
                                  context: CustomContext.context,
                                  type: CoolAlertType.error,
                                  backgroundColor: Colors.orange,
                                  confirmBtnColor: Colors.orange,
                                  title: "Error!! Try again later..",
                                  confirmBtnTextStyle:
                                  GoogleFonts.roboto(
                                    color: Colors.white,
                                    fontSize: 15.0,
                                  )
                              );
                            }
                          } else {
                            CoolAlert.show(
                                context: CustomContext.context,
                                type: CoolAlertType.error,
                                backgroundColor: Colors.orange,
                                confirmBtnColor: Colors.orange,
                                title: "location Error!! Try again later..",
                                confirmBtnTextStyle:
                                GoogleFonts.roboto(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                )
                            );
                          }
                        });
                  },
                ),
                FloatingActionButton.extended(
                  heroTag: "ProfileHeroMap",
                  backgroundColor: Colors.white,
                  label: Row(
                    children: [
                      CustomText(
                        text: "Shop",
                        color: Colors.orange,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Icon(Icons.add_business,color: Colors.orange,),
                      ),
                    ],
                  ),
                  onPressed: (){
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => MenuItemPage(provider))
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void addMarkerToList(Providers provider,var location) async {
    _markerPlaces.add(Marker(
        markerId: MarkerId(provider.providerId.toString()),
        infoWindow: InfoWindow(
          title: provider.name,
          onTap: (){
            showProvidersOptions(provider);
          }
        ),
        icon: _customMarkers[provider.category - 1],
        position: LatLng(double.parse(location[0]),double.parse(location[1])),
        /*onTap: (){
          showProvidersOptions(provider);
        }*/
    ));
  }

  void clearMarkers(){
    _markerPlaces.clear();
    notifyListeners();
  }

  void setMapMarkers(List<Providers> providers,{bool filter = true}) async {
    Position user = UserMapPageProvider().getUserPosition;
    clearMarkers();
    Providers nearestProvider;
    double distance;
    providers.forEach((provider) {
      var location = provider.location.split(",");
      if(!CustomData.notificationState){
        double tempDistance = Geolocator.distanceBetween(double.parse(location[0]),double.parse(location[1]),user.latitude,user.longitude);
        if(tempDistance <= 200){
          if(distance == null){
            distance = tempDistance;
            nearestProvider = provider;
          }
          else{
            if(tempDistance < distance){
              distance = tempDistance;
              nearestProvider = provider;
            }
          }
        }
      }
      /*if(filter){
        if(Geolocator.distanceBetween(double.parse(location[0]),double.parse(location[1]),user.latitude,user.longitude) <= 2000){
          addMarkerToList(provider, location);
        }
      }
      else{
        addMarkerToList(provider, location);
      }*/
      addMarkerToList(provider, location);
    });
    if(nearestProvider != null){
      showNotification(nearestProvider.name,distance.toStringAsFixed(2));
      CustomData.notificationState = true;
    }
    notifyListeners();
  }


  void setLocationValue(Position _position){
    setUserPosition(_position);
    setLoadingStateMap(false);
  }

  void getLocation() async {
    positionStream = Geolocator.getPositionStream(desiredAccuracy: LocationAccuracy.bestForNavigation,distanceFilter: 5).listen((Position _position) async {
      if(_position.latitude == null || _position.longitude == null){
        await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation).then((_position) async {
          if(_position.latitude == null || _position.longitude == null){
            await Geolocator.getLastKnownPosition().then((value){
              setLocationValue(_position);
              //UserAPICall.updateUserLocation(_position);
            });
          }
          setLocationValue(_position);
          //UserAPICall.updateUserLocation(_position);
        });
      }
      else{
        setLocationValue(_position);
        //UserAPICall.updateUserLocation(_position);
      }
    });
  }

  Future<bool> checkLocationServiceEnable() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  Future<bool> checkPermissionIsEnable() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if((permission == LocationPermission.always) || (permission == LocationPermission.whileInUse)){
      return true;
    }
    else{
      return false;
    }
  }

  void getUserCurrentLocation() async {
    if(await checkLocationServiceEnable()){
      if(await checkPermissionIsEnable()){
        getLocation();
      }
      else{
        await Geolocator.requestPermission();
        getUserCurrentLocation();
      }
    }
    else{
      await Geolocator.openLocationSettings();
      getUserCurrentLocation();
    }
  }

  Future showNotification(String name,String distance) async {
    var androidDetails = new AndroidNotificationDetails("channelId", "Local Notification", "Local Notification",importance: Importance.high);
    var iosDetails = new IOSNotificationDetails();
    var generalNotificationDetails = new NotificationDetails(android: androidDetails,iOS: iosDetails);
    await localNotification.show(0, name, distance + "m Near You", generalNotificationDetails);
  }

  void getNewData(){
    Timer.periodic(const Duration(seconds: 5), (timer) {
      if(!isMarkerLoading){
        print("get new provider data");
        setIsMarkerLoadingState(true);
        UserAPICall.getNearProvidersData().then((value){
          if(value != null){
            setMapMarkers(value,filter: false);
          }
        });
        notifyListeners();
        setIsMarkerLoadingState(false);
      }
    });
  }
}

class UserMapPage extends StatefulWidget {

  const UserMapPage();

  @override
  _UserMapPageState createState() => _UserMapPageState();
}

class _UserMapPageState extends State<UserMapPage> {

  GoogleMapController _mapController;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  void moveToLocation() async {
    _mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(context.read<UserMapPageProvider>().getUserPosition.latitude, context.read<UserMapPageProvider>().getUserPosition.longitude),
      zoom: 16.0,
    )));
  }

  @override
  Widget build(BuildContext context) {
    context.read<UserMapPageProvider>().getUserCurrentLocation();
    return Center(
      child: context.watch<UserMapPageProvider>().getIsMapLoading ?
      Container(
        color: Colors.transparent,
        width: 100,
        height: 100,
        child: CircularProgressIndicator(
          backgroundColor: Colors.orange,
          strokeWidth: 5.0,
        ),
      ) :
      Padding(
        padding: const EdgeInsets.all(5.0),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
            bottomRight: Radius.circular(20),
            bottomLeft: Radius.circular(15),
          ),
          child: Stack(
            children: [
              GoogleMap(
                onMapCreated: (GoogleMapController _controller) {
                  _mapController = _controller;
                },
                initialCameraPosition: CameraPosition(
                  target: LatLng(context.read<UserMapPageProvider>().getUserPosition.latitude, context.read<UserMapPageProvider>().getUserPosition.longitude),
                  zoom: 16.0,
                ),
                mapType: MapType.normal,
                trafficEnabled: false,
                mapToolbarEnabled: false,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                compassEnabled: false,
                markers: Set.from(context.watch<UserMapPageProvider>().getMarkerPlaces),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: FloatingActionButton(
                  heroTag: "MapPageHeroMyPosition",
                  elevation: 5,
                  backgroundColor: Colors.orange,
                  mini: true,
                  onPressed: (){
                    print(context.read<UserMapPageProvider>().getUserPosition.toString());
                    moveToLocation();
                  },
                  child: Icon(Icons.navigation_outlined),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
