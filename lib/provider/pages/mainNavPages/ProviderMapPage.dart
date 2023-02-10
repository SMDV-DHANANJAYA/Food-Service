import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nearmy/API/ProviderAPICall.dart';
import 'package:nearmy/components/components.dart';
import 'package:nearmy/provider/model/Order.dart';
import 'package:nearmy/provider/model/Wave.dart';
import 'package:provider/provider.dart';

class ProviderMapPageProvider extends ChangeNotifier{
  bool _isLoadingMap = true;

  bool _markersLoading = false;

  bool _ordersLoading = false;

  // ignore: cancel_subscriptions
  StreamSubscription<Position> positionStream;

  List<String> _markersName = ["order-marker.png","wave-marker.png"];

  static List<BitmapDescriptor> _customMarkers = [];

  static List<Marker> _markerPlacesWave = [];

  static List<Marker> _markerPlacesOrder = [];

  static List<Marker> _markerPlacesAll = [];

  static List<Orders> _orderData = [];

  static Timer timerWave;

  static Timer timerOrder;

  static Position _providerPosition;

  GoogleMapController _mapController;

  GoogleMapController get getGoogleMapController => _mapController;

  Position get getProviderPosition => _providerPosition;

  bool get getIsMapLoading => _isLoadingMap;

  bool get isMarkerLoading => _markersLoading;

  List<Marker> get getMarkerPlacesWave => _markerPlacesWave;

  List<Marker> get getMarkerPlacesOrder => _markerPlacesOrder;

  List<Marker> get getMarkerPlacesAll => _markerPlacesAll;

  List<Orders> get getMarkerOrdersAll => _orderData;

  void setGoogleMapController(GoogleMapController mapController){
    _mapController = mapController;
    notifyListeners();
  }

  void setMakersPlacesAll(){
    _markerPlacesAll.clear();
    print("orders length " + _markerPlacesOrder.length.toString());
    print("wave length " + _markerPlacesWave.length.toString());
    _markerPlacesAll = new List.from(_markerPlacesWave)..addAll(_markerPlacesOrder);
    notifyListeners();
  }

  void setProviderPosition(Position position){
    _providerPosition = position;
    notifyListeners();
  }

  void setIsOrderLoadingState(bool value){
    _ordersLoading = value;
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
    _markersName.forEach((marker) async {
      final Uint8List markerIcon = await getBytesFromAsset("assets/mapIcons/" + marker, 170);
      _customMarkers.add(BitmapDescriptor.fromBytes(markerIcon));
    });
  }

