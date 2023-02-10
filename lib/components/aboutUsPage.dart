import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'components.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 200.0,
            decoration: BoxDecoration(
              color: Colors.orange,
              border: Border(
                bottom: BorderSide(width: 2.0, color: Colors.black),
              ),
            ),
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/icon/flash.png",
                  height: 150.0,
                  width: 150.0,
                  color: Colors.deepOrange,
                ),
                CustomText(
                  text: "NearMy",
                  color: Colors.black,
                  size: 25.0,
                  space: 2.0,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Center(
                    child: CustomText(
                      text: "About Us",
                      color: Colors.black,
                      size: 25.0,
                      space: 2.0,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Text(
                    "NearMy is Sri Lanka's first mobile selling vehicle base mobile application. NearMy use state of the art technology to bring you more convenience shopping experience. By tracking your nearby shop, food and good selling vehicles much more easier than before",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      fontSize: 16.0,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Center(
                    child: CustomText(
                      text: "Team",
                      color: Colors.black,
                      size: 25.0,
                      space: 2.0,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Column(
                    children: [
                      CustomText(
                        text: "Dilki Weerakoon",
                        color: Colors.black,
                        size: 16.0,
                      ),
                      CustomText(
                        text: "Diduranga Weerasinghe",
                        color: Colors.black,
                        size: 16.0,
                      ),
                      CustomText(
                        text: "Upeksha Rathnayake",
                        color: Colors.black,
                        size: 16.0,
                      ),
                      CustomText(
                        text: "Navoda Koggala",
                        color: Colors.black,
                        size: 16.0,
                      ),
                      CustomText(
                        text: "Hansani Jayasundara",
                        color: Colors.black,
                        size: 16.0,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Center(
                    child: CustomText(
                      text: "Developed By",
                      color: Colors.black,
                      size: 25.0,
                      space: 2.0,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Tooltip(
                    message: "donvishwa.vd@gmail.com",
                    textStyle: GoogleFonts.montserratAlternates(
                        color: Colors.white
                    ),
                    child: Center(
                      child: CustomText(
                        text: "Vishwa Dhananjaya",
                        color: Colors.black,
                        size: 16.0,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Center(
                    child: CustomText(
                      text: "Rate Us",
                      color: Colors.black,
                      size: 25.0,
                      space: 2.0,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.star,color: Colors.orange),
                      Icon(Icons.star,color: Colors.orange),
                      Icon(Icons.star,color: Colors.orange),
                      Icon(Icons.star,color: Colors.orange),
                      Icon(Icons.star,color: Colors.orange),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/social/instagram.png",width: 40.0,height: 40.0,),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Image.asset("assets/social/facebook.png",width: 40.0,height: 40.0,),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Image.asset("assets/social/youtube.png",width: 40.0,height: 40.0,),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Image.asset("assets/social/whatsapp.png",width: 40.0,height: 40.0,),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0,bottom: 15.0),
                  child: Center(
                    child: CustomText(
                      text: "+94 779986151",
                      color: Colors.black,
                      size: 14.0,
                    ),
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
