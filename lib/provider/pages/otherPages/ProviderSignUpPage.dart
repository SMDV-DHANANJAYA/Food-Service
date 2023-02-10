import 'dart:io';

import 'package:cool_alert/cool_alert.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nearmy/API/ProviderAPICall.dart';
import 'package:nearmy/components/components.dart';
import 'package:nearmy/provider/model/Provider.dart';
import 'package:nearmy/provider/pages/mainNavPages/ProviderMapPage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../ProviderPage.dart';

class ProviderSignUpPageProvider extends ChangeNotifier{
  File _image;
  bool _isSelectImage = false;
  bool _isHidePassword = true;

  String _selectedType = "";

  File get getSelectedImage => _image;

  bool get isSelectImage => _isSelectImage;

  bool get getShowPasswordState => _isHidePassword;

  String get getSelectedType => _selectedType;

  void setSelectedType(String type){
    _selectedType = type;
    notifyListeners();
  }

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

  void setShowPasswordState(){
    _isHidePassword = !_isHidePassword;
    notifyListeners();
  }

  void setIsSelectedImage(bool value){
    _isSelectImage = value;
    notifyListeners();
  }
}

class ProviderSignUpPage extends StatefulWidget {

  @override
  _ProviderSignUpPageState createState() => _ProviderSignUpPageState();
}

class _ProviderSignUpPageState extends State<ProviderSignUpPage> {