  void showUsersOptions({Wave wave,Orders order,String type}){
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
            Center(
              child: type == "wave" ?
              FloatingActionButton.extended(
                heroTag: "CompleteWaveHeroMap",
                backgroundColor: Colors.white,
                label: Row(
                  children: [
                    CustomText(
                      text: "Complete Wave",
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
                      title: "Confirm Wave Complete",
                      confirmBtnText: "Confirm",
                      confirmBtnTextStyle:
                      GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 15.0,
                      ),
                      onConfirmBtnTap: () async {
                        Navigator.of(CustomContext.context).pop();
                        ProviderAPICall.setWaveComplete(wave.waveId).then((value){
                          setMakersPlacesAll();
                        });
                      });
                },
              ) :
              FloatingActionButton.extended(
                heroTag: "CompleteOrderHeroMap",
                backgroundColor: Colors.white,
                label: Row(
                  children: [
                    CustomText(
                      text: "Complete Order",
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
                      title: "Confirm Order Complete",
                      confirmBtnText: "Confirm",
                      confirmBtnTextStyle:
                      GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 15.0,
                      ),
                      onConfirmBtnTap: () async {
                        Navigator.of(CustomContext.context).pop();
                        ProviderAPICall.completeOrder(order.orderId).then((value){
                          setMakersPlacesAll();
                        });
                      });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void addWaveMarkerToList(Wave wave,var location) async {
    _markerPlacesWave.add(Marker(
        markerId: MarkerId(wave.waveId.toString()),
        infoWindow: InfoWindow(
          title: "Wave " + wave.waveDate + " (" + wave.waveTime + ")",
            onTap: (){
              showUsersOptions(wave: wave,type: "wave");
            }
        ),
        icon: _customMarkers[0],
        position: LatLng(double.parse(location[0]),double.parse(location[1])),
    ));
  }

  void addOrderMarkerToList(Orders order,var location) async {
    _markerPlacesOrder.add(Marker(
      markerId: MarkerId(order.orderId.toString()),
      infoWindow: InfoWindow(
          title: "Order " + order.orderDate + " (" + order.orderTime + ")",
          onTap: (){
            showUsersOptions(order: order,type: "order");
          }
      ),
      icon: _customMarkers[1],
      position: LatLng(double.parse(location[0]),double.parse(location[1])),
    ));
  }

  void clearWaveMarkers(){
    _markerPlacesWave.clear();
    print("markers clear kara wave.....");
    notifyListeners();
  }

  void clearOrderMarkers(){
    _markerPlacesOrder.clear();
    print("markers clear kara orders.....");
    notifyListeners();
  }

  void setMapWaveMarkers(List<Wave> waves) async {
    clearWaveMarkers();
    print("wave array length eka after clear = " + _markerPlacesWave.length.toString());
    print("wave array length dan gaththa = " + waves.length.toString());
    waves.forEach((wave) {
      var location = wave.waveLocation.split(",");
      addWaveMarkerToList(wave, location);
    });
    setMakersPlacesAll();
    notifyListeners();
  }

  void setMapOrderMarkers(List<Orders> orders) async {
    clearOrderMarkers();
    print("order array length eka after clear = " + _markerPlacesOrder.length.toString());
    print("order array length eka dan gaththa = " + orders.length.toString());
    orders.forEach((order) {
      var location = order.userLocation.split(",");
      addOrderMarkerToList(order, location);
    });
    setMakersPlacesAll();
    notifyListeners();
  }


  void setLocationValue(Position _position){
    setProviderPosition(_position);
    setLoadingStateMap(false);
  }

  void getLocation() async {
    positionStream = Geolocator.getPositionStream(desiredAccuracy: LocationAccuracy.bestForNavigation,distanceFilter: 5).listen((Position _position) async {
      if(_position.latitude == null || _position.longitude == null){
        await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation).then((_position) async {
          if(_position.latitude == null || _position.longitude == null){
            await Geolocator.getLastKnownPosition().then((value){
              setLocationValue(_position);
              ProviderAPICall.updateProviderLocation(_position);
            });
          }
          setLocationValue(_position);
          ProviderAPICall.updateProviderLocation(_position);
        });
      }
      else{
        setLocationValue(_position);
        ProviderAPICall.updateProviderLocation(_position);
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

  void getProviderCurrentLocation() async {
    if(await checkLocationServiceEnable()){
      if(await checkPermissionIsEnable()){
        getLocation();
      }
      else{
        await Geolocator.requestPermission();
        getProviderCurrentLocation();
      }
    }
    else{
      await Geolocator.openLocationSettings();
      getProviderCurrentLocation();
    }
  }

  void getNewOrderData(){
    timerOrder = Timer.periodic(const Duration(seconds: 5), (timer) {
      if(!_ordersLoading){
        print("get new order data");
        setIsOrderLoadingState(true);
        ProviderAPICall.getOrdersData().then((value){
          if(value != null){
            _orderData = value;
            setMapOrderMarkers(value);
          }
        });
        notifyListeners();
        setIsOrderLoadingState(false);
      }
    });
  }

  void getNewWaveData(){
    timerWave = Timer.periodic(const Duration(seconds: 5), (timer) {
      if(!isMarkerLoading){
        print("get new wave data");
        setIsMarkerLoadingState(true);
        ProviderAPICall.getProviderWaveData().then((value){
          if(value != null){
            setMapWaveMarkers(value);
          }
        });
        notifyListeners();
        setIsMarkerLoadingState(false);
      }
    });
  }

  void moveToLocation(LatLng point,{double zoom = 16.0}) async {
    _mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: point,
      zoom: zoom,
    )));
  }
}

class ProviderMapPage extends StatefulWidget {

  const ProviderMapPage();

  @override
  _ProviderMapPageState createState() => _ProviderMapPageState();
}

class _ProviderMapPageState extends State<ProviderMapPage> {

  @override
  void initState() {
    Provider.of<ProviderMapPageProvider>(context, listen: false).getProviderCurrentLocation();
    super.initState();
  }

  @override
  void dispose() {
    Provider.of<ProviderMapPageProvider>(context, listen: false).getGoogleMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: context.watch<ProviderMapPageProvider>().getIsMapLoading ?
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
                  context.read<ProviderMapPageProvider>().setGoogleMapController(_controller);
                },
                initialCameraPosition: CameraPosition(
                  target: LatLng(context.watch<ProviderMapPageProvider>().getProviderPosition.latitude, context.watch<ProviderMapPageProvider>().getProviderPosition.longitude),
                  zoom: 16.0,
                ),
                mapType: MapType.normal,
                trafficEnabled: false,
                mapToolbarEnabled: false,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                compassEnabled: false,
                markers: Set.from(context.watch<ProviderMapPageProvider>().getMarkerPlacesAll),
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
                    Provider.of<ProviderMapPageProvider>(context, listen: false).moveToLocation(LatLng(Provider.of<ProviderMapPageProvider>(context, listen: false).getProviderPosition.latitude, Provider.of<ProviderMapPageProvider>(context, listen: false).getProviderPosition.longitude));
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
