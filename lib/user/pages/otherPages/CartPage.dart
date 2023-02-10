import 'package:cached_network_image/cached_network_image.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nearmy/API/UserAPICall.dart';
import 'package:nearmy/components/components.dart';
import 'package:nearmy/model/Product.dart';
import 'package:nearmy/user/pages/mainNavPages/UserMapPage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider extends ChangeNotifier{

  static double _fullCount = 0;

  static List<Product> _userCartItems = [];

  List<Product> get getUserCart => _userCartItems;

  double get getFullCount => _fullCount;

  void addItem(Product item){
    Product product = new Product(productId: item.productId,name: item.name,price: item.price,quantity: 1,imageUrl: item.imageUrl,providerId: item.providerId);
    _userCartItems.add(product);
  }

  void addToCart(Product item,name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(_userCartItems.isNotEmpty && (_userCartItems[0].providerId == item.providerId)){
      bool isExistingInCart = false;
      _userCartItems.forEach((product) {
        if(product.productId == item.productId){
          product.quantity = product.quantity + 1;
          isExistingInCart = true;
        }
      });
      if(!isExistingInCart){
        addItem(item);
      }
    }
    else{
      prefs.setString("CartShopName", name);
      _userCartItems.clear();
      addItem(item);
    }
    notifyListeners();
  }

  void removeFromQuantity(int index){
    if(_userCartItems[index].quantity != 1){
      _userCartItems[index].quantity = _userCartItems[index].quantity - 1;
      calculateFullCount();
      notifyListeners();
    }
  }

  void addToQuantity(int index){
    _userCartItems[index].quantity = _userCartItems[index].quantity + 1;
    notifyListeners();
    calculateFullCount();
  }

  bool removeFromCart(int index){
    _userCartItems.removeAt(index);
    notifyListeners();
    if(_userCartItems.length > 0){
      calculateFullCount();
      return true;
    }
    else{
      return false;
    }
  }

  void emptyCart() async {
    _userCartItems.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("CartShopName");
    notifyListeners();
  }

  void calculateFullCount(){
    _fullCount = 0;
    _userCartItems.forEach((product) {
      _fullCount = _fullCount + (product.price * product.quantity);
    });
  }
}

class CartPage extends StatefulWidget {

  const CartPage();

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  @override
  void initState() {
    context.read<CartProvider>().calculateFullCount();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<String> getShopName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("CartShopName");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        context: context,
        leadIcon: Icon(Icons.shopping_cart),
        titleText: "Cart",
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
              child: ListView.builder(
                itemCount: context.watch<CartProvider>().getUserCart.length,
                itemBuilder: (BuildContext context, int index){
                  var data = context.watch<CartProvider>().getUserCart[index];
                  return Padding(
                    padding: const EdgeInsets.only(top: 5.0,bottom: 5.0),
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
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          CustomText(
                                            text: data.name,
                                            size: 20.0,
                                            color: Colors.black,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 8.0),
                                            child: Row(
                                              children: [
                                                CustomText(
                                                  text: "Rs " + data.price.toString(),
                                                  color: Colors.black,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        GestureDetector(
                                          child: Icon(Icons.keyboard_arrow_up),
                                          onTap: (){
                                            context.read<CartProvider>().addToQuantity(index);
                                          },
                                        ),
                                        CustomText(
                                          text: "Qty " + data.quantity.toString(),
                                          color: Colors.black,
                                        ),
                                        Visibility(
                                          visible: data.quantity > 1,
                                          maintainAnimation: true,
                                          maintainState: true,
                                          child: GestureDetector(
                                            child: Icon(Icons.keyboard_arrow_down),
                                            onTap: (){
                                              context.read<CartProvider>().removeFromQuantity(index);
                                            },
                                          ),
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
                            placeholder: (context, url) => Container(color: Colors.transparent,),
                            errorWidget: (context, url, error) => Icon(Icons.error),
                            imageBuilder: (context, imageProvider) => Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
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
                          icon: Icon(Icons.delete_outline_rounded),
                          color: Colors.orange,
                          onPressed: () async {
                            bool value = context.read<CartProvider>().removeFromCart(index);
                            if(!value) {
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              prefs.remove("CartShopName");
                              Navigator.of(context).pop();
                            }
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height / 9,
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0),topRight: Radius.circular(25.0)),
        ),
        child: Stack(
          children: [
            Center(
              child: CustomText(
                text: "Rs " + context.watch<CartProvider>().getFullCount.toString() + " /=",
                size: 30.0,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: IconButton(
                  icon: Icon(Icons.send),
                  color: Colors.white,
                  iconSize: 30.0,
                  onPressed: (){
                    CoolAlert.show(
                      context: context,
                      type: CoolAlertType.confirm,
                      backgroundColor: Colors.orange,
                      confirmBtnColor: Colors.orange,
                      title: "Confirm Your Order",
                      confirmBtnText: "Order",
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
                          title: "Order",
                          text: "Please Wait...",
                        );
                        bool result = await UserAPICall.submitOrder(context.read<CartProvider>().getUserCart,Provider.of<CartProvider>(context,listen: false).getFullCount,context.read<UserMapPageProvider>().getUserPosition);
                        Navigator.of(context).pop();
                        if(result){
                          CoolAlert.show(
                            context: context,
                            type: CoolAlertType.success,
                            backgroundColor: Colors.orange,
                            confirmBtnColor: Colors.orange,
                            title: "Order Completed",
                            confirmBtnTextStyle: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: 15.0,
                            ),
                            onConfirmBtnTap: () async {
                              Navigator.of(context).pop();
                              context.read<CartProvider>().emptyCart();
                              Navigator.of(context).pop();
                            }
                          );
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