  @override
  void initState() {
    Provider.of<ProviderMapPageProvider>(context, listen: false).getProviderCurrentLocation();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  TextEditingController usernameController = new TextEditingController();

  TextEditingController emailController = new TextEditingController();

  TextEditingController addressController = new TextEditingController();

  TextEditingController passwordController = new TextEditingController();

  List<String> _types = ['Choon Paan', 'Milk & Dairy', 'Fruit & Vegetables', 'Home Made Food', 'Restaurants' , 'Fish & Meat', 'Handcrafts & Stationary', 'Other'];

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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        Provider.of<ProviderSignUpPageProvider>(context,listen: false).setIsSelectedImage(false);
        Provider.of<ProviderSignUpPageProvider>(context,listen: false).setImageNull();
        Provider.of<ProviderSignUpPageProvider>(context,listen: false).setSelectedType("");
        Navigator.of(context).pop();
        return;
      },
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Center(
                    child: Container(
                      width: 160.0,
                      height: 160.0,
                      decoration: new BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: GestureDetector(
                          onTap: (){
                            context.read<ProviderSignUpPageProvider>().getImage();
                          },
                          child: Container(
                            width: 150.0,
                            height: 150.0,
                            decoration: new BoxDecoration(
                                color: Colors.orange,
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: !context.watch<ProviderSignUpPageProvider>().isSelectImage ? AssetImage("assets/common/account_image.png") : FileImage(context.watch<ProviderSignUpPageProvider>().getSelectedImage),
                                    fit: BoxFit.cover
                                )
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  right: 0.0,
                                  top: 0.0,
                                  child: IconButton(
                                    icon: Icon(Icons.add_circle_outline),
                                    color: Colors.black,
                                    onPressed: (){
                                      context.read<ProviderSignUpPageProvider>().getImage();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 35.0),
                  child: Center(
                    child: CustomText(
                      text: "Hey There",
                      color: Colors.orange,
                      size: 30.0,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: [
                          TextField(
                            controller: usernameController,
                            cursorColor: Colors.black,
                            textCapitalization: TextCapitalization.words,
                            style: GoogleFonts.roboto(),
                            decoration: InputDecoration(
                              hintText: "User Name",
                                hintStyle: GoogleFonts.roboto(),
                                fillColor: Colors.orange,
                                filled: true,
                                prefixIcon: Icon(Icons.account_circle,color: Colors.black,),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: TextField(
                              controller: emailController,
                              cursorColor: Colors.black,
                              style: GoogleFonts.roboto(),
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                hintText: "Email",
                                hintStyle: GoogleFonts.roboto(),
                                  fillColor: Colors.orange,
                                  filled: true,
                                  prefixIcon: Icon(Icons.alternate_email,color: Colors.black,),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: GestureDetector(
                              onTap: (){
                                FocusScope.of(context).unfocus();
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        backgroundColor: Colors.orange,
                                        title: Center(child: CustomText(text: 'Select seller type',color: Colors.black,)),
                                        content: SingleChildScrollView(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              for ( var i in _types ) CheckboxListTile(
                                                title: CustomText(text: i,color: Colors.black,),
                                                checkColor: Colors.orange,
                                                activeColor: Colors.black,
                                                value: context.watch<ProviderSignUpPageProvider>().getSelectedType == i,
                                                onChanged: (newValue) {
                                                  if(newValue){
                                                    context.read<ProviderSignUpPageProvider>().setSelectedType(i);
                                                  }
                                                  else{
                                                    context.read<ProviderSignUpPageProvider>().setSelectedType("");
                                                  }
                                                },
                                                controlAffinity: ListTileControlAffinity.leading,
                                              )
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          Center(
                                            child: FlatButton(
                                              child: CustomText(text: 'Done',color: Colors.black,),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          )
                                        ],
                                      );
                                    }
                                    );
                              },
                              child: TextField(
                                enabled: false,
                                decoration: InputDecoration(
                                  hintText: context.read<ProviderSignUpPageProvider>().getSelectedType == "" ? "Please choose seller type" : context.read<ProviderSignUpPageProvider>().getSelectedType,
                                  hintStyle: GoogleFonts.roboto(
                                    color: context.read<ProviderSignUpPageProvider>().getSelectedType == "" ? Colors.black54 : Colors.black,
                                  ),
                                  fillColor: Colors.orange,
                                  filled: true,
                                  prefixIcon: Icon(Icons.settings,color: Colors.black,),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: TextField(
                              controller: addressController,
                              cursorColor: Colors.black,
                              textCapitalization: TextCapitalization.words,
                              style: GoogleFonts.roboto(),
                              decoration: InputDecoration(
                                hintText: "Address",
                                hintStyle: GoogleFonts.roboto(),
                                fillColor: Colors.orange,
                                filled: true,
                                prefixIcon: Icon(Icons.email_outlined,color: Colors.black,),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: TextField(
                              controller: passwordController,
                              cursorColor: Colors.black,
                              obscureText: context.watch<ProviderSignUpPageProvider>().getShowPasswordState,
                              style: GoogleFonts.roboto(),
                              decoration: InputDecoration(
                                  hintText: "Password",
                                  hintStyle: GoogleFonts.roboto(),
                                fillColor: Colors.orange,
                                filled: true,
                                prefixIcon: Icon(Icons.vpn_key,color: Colors.black,),
                                suffixIcon: IconButton(
                                  icon: Icon(context.watch<ProviderSignUpPageProvider>().getShowPasswordState ? Icons.visibility_off : Icons.visibility),
                                  color: Colors.black,
                                  onPressed: (){
                                    context.read<ProviderSignUpPageProvider>().setShowPasswordState();
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 35.0),
                  child: Center(
                    child: GestureDetector(
                      onTap: () async {
                        if(Provider.of<ProviderSignUpPageProvider>(context,listen: false).getSelectedImage != null){
                          if(usernameController.value.text != ""){
                            if(emailController.value.text != ""){
                              if(EmailValidator.validate(emailController.value.text)){
                                if(Provider.of<ProviderSignUpPageProvider>(context,listen: false).getSelectedType != ""){
                                  if(addressController.value.text != ""){
                                    if(passwordController.value.text != ""){
                                      String imagePath = Provider.of<ProviderSignUpPageProvider>(context,listen: false).getSelectedImage.path;
                                      Position providerPositionTemp = context.read<ProviderMapPageProvider>().getProviderPosition;
                                      String providerPosition = providerPositionTemp.latitude.toString() + "," + providerPositionTemp.longitude.toString();
                                      int type = _types.indexOf(Provider.of<ProviderSignUpPageProvider>(context,listen: false).getSelectedType) + 1;
                                      Providers provider = new Providers(name: usernameController.value.text,email: emailController.value.text,category: type,rate: "0|0",location: providerPosition,address: addressController.value.text,imageUrl: imagePath,state: 1,password: passwordController.value.text);
                                      CoolAlert.show(
                                        context: context,
                                        type: CoolAlertType.loading,
                                        backgroundColor: Colors.orange,
                                        title: "Creating New Account",
                                        text: "Please Wait...",
                                      );
                                      int result = await ProviderAPICall.createProvider(provider);
                                      Navigator.of(context).pop();
                                      if(result == 0){
                                        CoolAlert.show(
                                          context: context,
                                          type: CoolAlertType.error,
                                          backgroundColor: Colors.orange,
                                          confirmBtnColor: Colors.orange,
                                          title: "This Email Already Use!",
                                          confirmBtnTextStyle: GoogleFonts.roboto(
                                            color: Colors.white,
                                            fontSize: 15.0,
                                          ),
                                        );
                                      }
                                      else if(result == 1){
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
                                      else{
                                        CoolAlert.show(
                                            context: context,
                                            type: CoolAlertType.success,
                                            backgroundColor: Colors.orange,
                                            confirmBtnColor: Colors.orange,
                                            title: "Created Account Successfully",
                                            confirmBtnTextStyle: GoogleFonts.roboto(
                                              color: Colors.white,
                                              fontSize: 15.0,
                                            ),
                                            onConfirmBtnTap: () async {
                                              context.read<ProviderSignUpPageProvider>().setIsSelectedImage(false);
                                              Provider.of<ProviderSignUpPageProvider>(context,listen: false).setImageNull();
                                              Provider.of<ProviderSignUpPageProvider>(context,listen: false).setSelectedType("");
                                              Navigator.of(context).pop();
                                              SharedPreferences prefs = await SharedPreferences.getInstance();
                                              prefs.setBool("providerAccountLogin", true);
                                              prefs.setInt("providerProfileId", result);
                                              Navigator.of(context).push(MaterialPageRoute(
                                                  builder: (BuildContext context) => ProviderPage())
                                              );
                                            }
                                        );
                                      }
                                    }
                                    else{
                                      showAlert(context, "Please Input Password");
                                    }
                                  }
                                  else{
                                    showAlert(context, "Please Input Address");
                                  }
                                }
                                else{
                                  showAlert(context, "Please Select Seller Type");
                                }
                              }
                              else{
                                showAlert(context, "Please Input Correct Email Address");
                              }
                            }
                            else{
                              showAlert(context, "Please Input Email Address");
                            }
                          }
                          else{
                            showAlert(context, "Please Input User Name");
                          }
                        }
                        else{
                          showAlert(context, "Please Select an image");
                        }
                      },
                      child: Container(
                        width: 130.0,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                            child: CustomText(
                              text: "Sign Up",
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
                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/icon/flash.png",
                          height: 70.0,
                          width: 70.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Column(
                            children: [
                              CustomText(
                                text: "Powerd By",
                                color: Colors.orange,
                                size: 18.0,
                              ),
                              CustomText(
                                text: "NearMy",
                                color: Colors.black,
                                size: 18.0,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
