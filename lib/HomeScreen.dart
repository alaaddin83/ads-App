import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:adsapp/constant.dart';
import 'package:share/share.dart';

import 'package:adsapp/Ads_Department.dart';
import 'package:adsapp/GUI/Ad_Request_Screen.dart';
import 'package:adsapp/GUI/links_screen.dart';
import 'package:adsapp/GUI/news_screen.dart';
import 'package:adsapp/GUI/pharmacy_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'module/image_main_ad.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:fluttertoast/fluttertoast.dart';

//import 'package:connectivity/connectivity.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomeScreen();
  }
}

class _HomeScreen extends State<HomeScreen> {
//  static Color actionbarcolor = Color.fromRGBO(145, 37, 113, 1);
//  static Color cardcolor = Color.fromRGBO(212, 66, 92, 1);

  //list  (array) for   image
  List<ImageItem> images = [];

  int currentsliderindex = 0;

  //api  for main ad
  Future<List<ImageItem>> _fetchMainAd() async {
    String url = "http://mix-apps.a2hosted.com/get_main_ad.php";
    final response = await http.get(url);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      images = imageItemFromJson(response.body);
      return images;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load data');
    }
  }

  //admob  adding
  static final MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: <String>['ads', 'news', 'wallpapers'],
    childDirected: false,
    testDevices: <String>[], // Android emulators are considered test devices
  );

  //bannerAd  adding
  BannerAd myBanner = BannerAd(
    // Replace the testAdUnitId with an ad unit id from the AdMob dash.
    // https://developers.google.com/admob/android/test-ads
    adUnitId: BannerAd.testAdUnitId,
    //adUnitId: 'ca-app-pub-6609500553188970/4058889346',
    size: AdSize.banner,
    targetingInfo: targetingInfo,
    listener: (MobileAdEvent event) {
      print("BannerAd event is $event");
    },
  );

  //InterstitialAd    adding
