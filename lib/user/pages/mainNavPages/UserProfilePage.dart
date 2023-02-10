import 'package:cached_network_image/cached_network_image.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nearmy/API/UserAPICall.dart';
import 'package:nearmy/components/components.dart';
import 'package:nearmy/user/model/User.dart';
import 'package:nearmy/user/pages/otherPages/CartPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import 'UserLogInPage.dart';

class UserProfilePage extends StatelessWidget {

  const UserProfilePage();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder(
        future: UserAPICall.getUserData(),
        builder: (BuildContext context, AsyncSnapshot<User> snapshot){
          if(snapshot.hasData){
            return Column(
              children: [
                Expanded(
                  flex: 4,
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/common/profile-background.jpg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned.fill(
                        top: MediaQuery.of(context).size.height / 45,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            height: MediaQuery.of(context).size.height / 3.5,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.withOpacity(0.3),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(7.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey.withOpacity(0.6),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(7.0),
                                  child: CachedNetworkImage(
                                    imageUrl: snapshot.data.imageUrl,
                                    placeholder: (context, url) => Container(color: Colors.transparent,),
                                    errorWidget: (context, url, error) => Icon(Icons.error),
                                    imageBuilder: (context, imageProvider) => Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.3),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0,bottom: 10.0,left: 15.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text: snapshot.data.userName,
                                    size: 20.0,
                                  ),
                                  CustomText(
                                      text: snapshot.data.email
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        top: 50,
                        left: 15,
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Icon(
                            Icons.person_sharp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Positioned.fill(
                        top: 50,
                        left: MediaQuery.of(context).size.width - 35,
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Icon(
                            Icons.more_vert,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: ListView(
                      children: [
                        /*ListTile(
                          title: CustomText(
                            text: "Customize Profile",
                            color: Colors.black,
                          ),
                          trailing: Icon(Icons.settings,color: Colors.black,),
                          tileColor: Colors.white,
                        ),
                        SizedBox(
                          height: 20,
                        ),*/
                        /*ListTile(
                          title: CustomText(
                            text: "Order History",
                            color: Colors.black,
                          ),
                          trailing: Icon(Icons.timelapse,color: Colors.black,),
                          tileColor: Colors.white,
                        ),
                        SizedBox(
                          height: 20,
                        ),*/
                        ListTile(
                          title: CustomText(
                            text: "My Cart",
                            color: Colors.black,
                          ),
                          trailing: Icon(Icons.shopping_cart,color: Colors.black,),
                          tileColor: Colors.white,
                          onTap: () async {
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            if(prefs.getString("CartShopName") == null){
                              CoolAlert.show(
                                context: context,
                                type: CoolAlertType.info,
                                backgroundColor: Colors.orange,
                                confirmBtnColor: Colors.orange,
                                title: "Please add items to view your cart",
                                confirmBtnTextStyle: GoogleFonts.roboto(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                ),
                              );
                            }
                            else{
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) => CartPage())
                              );
                            }
                          },
                        ),
                        /*SizedBox(
                          height: 20,
                        ),
                        ListTile(
                          title: CustomText(
                            text: "Payment",
                            color: Colors.black,
                          ),
                          trailing: Icon(Icons.monetization_on_outlined,color: Colors.black,),
                          tileColor: Colors.white,
                        ),*/
                        SizedBox(
                          height: 20,
                        ),
                        ListTile(
                          title: CustomText(
                            text: "Delete My Account",
                            color: Colors.black,
                          ),
                          trailing: Icon(Icons.delete_forever,color: Colors.black,),
                          tileColor: Colors.white,
                          onTap: () async {
                            CoolAlert.show(
                              context: context,
                              type: CoolAlertType.confirm,
                              backgroundColor: Colors.orange,
                              onConfirmBtnTap: () async {
                                Navigator.of(context).pop();
                                CoolAlert.show(
                                  context: context,
                                  type: CoolAlertType.loading,
                                  backgroundColor: Colors.orange,
                                  title: "Deleting Profile",
                                  text: "Please Wait...",
                                );
                                bool state = await UserAPICall.deleteUserProfile();
                                Navigator.of(context).pop();
                                if(state){
                                  CoolAlert.show(
                                      context: context,
                                      type: CoolAlertType.success,
                                      backgroundColor: Colors.orange,
                                      confirmBtnColor: Colors.orange,
                                      title: "Deleted account successfully",
                                      confirmBtnTextStyle: GoogleFonts.roboto(
                                        color: Colors.white,
                                        fontSize: 15.0,
                                      ),
                                      onConfirmBtnTap: () async {
                                        Navigator.of(context).pop();
                                        SharedPreferences prefs = await SharedPreferences.getInstance();
                                        prefs.remove("userAccountLogin");
                                        prefs.remove("userProfileId");
                                        context.read<UserLogInPageProvider>().setIsUserLoginToAccount(false);
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
                              },
                              confirmBtnTextStyle: GoogleFonts.roboto(
                                color: Colors.white,
                                fontSize: 15.0,
                              ),
                              onCancelBtnTap: () => Navigator.of(context).pop(),
                              cancelBtnTextStyle: GoogleFonts.roboto(
                                color: Colors.black,
                                fontSize: 15.0,
                              ),
                              confirmBtnText: "Delete",
                              confirmBtnColor: Colors.orange,
                            );
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ListTile(
                          title: CustomText(
                            text: "Log Out",
                            color: Colors.black,
                          ),
                          trailing: Icon(Icons.logout,color: Colors.black,),
                          tileColor: Colors.white,
                          onTap: () async {
                            CoolAlert.show(
                              context: context,
                              type: CoolAlertType.confirm,
                              backgroundColor: Colors.orange,
                              onConfirmBtnTap: () async {
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                prefs.remove("userAccountLogin");
                                prefs.remove("userProfileId");
                                Navigator.of(context).pop();
                                context.read<UserLogInPageProvider>().setIsUserLoginToAccount(false);
                              },
                              confirmBtnTextStyle: GoogleFonts.roboto(
                                color: Colors.white,
                                fontSize: 15.0,
                              ),
                              onCancelBtnTap: () => Navigator.of(context).pop(),
                              cancelBtnTextStyle: GoogleFonts.roboto(
                                color: Colors.black,
                                fontSize: 15.0,
                              ),
                              confirmBtnText: "Log Out",
                              confirmBtnColor: Colors.orange,
                            );
                          },
                        ),
                        SizedBox(
                          height: 40,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
          else{
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
          }
        }
      ),
    );
  }
}
