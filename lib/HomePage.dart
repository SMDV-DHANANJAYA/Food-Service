import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nearmy/components/components.dart';
import 'package:nearmy/provider/pages/mainNavPages/ProviderLogInPage.dart';
import 'package:nearmy/user/UserPage.dart';

class HomePage extends StatelessWidget  {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Container(
              child: Column(
                children: [
                  CustomText(
                    text: "Select How You",
                    color: Colors.black,
                    size: 25.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: CustomText(
                      text: "Want to Interact With Us",
                      color: Colors.black,
                      size: 25.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Center(
                  child: GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => UserPage())
                      );
                    },
                    child: Container(
                      color: Colors.white.withOpacity(0.5),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              text: "Buyer",
                              size: 20.0,
                              color: Colors.black,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Tooltip(
                                message: "You can order product, search seller locations and track them",
                                padding: EdgeInsets.all(10.0),
                                margin: EdgeInsets.symmetric(horizontal: 15.0),
                                preferBelow: true,
                                textStyle: GoogleFonts.roboto(
                                    color: Colors.white
                                ),
                                child: Icon(
                                  Icons.info_outline_rounded,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Spacer(),
                            Icon(
                              Icons.account_circle,
                              color: Colors.black,
                              size: 40.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 30.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Center(
                    child: GestureDetector(
                      onTap: () async {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => ProviderLogInPage())
                        );
                      },
                      child: Container(
                        color: Colors.white.withOpacity(0.5),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(
                                text: "Seller",
                                size: 20.0,
                                color: Colors.black,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Tooltip(
                                  message: "You can sell product, take orders and track your buyer",
                                  padding: EdgeInsets.all(10.0),
                                  margin: EdgeInsets.symmetric(horizontal: 15.0),
                                  preferBelow: true,
                                  textStyle: GoogleFonts.roboto(
                                      color: Colors.white
                                  ),
                                  child: Icon(
                                    Icons.info_outline_rounded,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Spacer(),
                              Icon(
                                Icons.delivery_dining,
                                color: Colors.black,
                                size: 40.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Center(
            child: CustomText(
              text: "Need any help?",
              color: Colors.black,
              size: 20.0,
            ),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/icon/flash.png",
                  height: 70.0,
                  width: 70.0,
                  color: Colors.deepOrange,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    children: [
                      CustomText(
                        text: "Powerd By",
                        color: Colors.white,
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
        ],
      ),
    );
  }
}