//  InterstitialAd showInterstitial() {
//    return InterstitialAd(
//      adUnitId: 'ca-app-pub-6609500553188970/1979520917',
//      targetingInfo: targetingInfo,
//      listener: (MobileAdEvent event) {
//        print("InterstitialAd event is $event");
//      },
//    );
//  }

  //Fetch the data
  Future<List<ImageItem>> futureImage;

  @override
  void initState() {
    super.initState();
    futureImage = _fetchMainAd();
//    FirebaseAdMob.instance
//        .initialize(appId: 'ca-app-pub-6609500553188970~1269074472');
//    myBanner..load();
//    myBanner..show();
//    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
//    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    myBanner?.dispose();
    super.dispose();
  }

  // handle menu item  selected
  _selectedItem(String selectedItem) {
    if (selectedItem == 'close') {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              title: new Text(
                'هل تريد الخروج من التطبيق حقاً ؟',
                style: TextStyle(
                  fontFamily: kfont,
                ),
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
              ),
              actions: <Widget>[
                FlatButton(
                  child: new Text(
                    "لا",
                    style: TextStyle(
                        color: kActionbarcolor,
                        fontWeight: FontWeight.bold,
                        fontFamily: kfont,
                        fontSize: 20),
                  ),
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                ),
                FlatButton(
                  child: new Text(
                    "نعم",
                    style: TextStyle(
                        color: kActionbarcolor,
                        fontWeight: FontWeight.bold,
                        fontFamily: kfont,
                        fontSize: 20),
                  ),
                  onPressed: () {
                    // Navigator.pop(context, true);
                    exit(0);
                  },
                ),
              ],
            );
          });
      //
    } else if (selectedItem == 'evaluation') {
      return _launchURL(
          'https://play.google.com/store/apps/details?id=com.hardpro.adsapp');
    } else if (selectedItem == 'share') {
      return Share.share(
          'https://play.google.com/store/apps/details?id=com.hardpro.adsapp');
    } else if (selectedItem == 'sujest') {
      return _launchEmail(
          'ala_edin_fa@hotmail.com', 'مقترح لتطبيق خدمات الريحانية');
    } else if (selectedItem == 'apps') {
      return _launchURL(
          "https://play.google.com/store/apps/dev?id=5007331887298406329");
    } else {
      Navigator.push(
        context,
        new MaterialPageRoute(builder: (context) => SendRequest()),
      );
    }
  }

  // ارسال  ايميل
  _launchEmail(String toMailId, String subject) async {
    var url = 'mailto:$toMailId?subject=$subject';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  //تقييم التطبيق
  _launchURL(String link) async {
    String url = link;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw ' تعذر فتح $url';
    }
  }

  // action  in actionbar
  Widget _getActionmenu() {
    return IconButton(
      icon: new Image.asset(
        "images/microfon.png",
      ),
      tooltip: 'إضافة إعلان',
      //padding: EdgeInsets.only(right: 10.0),
      //iconSize: (40.0),
      onPressed: () {
//        showInterstitial()
//          ..load()
//          ..show();
        Navigator.push(
          context,
          new MaterialPageRoute(builder: (context) => SendRequest()),
        );
      },
    );
  }

  //handle   back btn
  DateTime backbtnpressedTime;
  Future<bool> _onWillPop() async {
    DateTime currenttime = DateTime.now();
    bool backbtn = backbtnpressedTime == null ||
        currenttime.difference(backbtnpressedTime) > Duration(seconds: 4);
    if (backbtn) {
      backbtnpressedTime = currenttime;
      Fluttertoast.showToast(
        msg: 'للخروج اضغط على زر الرجوع مرة أخرى',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: kActionbarcolor,
        textColor: Colors.white,
        fontSize: 20.0,
      );

      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "خدمات الريحانية",
          style: TextStyle(fontSize: 30, fontFamily: kfont),
        ),
        //centerTitle: true,
        automaticallyImplyLeading: false,
//        actionsIconTheme:
//            IconThemeData(size: 30.0, color: Colors.white, opacity: 10.0),

        actions: <Widget>[
          _getActionmenu(),
          PopupMenuButton(
            offset: Offset(0, 100),
            icon: Icon(Icons.menu),
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<String>>[
                //adding   ad
                PopupMenuItem(
                  value: 'adding ad',
                  child: ListTile(
                    leading: Image.asset(
                      "images/microfon.png",
                      color: kCardcolor,
                      height: 35,
                      width: 35,
                    ),
                    title: Text(
                      'إضافة إعلان',
                      style: TextStyle(fontSize: 18, fontFamily: "Tajawal"),
                    ),
                  ),
                ),
                PopupMenuDivider(),
                //مقترحات
                PopupMenuItem(
                  value: 'sujest',
                  child: ListTile(
                    leading: Icon(
                      Icons.email,
                      color: kCardcolor,
                    ),
                    title: Text(
                      'مقترحاتكم',
                      style: TextStyle(fontSize: 18, fontFamily: "Tajawal"),
                    ),
                  ),
                ),
                PopupMenuDivider(),
                //مشاركة
                PopupMenuItem(
                  value: 'share',
                  child: ListTile(
                    leading: Icon(
                      Icons.share,
                      color: kCardcolor,
                    ),
                    title: Text(
                      'مشاركة التطبيق',
                      style: TextStyle(fontSize: 18, fontFamily: "Tajawal"),
                    ),
                  ),
                ),
                PopupMenuDivider(),
                //تقييم
                PopupMenuItem(
                  value: 'evaluation',
                  child: ListTile(
                    leading: Icon(Icons.star, color: kCardcolor),
                    title: Text(
                      'التقييم',
                      style: TextStyle(fontSize: 18, fontFamily: "Tajawal"),
                    ),
                  ),
                ),
                PopupMenuDivider(),
                //other  apps
                PopupMenuItem(
                  value: 'apps',
                  child: ListTile(
                    leading: Icon(Icons.more, color: kCardcolor),
                    title: Text(
                      'تطبيقات أخرى',
                      style: TextStyle(fontSize: 18, fontFamily: kfont),
                    ),
                  ),
                ),
                PopupMenuDivider(),

                //خروج
                PopupMenuItem(
                  value: 'close',
                  child: ListTile(
                    leading: Icon(Icons.close, color: kCardcolor),
                    title: Text(
                      'الخروج من التطبيق',
                      style: TextStyle(fontSize: 18, fontFamily: "Tajawal"),
                    ),
                  ),
                ),
              ];
//                itemMenu.map((itemMenu) {
//                return PopupMenuItem(
//                  value: itemMenu,
//                  child: Text(
//                    itemMenu,
//                    textDirection: TextDirection.rtl,
//                    textAlign: TextAlign.right,
//                  ),
//                  textStyle:
//                      TextStyle(fontFamily: 'Tajawal', color: Colors.black),
//                );
//              }).toList();
            },
            onSelected: (item) {
              setState(() {
                _selectedItem(item);
              });
            },
          ),
        ],
