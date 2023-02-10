import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nearmy/API/ProviderAPICall.dart';
import 'package:nearmy/model/Product.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../components/components.dart';
import 'package:provider/provider.dart';

class ProviderProductPageProvider with ChangeNotifier{
  Future<List<Product>> productData;

  bool loadingList = false;

  void getProviderProducts(int count){
    loadingList = true;
    Timer(Duration(seconds: count), () {
      productData = ProviderAPICall.getProviderProducts();
      loadingList = false;
      notifyListeners();
    });
  }
}

class ProviderProductPage extends StatefulWidget {

  @override
  _ProviderProductPageState createState() => _ProviderProductPageState();
}

class _ProviderProductPageState extends State<ProviderProductPage> {

  @override
  void initState() {
    Provider.of<ProviderProductPageProvider>(context, listen: false).getProviderProducts(2);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<String> getShopName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("CartProviderName");
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        Navigator.of(context).pop();
        return;
      },
      child: Scaffold(
        appBar: customAppBar(
          context: context,
          leadIcon: Icon(Icons.fastfood_sharp),
          titleText: "Products",
          action: "add-product",
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10.0,bottom: 10.0),
              child: Container(
                color: Colors.grey,
                width: double.infinity,
                height: 80.0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Center(
                    child: FutureBuilder(
                      future: getShopName(),
                      builder: (BuildContext context, AsyncSnapshot snapshot){
                        if(snapshot.hasData){
                          return CustomText(
                            text: snapshot.data,
                            size: 20.0,
                            space: 2.0,
                            color: Colors.black,
                          );
                        }
                        else{
                          return CustomText(
                            text: "",
                            size: 20.0,
                            space: 2.0,
                            color: Colors.black,
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0,right: 10.0),
                child: context.watch<ProviderProductPageProvider>().loadingList ?
                Center(
                  child: SizedBox(
                    height: 50.0,
                    width: 50.0,
                    child: CircularProgressIndicator(
                      strokeWidth: 5.0,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                    ),
                  ),
                ):
                FutureBuilder(
                  future: context.watch<ProviderProductPageProvider>().productData,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      if(snapshot.data.length > 0){
                        return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
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
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: CustomText(
                                                      lineCount: 2,
                                                      resize: true,
                                                      text: snapshot.data[index].name,
                                                      size: 20.0,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  CustomText(
                                                    text: "Rs " + snapshot.data[index].price.toString(),
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
                                      imageUrl: snapshot.data[index].imageUrl,
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
                                    icon: Icon(Icons.delete),
                                    color: Colors.orange,
                                    onPressed: () async {
                                      CoolAlert.show(
                                          context: context,
                                          type: CoolAlertType.confirm,
                                          backgroundColor: Colors.orange,
                                          confirmBtnColor: Colors.orange,
                                          title: "Confirm Delete",
                                          confirmBtnText: "Delete",
                                          confirmBtnTextStyle: GoogleFonts.roboto(
                                            color: Colors.white,
                                            fontSize: 15.0,
                                          ),
                                          onConfirmBtnTap: () async {
                                            Navigator.of(context).pop();
                                            CoolAlert.show(
                                              context: context,
                                              type: CoolAlertType.loading,
                                              backgroundColor: Colors.orange,
                                              title: "Delete",
                                              text: "Please Wait...",
                                            );
                                            bool result = await ProviderAPICall.deleteProviderProduct(snapshot.data[index].productId);
                                            Navigator.of(context).pop();
                                            if(result){
                                              Provider.of<ProviderProductPageProvider>(context,listen: false).getProviderProducts(1);
                                            }
                                            else{
                                              CoolAlert.show(
                                                  context: context,
                                                  type: CoolAlertType.error,
                                                  backgroundColor: Colors.orange,
                                                  confirmBtnColor: Colors.orange,
                                                  title: "Error!! Try again later..",
                                                  confirmBtnTextStyle: GoogleFonts.roboto(
                                                    color: Colors.white,
                                                    fontSize: 15.0,
                                                  ),
                                                  onConfirmBtnTap: () async {
                                                    Navigator.of(context).pop();
                                                  }
                                              );
                                            }
                                          }
                                      );
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }
                      else{
                        return Center(
                          child: CustomText(
                            text: "You haven't any products yet",
                            color: Colors.black,
                            size: 20.0,
                          ),
                        );
                      }
                    }
                    return Center(
                      child: SizedBox(
                        height: 50.0,
                        width: 50.0,
                        child: CircularProgressIndicator(
                          strokeWidth: 5.0,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
