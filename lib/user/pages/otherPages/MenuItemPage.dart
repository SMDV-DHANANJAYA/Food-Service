import 'package:cached_network_image/cached_network_image.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nearmy/API/UserAPICall.dart';
import 'package:nearmy/components/components.dart';
import 'package:nearmy/model/Product.dart';
import 'package:nearmy/provider/model/Provider.dart';
import 'package:nearmy/user/pages/mainNavPages/UserMapPage.dart';
import 'package:provider/provider.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'CartPage.dart';

class MenuItemPage extends StatefulWidget {
  final Providers shopDetail;

  MenuItemPage(this.shopDetail);

  @override
  _MenuItemPageState createState() => _MenuItemPageState();
}

class _MenuItemPageState extends State<MenuItemPage> {
  ScrollController _scrollControllerPage;
  bool lastStatus = true;
  double height = 300;

  void _scrollListener() {
    if (_isShrink != lastStatus) {
      setState(() {
        lastStatus = _isShrink;
      });
    }
  }

  bool get _isShrink {
    return _scrollControllerPage.hasClients &&
        _scrollControllerPage.offset > (height - kToolbarHeight);
  }

  setTopImageSize(BuildContext context) {
    setState(() {
      height = MediaQuery.of(context).size.height / 3;
    });
  }

  String calculateDistance() {
    var location = widget.shopDetail.location.split(",");
    double distance = Geolocator.distanceBetween(
        context.read<UserMapPageProvider>().getUserPosition.latitude,
        context.read<UserMapPageProvider>().getUserPosition.longitude,
        double.parse(location[0]),
        double.parse(location[1]));
    if (distance > 1000) {
      double km = distance / 1000;
      return km.toStringAsFixed(2) + " Km";
    } else {
      return distance.toStringAsFixed(2) + " m";
    }
  }

  void showMessage(BuildContext context, String message) {
    showToast(
      message,
      context: context,
      animation: _isShrink
          ? StyledToastAnimation.slideFromBottom
          : StyledToastAnimation.slideFromTop,
      reverseAnimation: _isShrink
          ? StyledToastAnimation.slideToBottomFade
          : StyledToastAnimation.slideToTopFade,
      position:
          _isShrink ? StyledToastPosition.bottom : StyledToastPosition.top,
      animDuration: Duration(seconds: 1),
      duration: Duration(seconds: 3),
      curve: Curves.elasticOut,
      reverseCurve: Curves.linear,
      backgroundColor: Colors.orange,
      fullWidth: true,
      dismissOtherToast: true,
      textStyle: GoogleFonts.roboto(
        color: Colors.white,
        fontSize: 15.0,
      ),
    );
  }

  @override
  void initState() {
    _scrollControllerPage = ScrollController()..addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _scrollControllerPage.removeListener(_scrollListener);
    _scrollControllerPage.dispose();
    super.dispose();
  }