//        leading: new Container(),
        backgroundColor: kActionbarcolor,
      ),
      body: WillPopScope(
        onWillPop: _onWillPop,
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/background.png"),
                  fit: BoxFit.cover)),
          child: ListView(
            children: <Widget>[
              //services department
              new Container(
                margin: const EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(width: 1, color: kCardcolor),
                ),
                child: _servicesList(),
              ),

              SizedBox(
                height: 3.0,
              ),

              //image  ofer   from  internet
              FutureBuilder<List<ImageItem>>(
                  //initialData: 'load image ....',
                  future: futureImage,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasError) {
                      return _get_local_image();

                      //Text("${snapshot.error}");
                    }

                    if (snapshot.hasData) {
                      return CarouselSlider.builder(
                        itemCount: snapshot.data.length,
                        height: 250,
                        viewportFraction: 0.99,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 5),
                        autoPlayAnimationDuration:
                            const Duration(milliseconds: 300),
                        itemBuilder: (BuildContext context, int index) {
                          ImageItem img = snapshot.data[index];

                          String imgsrc = '${img.imgSrc}';
                          String phone = '${img.contact}';

                          return _imageOffer(imgsrc, phone);
                        },
                        onPageChanged: (int i) {
                          setState(() {
                            currentsliderindex = i;
                          });
                        },
                      );
                    }

                    return Center(
                        child: CircularProgressIndicator(
                            valueColor:
                                new AlwaysStoppedAnimation<Color>(kCardcolor)));
                  }),

              //image offer   without json data (direct from url )
              /////////////////////////////////////////

              //  ads department
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  for (int i = 0; i < images.length; i++)
                    Container(
                      height: 6,
                      width: i == currentsliderindex ? 10 : 4,
                      margin: EdgeInsets.symmetric(horizontal: 2, vertical: 5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: i == currentsliderindex
                            ? kActionbarcolor
                            : kCardcolor,
                      ),
                    ),
                ],
              ), //row   for   dots
              // Padding(padding: EdgeInsets.only(top: 5.0)),
              //
              SizedBox(
                height: 3.0,
              ),
              //زر قسم الاعلانات
              Container(
                margin:
                    const EdgeInsets.only(bottom: 5.0, left: 5.0, right: 5.0),
                height: 150,
                width: double.infinity,
                child: FlatButton(
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                      side: BorderSide(color: Colors.red)),
                  color: kCardcolor,
                  textColor: Colors.white,
                  padding: EdgeInsets.all(5.0),
                  child: new Column(
                    textDirection: TextDirection.rtl,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image(
                        image: AssetImage("images/microfon.png"),
                        height: 75,
                        width: 100,
                      ),
                      Text(
                        "بوابة الاعلانات",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Tajawal",
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      Text(
                        "أعلن معنا",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: "Tajawal",
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {
//                    showInterstitial()
//                      ..load()
//                      ..show();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AdsScreen()),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
//      bottomNavigationBar: Container(
//        height: 50.0,
//        color: Colors.white,
//      ),
    );
  }

  //   services  list
  Widget _servicesList() {
    return new Container(
      //color: Colors.yellow,
      width: MediaQuery.of(context).size.width,
      height: 125,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        // color:cardcolor,
      ),

      child: Center(
        child: Row(
          //scrollDirection: Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: new InkWell(
                child: _serviceCard(
                    "الصيدلية المناوبة", "images/pharmacy_icon.png"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PharmacyScreen()),
                  );
                },
              ),
            ),
            Expanded(
              child: new InkWell(
                child: _serviceCard("روابط مهمة", "images/links_icon.png"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LinksScreen()),
                  );
                },
              ),
            ),
            Expanded(
              child: new InkWell(
                child: _serviceCard("أهم الاخبار", "images/new_icon.png"),
                onTap: () {
//                  showInterstitial()
//                    ..load()
//                    ..show();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NewsScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _serviceCard(String serviceName, String imgpath) {
    return new SizedBox(
      width: 116,
      child: new Card(
        color: kCardcolor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
//            CircleAvatar(backgroundImage: AssetImage(imgpath
//            ),
//              radius: 40,),
            SizedBox(
              height: 15.0,
            ),
            Image(
              image: new AssetImage(
                imgpath,
              ),
              width: 50,
              height: 50,
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              serviceName,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontFamily: "Tajawal",
                fontSize: 16,
                fontStyle: FontStyle.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //image  offer
  Widget _imageOffer(String img_src, String phone) {
    return Builder(builder: (BuildContext context) {
      return Container(
        width: MediaQuery.of(context).size.width,
        //height: MediaQuery.of(context).size.height * 0.2,
        margin: EdgeInsets.symmetric(horizontal: 1.0),
        padding: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0), color: kCardcolor),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 5.0,
            ),

            ClipRRect(
              borderRadius: new BorderRadius.circular(10.0),
              child: Image.network(
                img_src,
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            //icon &  phone

//            onTap: () {
//
//            },
            Expanded(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () async {
                        var url = 'https://wa.me/+9$phone';
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      child: Image(
                        image: AssetImage("images/whatsicon.png"),
                        height: 25,
                        width: 25,
                      ),
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    InkWell(
                      onTap: () {
                        launch("tel://$phone");
                      },
                      child: Image(
                        image: AssetImage(
                          "images/adtele.png",
                        ),
                        height: 50.0,
                        width: 50.0,
                      ),
                    ),
//                        Text(
//                          phone,
//                          style: TextStyle(
//                            color: Colors.white,
//                            fontSize: 20,
//                            fontFamily: 'SourceSansPro',
//                            fontWeight: FontWeight.bold,
//                            fontStyle: FontStyle.normal,
//                          ),
//                        ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      ": للتواصل",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ]),
            ),
          ],
        ),
      );
    });
  }

  //  no internet desplay  this ad
  Widget _get_local_image() {
    return Container(
      height: 250,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.all(5.0),
      padding: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0), color: kCardcolor),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 5.0,
          ),
          ClipRRect(
            borderRadius: new BorderRadius.circular(10.0),
            child: Image(
              image: AssetImage("images/mix_mobile.jpg"),
              fit: BoxFit.fill,
            ),
          ),

          //icon &  phone
          Expanded(
            child: InkWell(
                splashColor: kCardcolor, // splash color
                onTap: () {
                  launch("tel://05051441119");
                }, // button pressed
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image(image: AssetImage("images/adtele.png")),
                      Text(
                        '5051441119',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'SourceSansPro',
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        ":للتواصل",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ])),
          ),
        ],
      ),
    );
  }
}
