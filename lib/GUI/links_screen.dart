import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'package:url_launcher/url_launcher.dart';

class LinksScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LinksScreen();
  }
}

class _LinksScreen extends State<LinksScreen> {
  static Color actionbarcolor = Color.fromRGBO(145, 37, 113, 1);
  static Color cardcolor = Color.fromRGBO(212, 66, 92, 1);

  //api  for fharmacy
  Future<List<AdItem>> _fetchAds() async {
    String url = "http://mix-apps.a2hosted.com/get_links.php";
    final response = await http.get(url);
    var jsonData = json.decode(response.body);
    List<AdItem> ads = [];
    for (var u in jsonData) {
      AdItem ad = AdItem(u["link_title"], u["link"], u["link_image"]);
      ads.add(ad);
    }
    if (response.statusCode != 200) {
      // If the server did return a 200 OK response,
      //return pharmacyFromJson(response.body)
      throw Exception('Failed to load data');
    }
    return ads;
  }

  Future<List<AdItem>> futureLink;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureLink = _fetchAds();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "روابط مهمة",
            style: TextStyle(
              fontSize: 26,
              fontFamily: "Tajawal",
            ),
          ),
          centerTitle: true,
          backgroundColor: actionbarcolor,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
            ),
            //icon: Icon(Icons.),
          ]),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/background.png"), fit: BoxFit.cover)),
        child: FutureBuilder(
            future: futureLink,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      String title = snapshot.data[index].link_title;
                      String link = snapshot.data[index].link;
                      //String image = snapshot.data[index].link_image;

                      return _getLinks(title, link);
                    });
              } else if (snapshot.hasError) {
                return Text(
                  "عذراً يوجد مشكلة في الاتصال بالانترنت.يرجى المحاولة مرة أخرى",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Tajawal",
                    fontStyle: FontStyle.normal,
                  ),
                  textDirection: TextDirection.rtl,
                );

                //Text("${snapshot.error}");
              }
              return Center(
                  child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(cardcolor),
              ));
            }),

//      child: _getLinks("images/edevlat.png"),
      ),
//      bottomNavigationBar: Container(
//        height: 50.0,
//        color: Colors.white,
//      ),
    );
  }

  //
  Widget _getLinks(String title, String link) {
    return Card(
      color: cardcolor,
      margin: EdgeInsets.all(3.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(color: Colors.white70, width: 1),
      ),
      child: Row(
        children: <Widget>[
          // Image(image: AssetImage(image),height: 50.0,width: 50.0,)
          Image.asset(
            "images/links_icon.png",
            height: 80,
            width: 60,
          ),
          Container(
            height: 100,
            decoration: BoxDecoration(
              border: Border(right: BorderSide(width: 2, color: Colors.white)),
            ),
            //child:Image.asset(image,height: 50,width: 50,),
          ),

          Expanded(
            child: Container(
              height: 130,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, top: 10.0, right: 10.0),
                    child: Text(
                      title,
                      //textAlign: TextAlign.left,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontFamily: "Tajawal",
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  InkWell(
                    child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          link,
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.ltr,
                          style: TextStyle(
                            color: cardcolor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      _launchURL(link);
                    },
                  ),

//
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _launchURL(String link1) async {
    String url = link1;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw ' تعذر فتح $url';
    }
  }
}

class AdItem {
  final String link_title;
  final String link;
  final String link_image;

  AdItem(this.link_title, this.link, this.link_image);
//  final String date;

}
