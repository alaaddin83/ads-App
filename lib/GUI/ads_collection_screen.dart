import 'dart:convert';

import 'package:adsapp/GUI/Ad_Request_Screen.dart';
import 'package:adsapp/constant.dart';
import 'package:adsapp/widgets/custom_ad_detail.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:adsapp/module/ad_item.dart';

class CollectionAdsScreen extends StatefulWidget {
  final String dataUrl;
  final String lebal;

  const CollectionAdsScreen(
      {Key key, @required this.dataUrl, @required this.lebal})
      : super(key: key);

  @override
  _CollectionAdsScreenState createState() =>
      _CollectionAdsScreenState(datalink: dataUrl, lebal2: lebal);
}

class _CollectionAdsScreenState extends State<CollectionAdsScreen> {
  final String datalink;
  final String lebal2;

  _CollectionAdsScreenState({@required this.datalink, @required this.lebal2});

  //api  for ad
  Future<List<AdItem>> _fetchAds() async {
    //String url = datalink;
    final response = await http.get(datalink);
    var jsonData = json.decode(response.body);
    List<AdItem> ads = [];
    for (var u in jsonData) {
      AdItem newitem = AdItem(u["ad_title"], u["ad_text"], u["ad_date"],
          u["ad_phone"], u["ad_image"]);
      ads.add(newitem);
    }
    if (response.statusCode != 200) {
      // If the server did return a 200 OK response,
      //return pharmacyFromJson(response.body)
      throw Exception('Failed to load data');
    }
    return ads;
  }

  Future<List<AdItem>> futureAds;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureAds = _fetchAds();
  }

  @override
  Widget build(BuildContext context) {
  //  List<Widget> Bottom_Buttons = new List<Widget>();

//    Bottom_Buttons.add(
//      Container(
//        height: 50.0,
//      ),
//    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          lebal2,
          style: TextStyle(
            fontSize: 22,
            fontFamily: kfont,
          ),
        ),
        centerTitle: true,
        backgroundColor: kActionbarcolor,
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/background.png"), fit: BoxFit.cover)),
        child: FutureBuilder(
            future: futureAds,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
//                      String title = snapshot.data[index].ad_title;
//                      String txt = snapshot.data[index].ad_text;
//                      String date = snapshot.data[index].ad_date;
//                      String phone = snapshot.data[index].ad_phone;
//                      String photo = snapshot.data[index].ad_image;

                      return custom_ad_detail(
                        adItem: snapshot.data[index],
                      );
                    });
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "عذراً يوجد مشكلة في الاتصال بالانترنت.يرجى المحاولة مرة أخرى",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal,
                      fontFamily: kfont,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                );
                //Text("${snapshot.error}");
              }
              return Center(
                  child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(kCardcolor),
              ));
            }),
      ),

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 0.0),
        child: FloatingActionButton(
          tooltip: " اعلن معنا",
          //label: Text('اعلن معنا'),
          backgroundColor: kActionbarcolor,

          child: Icon(Icons.add),
          //elevation: 0,
          elevation: 0.0,
          onPressed: () {
            Navigator.push(
              context,
              new MaterialPageRoute(builder: (context) => SendRequest()),
            );
          },
        ),
      ),
//      bottomNavigationBar: Container(
//        height: 50.0,
//        color: Colors.white,
//      ),
    //  persistentFooterButtons: Bottom_Buttons,
    );
  }
}