  double calculateRateValue(String value){
    if(value != null){
      List<String> values = value.split("|");
      double rateValue = double.parse(values[0]) / double.parse(values[1]);
      return rateValue;
    }
    else{
      return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    setTopImageSize(context);
    return Scaffold(
      body: NestedScrollView(
        controller: _scrollControllerPage,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: height,
              backgroundColor: Colors.transparent,
              actions: [
                IconButton(
                  icon: Icon(Icons.more_vert),
                  onPressed: () {},
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Hero(
                  tag: "MenuPageHero${widget.shopDetail.providerId}",
                  child: CachedNetworkImage(
                    imageUrl: widget.shopDetail.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.transparent,
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
            ),
          ];
        },
        body: Padding(
          padding: EdgeInsets.only(top: _isShrink ? 38.0 : 15.0),
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CustomText(
                            text: widget.shopDetail.name,
                            color: Colors.black,
                            size: 35.0,
                            resize: true,
                            lineCount: 1,
                          ),
                        ),
                        FloatingActionButton(
                          mini: true,
                          backgroundColor: Colors.orange,
                          child: Icon(Icons.star_border),
                          onPressed: () async {
                            showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (context) {
                                  return RatingDialog(
                                    icon: Image.asset("assets/icon/flash.png", width: 100, height: 100),
                                    title: "Rate Us (Nearmy)",
                                    description: "Tap a star to set your rating",
                                    submitButton: "SUBMIT",
                                    positiveComment: "We are so happy to hear :)",
                                    negativeComment: "We're sad to hear :(",
                                    accentColor: Colors.orange,
                                    onSubmitPressed: (int rating) {
                                      UserAPICall.submitRate(widget.shopDetail.providerId,rating);
                                    },
                                  );
                                });
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 8.0, left: 15.0, right: 15.0),
                    child: Row(
                      children: [
                        RatingBarIndicator(
                          rating: calculateRateValue(widget.shopDetail.rate),
                          unratedColor: Colors.black,
                          itemBuilder: (context, index) => Icon(
                            Icons.star,
                            color: Colors.orange,
                          ),
                          itemCount: 5,
                          itemSize: 25.0,
                          direction: Axis.horizontal,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 50.0),
                          child: CustomText(
                            text: calculateDistance(),
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0, left: 15.0, right: 15.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomText(
                            text: widget.shopDetail.address,
                            color: Colors.black,
                            resize: true,
                            lineCount: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: _isShrink,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Divider(
                        color: Colors.orange,
                        height: 0,
                        thickness: 5,
                      ),
                    ),
                  ),
                  Expanded(
                    child: FutureBuilder(
                      future: UserAPICall.getProductsData(
                          widget.shopDetail.providerId),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          return Padding(
                            padding:
                                const EdgeInsets.only(left: 15.0, right: 10.0),
                            child: ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (BuildContext context, int index) {
                                var data = snapshot.data[index] as Product;
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 10.0),
                                          child: Container(
                                            height: 80,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        child: CustomText(
                                                          lineCount: 2,
                                                          resize: true,
                                                          text: data.name,
                                                          size: 20.0,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      CustomText(
                                                        text: "Rs " +
                                                            data.price
                                                                .toString(),
                                                        color: Colors.black,
                                                      ),
                                                    ],
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
                                      IconButton(
                                        icon: Icon(Icons.add_shopping_cart),
                                        color: Colors.orange,
                                        onPressed: () async {
                                          SharedPreferences prefs = await SharedPreferences.getInstance();
                                          if (prefs.getBool("userAccountLogin") != null && prefs.getBool("userAccountLogin")) {
                                            context.read<CartProvider>().addToCart(data, widget.shopDetail.name);
                                            showMessage(context, data.name + " add to cart");
                                          }
                                          else {
                                            CoolAlert.show(
                                              context: context,
                                              type: CoolAlertType.info,
                                              backgroundColor: Colors.orange,
                                              confirmBtnColor: Colors.orange,
                                              title: "Please Log Into Your Nearmy Account to Order Products",
                                              confirmBtnTextStyle: GoogleFonts.roboto(
                                                color: Colors.white,
                                                fontSize: 15.0,
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
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
                ],
              ),
              Visibility(
                visible: !_isShrink,
                maintainAnimation: true,
                maintainState: true,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, bottom: 15.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: FloatingActionButton.extended(
                      heroTag: "ProfileWaveHero",
                      backgroundColor: Colors.orange,
                      label: Row(
                        children: [
                          CustomText(
                            text: "Wave Us",
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: Icon(Icons.accessibility),
                          ),
                        ],
                      ),
                      onPressed: () {
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
                              Navigator.of(context).pop();
                              CoolAlert.show(
                                context: context,
                                type: CoolAlertType.loading,
                                backgroundColor: Colors.orange,
                                title: "Wave",
                                text: "Please Wait...",
                              );
                              Position userPosition =
                                  Provider.of<UserMapPageProvider>(context,
                                          listen: false)
                                      .getUserPosition;
                              if (userPosition.latitude != null &&
                                  userPosition.longitude != null) {
                                bool result = await UserAPICall.waveToProvider(
                                    widget.shopDetail.providerId, userPosition);
                                Navigator.of(context).pop();
                                if (result) {
                                  CoolAlert.show(
                                      context: context,
                                      type: CoolAlertType.success,
                                      backgroundColor: Colors.orange,
                                      confirmBtnColor: Colors.orange,
                                      title: "Wave Completed",
                                      confirmBtnTextStyle:
                                          GoogleFonts.roboto(
                                        color: Colors.white,
                                        fontSize: 15.0,
                                      ),
                                      onConfirmBtnTap: () async {
                                        Navigator.of(context).pop();
                                      });
                                } else {
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
                              } else {
                                CoolAlert.show(
                                    context: context,
                                    type: CoolAlertType.error,
                                    backgroundColor: Colors.orange,
                                    confirmBtnColor: Colors.orange,
                                    title: "location Error!! Try again later..",
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
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Visibility(
        visible:
            !_isShrink && context.watch<CartProvider>().getUserCart.length > 0,
        maintainAnimation: true,
        maintainState: true,
        child: FloatingActionButton(
          heroTag: "CartFloatingBtn",
          backgroundColor: Colors.orange,
          child: Icon(Icons.shopping_cart),
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            if (prefs.getBool("userAccountLogin") != null &&
                prefs.getBool("userAccountLogin")) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => CartPage()));
            } else {
              CoolAlert.show(
                context: context,
                type: CoolAlertType.info,
                backgroundColor: Colors.orange,
                confirmBtnColor: Colors.orange,
                title: "Please Log Into Your NearMy Account",
                confirmBtnTextStyle: GoogleFonts.roboto(
                  color: Colors.white,
                  fontSize: 15.0,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
