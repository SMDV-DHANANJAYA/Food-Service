import 'dart:io';

import 'package:cool_alert/cool_alert.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nearmy/API/UserAPICall.dart';
import 'package:nearmy/components/components.dart';
import 'package:nearmy/user/model/User.dart';
import 'package:nearmy/user/pages/mainNavPages/UserLogInPage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSignUpPageProvider extends ChangeNotifier{
  File _image;
  bool _isSelectImage = false;
  bool _isHidePassword = true;

  File get getSelectedImage => _image;

  bool get isSelectImage => _isSelectImage;

  bool get getShowPasswordState => _isHidePassword;

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

class UserSignUpPage extends StatefulWidget {

  @override
  _UserSignUpPageState createState() => _UserSignUpPageState();
}

class _UserSignUpPageState extends State<UserSignUpPage> {
  TextEditingController usernameController = new TextEditingController();

  TextEditingController emailController = new TextEditingController();

  TextEditingController passwordController = new TextEditingController();

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
        Provider.of<UserSignUpPageProvider>(context,listen: false).setIsSelectedImage(false);
        Provider.of<UserSignUpPageProvider>(context,listen: false).setImageNull();
        Navigator.of(context).pop();
        return;
      },
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
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
                          context.read<UserSignUpPageProvider>().getImage();
                        },
                        child: Container(
                          width: 150.0,
                          height: 150.0,
                          decoration: new BoxDecoration(
                              color: Colors.orange,
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: !context.watch<UserSignUpPageProvider>().isSelectImage ? AssetImage("assets/common/account_image.png") : FileImage(context.watch<UserSignUpPageProvider>().getSelectedImage),
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
                                    context.read<UserSignUpPageProvider>().getImage();
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
                            child: TextField(
                              controller: passwordController,
                              cursorColor: Colors.black,
                              obscureText: context.watch<UserSignUpPageProvider>().getShowPasswordState,
                              style: GoogleFonts.roboto(),
                              decoration: InputDecoration(
                                  hintText: "Password",
                                  hintStyle: GoogleFonts.roboto(),
                                fillColor: Colors.orange,
                                filled: true,
                                prefixIcon: Icon(Icons.vpn_key,color: Colors.black,),
                                suffixIcon: IconButton(
                                  icon: Icon(context.watch<UserSignUpPageProvider>().getShowPasswordState ? Icons.visibility_off : Icons.visibility),
                                  color: Colors.black,
                                  onPressed: (){
                                    context.read<UserSignUpPageProvider>().setShowPasswordState();
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
                        if(Provider.of<UserSignUpPageProvider>(context,listen: false).getSelectedImage != null){
                          if(usernameController.value.text != ""){
                            if(emailController.value.text != ""){
                              if(EmailValidator.validate(emailController.value.text)){
                                if(passwordController.value.text != ""){
                                  String imagePath = Provider.of<UserSignUpPageProvider>(context,listen: false).getSelectedImage.path;
                                  User user = new User(userName: usernameController.value.text,email: emailController.value.text,imageUrl: imagePath,password: passwordController.value.text);
                                  CoolAlert.show(
                                    context: context,
                                    type: CoolAlertType.loading,
                                    backgroundColor: Colors.orange,
                                    title: "Creating New Account",
                                    text: "Please Wait...",
                                  );
                                  int result = await UserAPICall.createUser(user);
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
                                          context.read<UserSignUpPageProvider>().setIsSelectedImage(false);
                                          Provider.of<UserSignUpPageProvider>(context,listen: false).setImageNull();
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                          SharedPreferences prefs = await SharedPreferences.getInstance();
                                          prefs.setBool("userAccountLogin", true);
                                          prefs.setInt("userProfileId", result);
                                          context.read<UserLogInPageProvider>().setIsUserLoginToAccount(true);
                                        }
                                    );
                                  }
                                }
                                else{
                                  showAlert(context, "Please Input Password");
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
