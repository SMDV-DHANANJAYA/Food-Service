import 'dart:io';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nearmy/API/ProviderAPICall.dart';
import 'package:nearmy/components/components.dart';
import 'package:nearmy/model/Product.dart';
import 'package:nearmy/provider/pages/otherPages/ProviderProductPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

class ProviderAddProductPageProvider extends ChangeNotifier{
  File _image;
  bool _isSelectImage = false;

  File get getSelectedImage => _image;

  bool get isSelectImage => _isSelectImage;

  Future getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      _isSelectImage = true;
      notifyListeners();
    }
    else {
      print('No image selected.');
    }
  }

  void setImageNull(){
    _image = null;
    notifyListeners();
  }

  void setIsSelectedImage(bool value){
    _isSelectImage = value;
    notifyListeners();
  }
}

class ProviderAddProductPage extends StatefulWidget {

  @override
  _ProviderAddProductPageState createState() => _ProviderAddProductPageState();
}

class _ProviderAddProductPageState extends State<ProviderAddProductPage> {
  TextEditingController nameController = new TextEditingController();

  TextEditingController priceController = new TextEditingController();

  TextEditingController quantityController = new TextEditingController();

  void showAlert(BuildContext context,String message){
    CoolAlert.show(
      context: context,
      type: CoolAlertType.error,
      backgroundColor: Colors.orange,
      confirmBtnColor: Colors.orange,
      title: message,
      confirmBtnTextStyle: GoogleFonts.roboto(
        color: Colors.white,
        fontSize: 15.0,
      ),
    );
  }

  Future<String> getShopName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("CartProviderName");
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        Provider.of<ProviderProductPageProvider>(context,listen: false).getProviderProducts(1);
        Provider.of<ProviderAddProductPageProvider>(context,listen: false).setIsSelectedImage(false);
        Provider.of<ProviderAddProductPageProvider>(context,listen: false).setImageNull();
        Navigator.of(context).pop();
        return;
      },
      child: Scaffold(
        appBar: customAppBar(
          context: context,
          leadIcon: Icon(Icons.fastfood_sharp),
          titleText: "Add Products",
        ),
        body: SingleChildScrollView(
          child: Column(
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
              Column(
                children: [
                  GestureDetector(
                    onTap: (){
                      context.read<ProviderAddProductPageProvider>().getImage();
                    },
                    child: !context.watch<ProviderAddProductPageProvider>().isSelectImage ?
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(
                                text: "Add Product Image",
                                color: Colors.black,
                                size: 18.0,
                              ),
                              CustomText(
                                text: "+",
                                color: Colors.black,
                                size: 18.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ):
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 150.0,
                      decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: FileImage(context.watch<ProviderAddProductPageProvider>().getSelectedImage),
                              fit: BoxFit.cover
                          )
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: [
                          TextField(
                            controller: nameController,
                            cursorColor: Colors.black,
                            textCapitalization: TextCapitalization.words,
                            style: GoogleFonts.roboto(),
                            decoration: InputDecoration(
                              hintText: "Product Name",
                              hintStyle: GoogleFonts.roboto(),
                              fillColor: Colors.orange,
                              filled: true,
                              prefixIcon: Icon(Icons.pages_rounded,color: Colors.black,),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: TextField(
                              controller: priceController,
                              cursorColor: Colors.black,
                              style: GoogleFonts.roboto(),
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: "Product Price",
                                hintStyle: GoogleFonts.roboto(),
                                fillColor: Colors.orange,
                                filled: true,
                                prefixIcon: Icon(Icons.monetization_on_outlined,color: Colors.black,),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: TextField(
                              controller: quantityController,
                              cursorColor: Colors.black,
                              keyboardType: TextInputType.number,
                              style: GoogleFonts.roboto(),
                              decoration: InputDecoration(
                                hintText: "Product Quantity",
                                hintStyle: GoogleFonts.roboto(),
                                fillColor: Colors.orange,
                                filled: true,
                                prefixIcon: Icon(Icons.account_balance_wallet,color: Colors.black,),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 35.0),
                    child: Center(
                      child: GestureDetector(
                        onTap: () async {
                          if(Provider.of<ProviderAddProductPageProvider>(context,listen: false).getSelectedImage != null){
                            if(nameController.value.text != ""){
                              if(priceController.value.text != ""){
                                if(quantityController.value.text != ""){
                                  String imagePath = Provider.of<ProviderAddProductPageProvider>(context,listen: false).getSelectedImage.path;
                                  int id = await CustomData.getProviderId();
                                  Product product = new Product(name: nameController.value.text,price: double.parse(priceController.value.text),quantity: int.parse(quantityController.value.text),imageUrl: imagePath,providerId: id);
                                  CoolAlert.show(
                                    context: context,
                                    type: CoolAlertType.loading,
                                    backgroundColor: Colors.orange,
                                    title: "Inserting New Products",
                                    text: "Please Wait...",
                                  );
                                  bool result = await ProviderAPICall.addProviderNewProduct(product);
                                  Navigator.of(context).pop();
                                  if(result){
                                    CoolAlert.show(
                                        context: context,
                                        type: CoolAlertType.confirm,
                                        backgroundColor: Colors.orange,
                                        confirmBtnColor: Colors.orange,
                                        title: "Add More Products?",
                                        confirmBtnText: "Add More",
                                        confirmBtnTextStyle: GoogleFonts.roboto(
                                          color: Colors.white,
                                          fontSize: 15.0,
                                        ),
                                        cancelBtnText: "Back",
                                        cancelBtnTextStyle: GoogleFonts.roboto(
                                          color: Colors.black,
                                          fontSize: 15.0,
                                        ),
                                        onCancelBtnTap: (){
                                          Provider.of<ProviderProductPageProvider>(context,listen: false).getProviderProducts(1);
                                          context.read<ProviderAddProductPageProvider>().setIsSelectedImage(false);
                                          Provider.of<ProviderAddProductPageProvider>(context,listen: false).setImageNull();
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                        },
                                        onConfirmBtnTap: () async {
                                          context.read<ProviderAddProductPageProvider>().setIsSelectedImage(false);
                                          Provider.of<ProviderAddProductPageProvider>(context,listen: false).setImageNull();
                                          nameController.clear();
                                          priceController.clear();
                                          quantityController.clear();
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
                                      title: "Try Again Later",
                                      confirmBtnTextStyle: GoogleFonts.roboto(
                                        color: Colors.white,
                                        fontSize: 15.0,
                                      ),
                                    );
                                  }
                                }
                                else{
                                  showAlert(context, "Please Input Product Quantity");
                                }
                              }
                              else{
                                showAlert(context, "Please Input Product Price");
                              }
                            }
                            else{
                              showAlert(context, "Please Input Product Name");
                            }
                          }
                          else{
                            showAlert(context, "Please Select an image");
                          }
                        },
                        child: Container(
                          width: 150.0,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15.0),
                              child: CustomText(
                                text: "Add Product",
                                color: Colors.black,
                                size: 20.0,
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
