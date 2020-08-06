import 'package:adsapp/module/pharmacy.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';

class PharmacyScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PharmacyScreen();
  }
}

class _PharmacyScreen extends State<PharmacyScreen> {
  static Color actionbarcolor = Color.fromRGBO(145, 37, 113, 1);
  static Color cardcolor = Color.fromRGBO(212, 66, 92, 1);

  //api  for fharmacy
  Future<List<Pharmacy>> _fetchPharmacy() async {
    String url =
        "http://mix-apps.a2hosted.com/adsapp_update/get_pharmacy_update.php";
    final response = await http.get(url);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return pharmacyFromJson(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load data');
    }
  }

  //Fetch the data
  Future<List<Pharmacy>> futurePharmacy;
  @override
  void initState() {
    super.initState();
    futurePharmacy = _fetchPharmacy();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "الصيدلية المناوبة في الريحانية",
            style: TextStyle(fontSize: 20, fontFamily: "Tajawal"),
          ),
          centerTitle: true,
          backgroundColor: actionbarcolor,
        ),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/background.png"),
                  fit: BoxFit.cover)),
          child: Column(
            children: <Widget>[
              FutureBuilder(
                future: futurePharmacy,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          Pharmacy pharmacy = snapshot.data[index];

                          String date = '${pharmacy.date}';
                          String day = '${pharmacy.day}';
                          String name = '${pharmacy.pharName}';
                          String phone = '${pharmacy.phone}';
                          String address1 = '${pharmacy.arabicAddress}';
                          String address2 = '${pharmacy.turkAddress}';
                          String maplocation = '${pharmacy.mapadres}';

                          if (day == "Wednesday") {
                            day = "الأربعاء";
                          } else if (day == "Sunday") {
                            day = "الأحد";
                          } else if (day == "Monday") {
                            day = "الأثنين";
                          } else if (day == "Tuesday") {
                            day = "الثلاثاء";
                          } else if (day == "Thursday") {
                            day = "الخميس";
                          } else if (day == "Friday") {
                            day = "الجمعة";
                          } else {
                            day = "السبت";
                          }

                          return _getpharmacy(date, day, name, phone, address1,
                              address2, maplocation);
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
                },
              ),
              SizedBox(
                height: 5.0,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    width: 1,
                  ),
                  color: cardcolor,
                ),
                margin: const EdgeInsets.all(10.0),
                padding: EdgeInsets.all(10.0),
                child: Text(
                  "ملاحظة: يستمر دوام الصيدليةالمناوبة حتى الساعة 8 صباحا من اليوم التالي",
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: "Tajawal",
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _getpharmacy(String date, String day, String name, String phone,
      String address1, String address2, String mapurl) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          width: 1,
        ),
        color: cardcolor,
      ),
      margin: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          right: BorderSide(width: 2, color: Colors.white))),
                  child: Image.asset(
                    "images/pharmacy_icon.png",
                    height: 50,
                    width: 50,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            date,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              //fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                          SizedBox(
                            width: 15.0,
                          ),
                          Text(
                            day,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: "Tajawal",
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),

          //  هاتف الصيدلية
          Container(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          right: BorderSide(width: 2, color: Colors.white))),
                  child: Image.asset(
                    "images/tele2.png",
                    height: 50,
                    width: 50,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    phone,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      //fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal,
                      fontFamily: "Tajawal",
                    ),
                  ),
                )
              ],
            ),
          ),

          //location
          Container(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          right: BorderSide(width: 2, color: Colors.white))),
                  child: InkWell(
                    onTap: () => _launchMap(mapurl),
                    child: Image.asset(
                      "images/logation.png",
                      height: 50,
                      width: 50,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          address1,
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: "Tajawal",
                            //fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          address2,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontStyle: FontStyle.normal,
                          ),
                          textAlign: TextAlign.left,
                          softWrap: true,
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  _launchMap(String mapurl) async {
    String url = mapurl;
    if (await canLaunch(url)) {
      await launch(
        url,
      );
    } else {
      throw 'Could not launch $url';
    }
  }
}
