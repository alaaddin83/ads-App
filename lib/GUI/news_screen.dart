import 'dart:convert';

import 'package:adsapp/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class NewsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _NewsScreen();
  }
}

class _NewsScreen extends State<NewsScreen> {
//  static Color actionbarcolor = Color.fromRGBO(145, 37, 113, 1);
//  static Color cardcolor = Color.fromRGBO(212, 66, 92, 1);

  //api  for fharmacy
  Future<List<NewItem>> _fetchNews() async {
    String url = "http://mix-apps.a2hosted.com/get_news.php";
    final response = await http.get(url);
    var jsonData = json.decode(response.body);
    List<NewItem> news = [];
    for (var u in jsonData) {
      NewItem newitem = NewItem(
          u["new_title"], u["new_text"], u["new_date"], u["new_source"]);
      news.add(newitem);
    }
    if (response.statusCode != 200) {
      // If the server did return a 200 OK response,
      //return pharmacyFromJson(response.body)
      throw Exception('Failed to load data');
    }
    return news;
  }

  Future<List<NewItem>> futureNews;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureNews = _fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "أهم الأخبار",
          style: TextStyle(
            fontSize: 26,
            fontFamily: kfont,
          ),
          textDirection: TextDirection.rtl,
        ),
//          textTheme: TextTheme(title: context),
        centerTitle: true,
        backgroundColor: kActionbarcolor,
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/background.png"), fit: BoxFit.cover)),
        child: FutureBuilder(
            future: futureNews,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      String title = snapshot.data[index].new_title;
                      String new_text = snapshot.data[index].new_text;
                      String date = snapshot.data[index].new_date;
                      String new_source = snapshot.data[index].new_source;
                      //AsyncSnapshot page = snapshot.data[index];

                      // return _getNews(title,new_text,date,new_source,page);

                      return Card(
                        color: kCardcolor,
                        margin: EdgeInsets.all(3.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(color: Colors.white70, width: 1),
                        ),
                        child: Container(
                          height: 160,
                          child: InkWell(
                            child: Column(
                              //mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.end,

                              children: <Widget>[
                                Container(
                                  height: 60,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        right: 10.0, top: 5.0, left: 10.0),
                                    child: Text(
                                      title,
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontFamily: kfont,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                  ),
                                ),

                                Container(
                                  height: 70,
                                  padding: const EdgeInsets.only(
                                    right: 12.0,
                                    left: 5.0,
                                  ),
                                  child: Text(
                                    new_text,
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontFamily: kfont,
                                      // fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.normal,
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                  ),
                                ),

                                //date &  src
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 10.0, left: 10.0, top: 3.0),
                                  child: Row(
                                    //crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 40.0),
                                        child: Text(
                                          date,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FontStyle.normal,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        new_source,
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontFamily: kfont,
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

//
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) =>
                                        _DetailNew(snapshot.data[index])),
                              );

                              //print(snapshot.data[index]);
                            },
                          ),
                        ),
                      );
                    });
              } else if (snapshot.hasError) {
                return Text(
                  "عذراً يوجد مشكلة في الاتصال بالانترنت.يرجى المحاولة مرة أخرى",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                    fontFamily: kfont,
                  ),
                  textDirection: TextDirection.rtl,
                );

                //Text("${snapshot.error}");
              }
              return Center(
                  child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(kCardcolor),
              ));
            }),
      ),
//      bottomNavigationBar: Container(
//        height: 80.0,
//        color: Colors.white,
//      ),
    );
  }
}

class NewItem {
  final String new_title;
  final String new_text;
  final String new_date;
  final String new_source;

  NewItem(this.new_title, this.new_text, this.new_date, this.new_source);
}

class _DetailNew extends StatelessWidget {
  final NewItem newItem;
  _DetailNew(this.newItem);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "أهم الأخبار التي تهم السورريين",
          style: TextStyle(
            fontSize: 20,
            fontFamily: kfont,
          ),
        ),
        centerTitle: true,
        backgroundColor: kActionbarcolor,
      ),
      body: Container(
        margin: EdgeInsets.all(5.0),
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: kCardcolor,
          border: Border.all(width: 1, color: Colors.white),
        ),
        child: ListView(
          children: <Widget>[
            Column(
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                //new  title
                new Padding(
                  padding: EdgeInsets.only(top: 22.0, bottom: 15.0),
                  child: new Text(
                    this.newItem.new_title,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: kfont,
                        fontWeight: FontWeight.bold,
                        textBaseline: TextBaseline.alphabetic),
                    textDirection: TextDirection.rtl,
                  ),
                ),
                //new_ text about
                new Text(
                  this.newItem.new_text,
                  style: TextStyle(
                      fontFamily: kfont, color: Colors.white, fontSize: 18),
                  textDirection: TextDirection.rtl,
//                   textAlign: TextAlign.end,
                ),

                Padding(
                    padding: EdgeInsets.only(
                  top: 15.0,
                )),

                //new_source &  date
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text(
                        this.newItem.new_date,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                        // textDirection: TextDirection.rtl,
                        textAlign: TextAlign.end,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: Text(
                        this.newItem.new_source,
                        style: TextStyle(
                            fontFamily: kfont,
                            color: Colors.white,
                            fontSize: 18),
                        textDirection: TextDirection.rtl,
//               textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 80,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
