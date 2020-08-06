import 'package:adsapp/constant.dart';
import 'package:adsapp/module/ad_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class custom_ad_detail extends StatelessWidget {
  final AdItem adItem;

  const custom_ad_detail({@required this.adItem}); // final AdItem  adItem;

  Widget _adsPhotos(String imgads) {
    if (imgads == "0") {
      return Image.asset(
        "images/ads-logo.png",
        height: 100,
        width: 80,
        fit: BoxFit.fill,
      );
    } else {
      return Image.network(
        imgads,
        height: 100,
        width: 80,
        fit: BoxFit.fill,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String tele = adItem.ad_phone;

    return Card(
      color: kCardcolor,
      margin: EdgeInsets.all(3.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(color: Colors.white70, width: 1),
      ),
      child: Container(
        //height: MediaQuery.of(context).size.height * 0.3,
        height: 150,
        child: Row(
          children: <Widget>[
            //photo  &  dat
            Padding(
              padding: const EdgeInsets.only(top: 10.0, right: 3.0, left: 8.0),
//                  //photo  &  date
              child: Column(
                children: <Widget>[
                  GestureDetector(
                    child: Container(
                      height: 100,
                      width: 90,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white,
                      ),
                      child: _adsPhotos(adItem.ad_image),
                    ),
                    onTap: () {
                      // print(snapshot.data[index]);

                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => _DetailImage(adItem)),
                      );
                    },
                  ),
                  SizedBox(
                    height: 17,
                  ),
                  //date
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      adItem.ad_date,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ), //photo  &  dat

            // ad  title& text &  phone
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 5.0, right: 16.0, top: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  textDirection: TextDirection.rtl,
                  children: <Widget>[
                    //  ad   title
                    Container(
                      //padding: const EdgeInsets.all(5.0),
                      height: 35,
                      child: Text(
                        adItem.ad_title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: kfont,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    //ad  text
                    InkWell(
                      child: Container(
                        height: 60,
                        // padding:const EdgeInsets.only(right: 10.0,left: 5.0),
                        child: Text(
                          adItem.ad_text,
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: kfont,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => _DetailAd(adItem)),
                        );
                      },
                    ),
                    SizedBox(
                      height: 5.0,
                    ),

                    //calling phone
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () async {
                              var url = 'https://wa.me/+9$tele';
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                            child: Image(
                              image: AssetImage("images/whatsicon.png"),
                              height: 30,
                              width: 30,
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          GestureDetector(
                            onTap: () {
                              launch("tel://$tele");
                            },
                            child: Image(
                              image: AssetImage("images/adtele.png"),
                              height: 50,
                              width: 50,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Text(
                              adItem.ad_phone,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
//                                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailImage extends StatelessWidget {
  final AdItem imageitem;
  _DetailImage(this.imageitem);

  Widget _adImage(String imgads) {
    if (imgads == "0") {
      return Image.asset(
        "images/ads-logo.png",
        fit: BoxFit.fill,
      );
    } else {
      return Image.network(
        imgads,
        fit: BoxFit.fill,
      );
    }
  }

//  void _onImageShareButtonPressed() async {
//    File _image;
//    var response = await http.get(imageitem.ad_image);
//
//    var filePath =
//        await ImagePickerSaver.saveFile(fileData: response.bodyBytes);
//
//    String BASE64_IMAGE = filePath;
//
//    final ByteData bytes = await rootBundle.load(BASE64_IMAGE);
//    await Share.file(imageitem.ad_title, imageitem.ad_title,
//        bytes.buffer.asUint8List(), "png");
//
//
//  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(
          imageitem.ad_title,
          style: TextStyle(
            fontSize: 22,
            fontFamily: kfont,
          ),
        ),
        centerTitle: true,
        backgroundColor: kActionbarcolor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Container(
              height: double.infinity,
              width: double.infinity,
              margin: EdgeInsets.all(5.0),
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: kCardcolor,
              ),
              child: ClipRRect(
                  borderRadius: new BorderRadius.circular(10.0),
                  child: _adImage(imageitem.ad_image)),
            ),
          ),
//          IconButton(
//              icon: Icon(
//                Icons.share,
//                color: cardcolor,
//              ),
//              onPressed: () => _onImageShareButtonPressed()),
          SizedBox(
            height: 75.0,
          ),
        ],
      ),
    );
  }
}

class _DetailAd extends StatelessWidget {
  final AdItem _aditem;
  _DetailAd(this._aditem);

//  static Color actionbarcolor = Color.fromRGBO(145, 37, 113, 1);
//  static Color cardcolor = Color.fromRGBO(212, 66, 92, 1);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _aditem.ad_title,
          style: TextStyle(
            fontSize: 24,
            fontFamily: kfont,
          ),
        ),
        centerTitle: true,
        backgroundColor: kActionbarcolor,
      ),
      body: Container(
        margin: EdgeInsets.all(5.0),
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: kCardcolor,
        ),
        child: ListView(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                //ad title
                new Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: new Text(
                    this._aditem.ad_title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontFamily: "Tajawal",
                      fontWeight: FontWeight.bold,
                      // textBaseline: TextBaseline.alphabetic
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ),
                Divider(
                  height: 20,
                  thickness: 2.0,
                  color: Colors.white,
                  indent: 50,
                  endIndent: 50,
                ),
                SizedBox(
                  height: 10.0,
                ),
                //ad text about
                new Text(
                  this._aditem.ad_text,
                  style: TextStyle(
                      color: Colors.white, fontFamily: kfont, fontSize: 18),
                  textDirection: TextDirection.rtl,

//                   textAlign: TextAlign.end,
                ),

                Padding(
                    padding: EdgeInsets.only(
                  top: 30.0,
                )),
                //ad  date
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Text(
                      this._aditem.ad_date,
                      style: TextStyle(color: Colors.white, fontSize: 18),
                      textDirection: TextDirection.rtl,
//                   textAlign: TextAlign.end,
                    ),
                    SizedBox(
                      width: 40,
                    ),

                    GestureDetector(
                      onTap: () async {
                        String tel = _aditem.ad_phone;
                        var url = 'https://wa.me/+9$tel';
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      child: Image(
                        image: AssetImage("images/whatsicon.png"),
                        height: 30,
                        width: 30,
                      ),
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    // call ader  phone
                    InkWell(
                      child: Image(
                        image: AssetImage("images/adtele.png"),
                        height: 50,
                        width: 50,
                      ),
                      onTap: () {
                        String nom = _aditem.ad_phone;
                        launch("tel://$nom");
                      },
                    )
                  ],
                ),

                SizedBox(
                  height: 80.0,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
