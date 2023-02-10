import 'package:cool_alert/cool_alert.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nearmy/API/UserAPICall.dart';
import 'package:nearmy/components/components.dart';
import 'package:nearmy/user/model/User.dart';
import 'package:nearmy/user/pages/otherPages/UserSignUpPage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserLogInPageProvider extends ChangeNotifier{
  bool _isHidePassword = true;

  bool _isUserLoginToAccount = false;

  bool get isUserLoginToAccount => _isUserLoginToAccount;

  bool get getShowPasswordState => _isHidePassword;

  void setIsUserLoginToAccount(bool value){
    _isUserLoginToAccount = value;
    notifyListeners();
  }

  void setShowPasswordState(){
    _isHidePassword = !_isHidePassword;
    notifyListeners();
  }
}

class UserLogInPage extends StatefulWidget {

  @override
  _UserLogInPageState createState() => _UserLogInPageState();
}

class _UserLogInPageState extends State<UserLogInPage> {
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
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Center(
                child: Image.asset(
                  "assets/icon/flash.png",
                  width: 200.0,
                  height: 200.0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
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
                          obscureText: context.watch<UserLogInPageProvider>().getShowPasswordState,
                          style: GoogleFonts.roboto(),
                          decoration: InputDecoration(
                            hintText: "Password",
                            hintStyle: GoogleFonts.roboto(),
                            fillColor: Colors.orange,
                            filled: true,
                            prefixIcon: Icon(Icons.vpn_key,color: Colors.black,),
                            suffixIcon: IconButton(
                              icon: Icon(context.watch<UserLogInPageProvider>().getShowPasswordState ? Icons.visibility_off : Icons.visibility),
                              color: Colors.black,
                              onPressed: (){
                                context.read<UserLogInPageProvider>().setShowPasswordState();
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
                    if(emailController.value.text != ""){
                      if(EmailValidator.validate(emailController.value.text)){
                        if(passwordController.value.text != ""){
                          User user = new User(email: emailController.value.text,password: passwordController.value.text);
                          CoolAlert.show(
                            context: context,
                            type: CoolAlertType.loading,
                            backgroundColor: Colors.orange,
                            title: "Login",
                            text: "Please Wait...",
                          );
                          int result = await UserAPICall.loginUser(user);
                          Navigator.of(context).pop();
                          if(result == 0){
                            CoolAlert.show(
                              context: context,
                              type: CoolAlertType.error,
                              backgroundColor: Colors.orange,
                              confirmBtnColor: Colors.orange,
                              title: "Wrong Username or Password",
                              confirmBtnTextStyle: GoogleFonts.roboto(
                                color: Colors.white,
                                fontSize: 15.0,
                              ),
                            );
                          }
                          else{
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            prefs.setBool("userAccountLogin", true);
                            prefs.setInt("userProfileId", result);
                            context.read<UserLogInPageProvider>().setIsUserLoginToAccount(true);
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
                  },
                  child: Container(
                    width: 130.0,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: CustomText(
                          text: "Log In",
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
              padding: const EdgeInsets.only(top: 50.0),
              child: Center(
                child: GestureDetector(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => UserSignUpPage())
                    );
                  },
                  child: CustomText(
                    text: "Create an account",
                    color: Colors.orange,
                    size: 20.0,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
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
    );
  }
}