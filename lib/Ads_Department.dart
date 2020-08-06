import 'package:adsapp/GUI/Ad_Request_Screen.dart';
import 'package:adsapp/GUI/ads_collection_screen.dart';
import 'package:flutter/material.dart';

//import 'GUI/Ad_Request_Screen.dart';

class AdsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AdsScreen();
  }
}

class _AdsScreen extends State<AdsScreen> {
  static Color actionbarcolor = Color.fromRGBO(145, 37, 113, 1);
  static Color cardcolor = Color.fromRGBO(212, 66, 92, 1);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "قسم الاعلانات ",
          style: TextStyle(
            fontSize: 30,
            fontFamily: "Tajawal",
          ),
        ),
        centerTitle: true,
        backgroundColor: actionbarcolor,
        actions: <Widget>[
          IconButton(
            icon: new Image.asset(
              "images/microfon.png",
            ),
            tooltip: 'إضافة إعلان',
            padding: EdgeInsets.only(right: 15.0),
            iconSize: (40.0),
            onPressed: () {
              Navigator.push(
                context,
                new MaterialPageRoute(builder: (context) => SendRequest()),
              );
            },
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/background.png"), fit: BoxFit.cover)),
        child: GridView.count(
          crossAxisCount: 2,
          children: <Widget>[
            _gridAdItem(
                "مطاعم و ماركت",
                "images/resturant.png",
                CollectionAdsScreen(
                    dataUrl:
                        "http://mix-apps.a2hosted.com/getData_Resturant.php",
                    lebal: "مطاعم و ماركت")),
//
            _gridAdItem(
              "بيوت وعقارات",
              "images/buildin.png",
              CollectionAdsScreen(
                  dataUrl: "http://mix-apps.a2hosted.com/getData_House.php",
                  lebal: "بيوت وعقارات"),
            ),
//
            _gridAdItem(
                "تكنولوجيا والكترونيات",
                "images/technologe.png",
                CollectionAdsScreen(
                    dataUrl:
                        "http://mix-apps.a2hosted.com/getData_electronic.php",
                    lebal: "تكنولوجيا والكترونيات")),

            _gridAdItem(
                "اليات وسيارات",
                "images/cars.png",
                CollectionAdsScreen(
                    dataUrl: "http://mix-apps.a2hosted.com/getData_cars.php",
                    lebal: "اليات وسيارات")),
            _gridAdItem(
              "مفروشات ومستعمل",
              "images/sofi.png",
              CollectionAdsScreen(
                  dataUrl: "http://mix-apps.a2hosted.com/getData_Bed.php",
                  lebal: "مفروشات ومستعمل"),
            ),

            _gridAdItem(
              "تجميل وأزياء",
              "images/buty.png",
              CollectionAdsScreen(
                  dataUrl: "http://mix-apps.a2hosted.com/getData_buiteful.php",
                  lebal: "تجميل وأزياء"),
            ),
            _gridAdItem(
              "تعليم ومعاهد",
              "images/teching.png",
              CollectionAdsScreen(
                  dataUrl: "http://mix-apps.a2hosted.com/getData_eduigat.php",
                  lebal: "تعليم ومعاهد"),
            ),

            _gridAdItem(
              "إعلانات متنوعة",
              "images/microfon.png",
              CollectionAdsScreen(
                  dataUrl: "http://mix-apps.a2hosted.com/getData_others.php",
                  lebal: "إعلانات متنوعة"),
            ),
          ],
        ),
      ),
//      bottomNavigationBar: Container(
//        height: 50.0,
//        color: Colors.white,
//      ),
    );
  }

  Widget _gridAdItem(String title, String icon, Widget page) {
    return new SizedBox(
      height: 100,
      child: new InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            //  border: Border.all(color: Colors.blueAccent)
            color: cardcolor,
            borderRadius: BorderRadius.all(
                Radius.circular(5.0) //                 <--- border radius here
                ),
          ),
          margin: const EdgeInsets.all(5.0),
          padding: EdgeInsets.all(3.0),
          //
          child: new Column(
            children: <Widget>[
              SizedBox(
                height: 8.0,
              ),
              Image(
                image: AssetImage(icon),
                height: 90,
                width: 90,
              ),
              SizedBox(
                height: 10.0,
              ),
              new Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: "Tajawal",
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
