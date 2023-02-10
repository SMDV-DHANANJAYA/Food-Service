import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:nearmy/API/UserAPICall.dart';
import 'package:nearmy/components/components.dart';
import 'package:nearmy/provider/model/Provider.dart';
import 'package:nearmy/user/pages/otherPages/MenuItemPage.dart';
import 'package:provider/provider.dart';

import 'UserMapPage.dart';

class UserMenuPageProvider extends ChangeNotifier{
  bool _changeListType = true;

  bool get getListType => _changeListType;

  void setChangeListType(){
    _changeListType = !_changeListType;
    notifyListeners();
  }
}

class UserProvidersPage extends StatefulWidget {

  const UserProvidersPage();

  @override
  _UserProvidersPageState createState() => _UserProvidersPageState();
}

class _UserProvidersPageState extends State<UserProvidersPage> {

  @override
  void initState() {
    var androidInitialize = new AndroidInitializationSettings('splash');
    var iosInitialize = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(android: androidInitialize,iOS: iosInitialize);
    Provider.of<UserMapPageProvider>(context, listen: false).localNotification = new FlutterLocalNotificationsPlugin();
    Provider.of<UserMapPageProvider>(context, listen: false).localNotification.initialize(initializationSettings);
    Provider.of<UserMapPageProvider>(context, listen: false).getNewData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              child: FutureBuilder(
                future: UserAPICall.getBannersData(),
                builder: (BuildContext context, AsyncSnapshot snapshot){
                  if(snapshot.hasData){
                    return CarouselSlider.builder(
                      itemCount: snapshot.data.length,
                      options: CarouselOptions(
                        initialPage: 1,
                        autoPlayAnimationDuration: Duration(seconds: 2),
                        autoPlayInterval: Duration(seconds: 4),
                        pauseAutoPlayInFiniteScroll: true,
                        viewportFraction: 1,
                        enlargeCenterPage: false,
                        aspectRatio: 1,
                        autoPlay: true,
                        enableInfiniteScroll: true,
                      ),
                      itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
                        return CachedNetworkImage(
                          imageUrl: snapshot.data[itemIndex].imageUrl,
                          placeholder: (context, url) => Container(color: Colors.transparent,),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        );
                      },
                    );
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
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black,
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: "Nearby Providers",
                    space: 2,
                    size: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      context.read<UserMenuPageProvider>().setChangeListType();
                    },
                    child: Icon(
                      Icons.emoji_food_beverage_outlined,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: FutureBuilder(
              future: UserAPICall.getProvidersData(),
              builder: (BuildContext context, AsyncSnapshot snapshot){
                if(snapshot.hasData){
                  return context.watch<UserMenuPageProvider>().getListType ?
                  StaggeredGridView.countBuilder(
                    crossAxisCount: 4,
                    itemCount: snapshot.data.length,
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                    staggeredTileBuilder: (int index) => StaggeredTile.count(2, index.isEven ? 3 : 2),
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 8.0,
                    itemBuilder: (BuildContext context, int index) {
                      var data = snapshot.data[index] as Providers;
                      return Hero(
                        tag: "MenuPageHero$index",
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) => MenuItemPage(data))
                            );
                          },
                          child: CachedNetworkImage(
                            imageUrl: data.imageUrl,
                            placeholder: (context, url) => Container(color: Colors.transparent,),
                            errorWidget: (context, url, error) => Icon(Icons.error),
                            imageBuilder: (context, imageProvider) => Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height / 5,
                              margin: EdgeInsets.all(5.0),
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
                              child: Stack(
                                children: [
                                  Positioned(
                                    bottom: 0.0,
                                    left: 0.0,
                                    right: 0.0,
                                    height: 60.0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(10.0),
                                        gradient: LinearGradient(
                                          colors: [
                                            Color.fromARGB(40, 0, 0, 0),
                                            Color.fromARGB(250, 0, 0, 0)
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                        child: Center(
                                          child: CustomText(
                                            text: data.name,
                                            size: 18.0,
                                            resize: true,
                                            lineCount: 1,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ) :
                  ListView.builder(
                    padding: EdgeInsets.all(5.0),
                    itemCount: snapshot.data.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      var data = snapshot.data[index] as Providers;
                      return Hero(
                        tag: "MenuPageHero$index",
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) => MenuItemPage(data))
                            );
                          },
                          child: CachedNetworkImage(
                            imageUrl: data.imageUrl,
                            placeholder: (context, url) => Container(color: Colors.transparent,),
                            errorWidget: (context, url, error) => Icon(Icons.error),
                            imageBuilder: (context, imageProvider) => Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height / 5,
                              margin: EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    spreadRadius: 1.0,
                                    blurRadius: 1.0,
                                  ),
                                ],
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    bottom: 0.0,
                                    left: 0.0,
                                    right: 0.0,
                                    height: 60.0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(10.0),
                                        gradient: LinearGradient(
                                          colors: [
                                            Color.fromARGB(40, 0, 0, 0),
                                            Color.fromARGB(250, 0, 0, 0)
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                      ),
                                      child: Center(
                                        child: CustomText(
                                          text: data.name,
                                          size: 18.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
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
        ],
      ),
    );
  }
}
