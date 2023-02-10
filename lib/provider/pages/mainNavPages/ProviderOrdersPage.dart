import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:nearmy/API/ProviderAPICall.dart';
import 'package:nearmy/components/components.dart';
import 'package:nearmy/model/Product.dart';
import 'package:nearmy/provider/ProviderPage.dart';
import 'package:provider/provider.dart';

import 'ProviderMapPage.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage();

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {

  @override
  void initState() {
    Provider.of<ProviderMapPageProvider>(context, listen: false).getNewOrderData();
    Provider.of<ProviderMapPageProvider>(context, listen: false).getNewWaveData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              child: FutureBuilder(
                future: ProviderAPICall.getBannersData(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return CarouselSlider.builder(
                      itemCount: snapshot.data.length,
                      options: CarouselOptions(
                        initialPage: 1,
                        autoPlayAnimationDuration: Duration(seconds: 2),
                        autoPlayInterval: Duration(seconds: 4),
                        pauseAutoPlayInFiniteScroll: true,
                        viewportFraction: 1,
                        enlargeCenterPage: false,
                        aspectRatio: 1,
                        autoPlay: true,
                        enableInfiniteScroll: true,
                      ),
                      itemBuilder: (BuildContext context, int itemIndex,
                          int pageViewIndex) {
                        return CachedNetworkImage(
                          imageUrl: snapshot.data[itemIndex].imageUrl,
                          placeholder: (context, url) => Container(
                            color: Colors.transparent,
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return Center(
                    child: SizedBox(
                      height: 50.0,
                      width: 50.0,
                      child: CircularProgressIndicator(
                        strokeWidth: 5.0,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.orange),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black,
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: "Recent Orders",
                    space: 2,
                    size: 20,
                  ),
                  Icon(
                    Icons.delivery_dining,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: context.watch<ProviderMapPageProvider>().getMarkerOrdersAll.length > 0 ?
            ListView.builder(
              padding: EdgeInsets.all(5.0),
              itemCount: context.watch<ProviderMapPageProvider>().getMarkerOrdersAll.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                var data = context.watch<ProviderMapPageProvider>().getMarkerOrdersAll[index];
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height:
                  MediaQuery.of(context).size.height / 5,
                  margin: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        spreadRadius: 1.0,
                        blurRadius: 1.0,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Center(
                        child: CustomText(
                          text: data.orderDate + " - " + data.orderTime,
                          color: Colors.black,
                          size: 20.0,
                        ),
                      ),
                      Center(
                        child: CustomText(
                          text: "Rs :- " + data.orderFullAmount.toString(),
                          color: Colors.black,
                          size: 30.0,
                        ),
                      ),
                      Center(
                        child: IconButton(
                          onPressed: (){
                            showCupertinoModalBottomSheet(
                              context: context,
                              expand: false,
                              builder: (context) => Container(
                                child: FutureBuilder(
                                  future: ProviderAPICall.getOrderProducts(data.orderId),
                                  builder: (BuildContext context, AsyncSnapshot snapshot){
                                    if(snapshot.hasData){
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            child: Material(
                                              child: Padding(
                                                padding: const EdgeInsets.only(top: 8.0,bottom: 8.0,left: 15.0),
                                                child: CustomText(
                                                  text: "Order Products",
                                                  size: 20.0,
                                                ),
                                              ),
                                              type: MaterialType.transparency,
                                            ),
                                            width: double.infinity,
                                            color: Colors.black,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount: snapshot.data.length,
                                                  itemBuilder: (BuildContext context, int index){
                                                    var data = snapshot.data[index] as Product;
                                                    return Padding(
                                                      padding: const EdgeInsets.only(bottom: 10.0),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Expanded(
                                                            flex: 3,
                                                            child: Padding(
                                                              padding: const EdgeInsets.only(right: 10.0),
                                                              child: Container(
                                                                height: 80,
                                                                decoration: BoxDecoration(
                                                                  color: Colors.orange,
                                                                  borderRadius: BorderRadius.circular(10.0),
                                                                ),
                                                                child: Padding(
                                                                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                    children: [
                                                                      Expanded(
                                                                        child: Material(
                                                                          child: CustomText(
                                                                            lineCount: 2,
                                                                            resize: true,
                                                                            text: data.name,
                                                                            size: 17.0,
                                                                            color: Colors.black,
                                                                          ),
                                                                          type: MaterialType.transparency,
                                                                        ),
                                                                      ),
                                                                      Material(
                                                                        child: CustomText(
                                                                          lineCount: 2,
                                                                          resize: true,
                                                                          text: "Qty - " + data.quantity.toString(),
                                                                          size: 17.0,
                                                                          color: Colors.black,
                                                                        ),
                                                                        type: MaterialType.transparency,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: CachedNetworkImage(
                                                              imageUrl: data.imageUrl,
                                                              placeholder: (context, url) =>
                                                                  Container(
                                                                    color: Colors.transparent,
                                                                  ),
                                                              errorWidget: (context, url, error) =>
                                                                  Icon(Icons.error),
                                                              imageBuilder:
                                                                  (context, imageProvider) =>
                                                                  Container(
                                                                    height: 80,
                                                                    width: 80,
                                                                    decoration: BoxDecoration(
                                                                      borderRadius:
                                                                      BorderRadius.circular(10.0),
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                          color: Colors.grey,
                                                                          spreadRadius: 2.0,
                                                                          blurRadius: 1.0,
                                                                        ),
                                                                      ],
                                                                      image: DecorationImage(
                                                                        image: imageProvider,
                                                                        fit: BoxFit.cover,
                                                                      ),
                                                                    ),
                                                                  ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    FloatingActionButton.extended(
                                                      heroTag: "GoToMapHero",
                                                      backgroundColor: Colors.orange,
                                                      label: Row(
                                                        children: [
                                                          CustomText(
                                                            text: "Location",
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.only(left: 5.0),
                                                            child: Icon(Icons.location_on),
                                                          ),
                                                        ],
                                                      ),
                                                      onPressed: () {
                                                        var location = data.userLocation.split(",");
                                                        LatLng point = new LatLng(double.parse(location[0]), double.parse(location[1]));
                                                        Provider.of<ProviderMapPageProvider>(context, listen: false).moveToLocation(point,zoom: 12.0);
                                                        Navigator.of(context).pop();
                                                        final FancyBottomNavigationState fState = Provider.of<ProviderPageProvider>(context, listen: false).bottomNavigationKey.currentState;
                                                        fState.setPage(0);
                                                      },
                                                    ),
                                                    FloatingActionButton.extended(
                                                      heroTag: "CompleteOrderHero",
                                                      backgroundColor: Colors.orange,
                                                      label: Row(
                                                        children: [
                                                          CustomText(
                                                            text: "Complete",
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.only(left: 5.0),
                                                            child: Icon(Icons.delete_sweep_outlined),
                                                          ),
                                                        ],
                                                      ),
                                                      onPressed: () {
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
                                                              Navigator.of(context).pop();
                                                              CoolAlert.show(
                                                                context: context,
                                                                type: CoolAlertType.loading,
                                                                backgroundColor: Colors.orange,
                                                                title: "Confirming",
                                                                text: "Please Wait...",
                                                              );
                                                              bool result = await ProviderAPICall.completeOrder(data.orderId);
                                                              Provider.of<ProviderMapPageProvider>(context, listen: false).setMakersPlacesAll();
                                                              Navigator.of(context).pop();
                                                              if (result) {
                                                                CoolAlert.show(
                                                                    context: context,
                                                                    type: CoolAlertType.success,
                                                                    backgroundColor: Colors.orange,
                                                                    confirmBtnColor: Colors.orange,
                                                                    title: "Completed",
                                                                    confirmBtnTextStyle:
                                                                    GoogleFonts.roboto(
                                                                      color: Colors.white,
                                                                      fontSize: 15.0,
                                                                    ),
                                                                    onConfirmBtnTap: () async {
                                                                      Navigator.of(context).pop();
                                                                      Navigator.of(context).pop();
                                                                    });
                                                              }
                                                              else {
                                                                CoolAlert.show(
                                                                    context: context,
                                                                    type: CoolAlertType.error,
                                                                    backgroundColor: Colors.orange,
                                                                    confirmBtnColor: Colors.orange,
                                                                    title: "Error!! Try again later..",
                                                                    confirmBtnTextStyle:
                                                                    GoogleFonts.roboto(
                                                                      color: Colors.white,
                                                                      fontSize: 15.0,
                                                                    ),
                                                                    onConfirmBtnTap: () async {
                                                                      Navigator.of(context).pop();
                                                                    });
                                                              }
                                                            });
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                    return Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(top: 50.0,bottom: 50.0),
                                          child: SizedBox(
                                            height: 50.0,
                                            width: 50.0,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 5.0,
                                              valueColor:
                                              AlwaysStoppedAnimation<Color>(Colors.orange),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                          icon: Icon(Icons.arrow_drop_down_circle_outlined),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ):
            Center(
              child: CustomText(
                text: "You haven't any orders yet",
                color: Colors.black,
                size: 20.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}