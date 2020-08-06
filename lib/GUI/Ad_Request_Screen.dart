import 'dart:convert';
import 'dart:io';

import 'package:adsapp/Ads_Department.dart';
import 'package:adsapp/HomeScreen.dart';
import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SendRequest extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SendRequestScreen();
  }
}

class _SendRequestScreen extends State<SendRequest> {
  static Color actionbarcolor = Color.fromRGBO(145, 37, 113, 1);
  static Color cardcolor = Color.fromRGBO(212, 66, 92, 1);

  var _ads_depart = [
    " اختر القسم الذي ترغب الاعلان فيه",
    "مطاعم وماركت",
    "بيوت وعقارات",
    "تكنولوجيا والكترونيات",
    "اليات وسيارات",
    "تعليم ومعاهد",
    "تجميل وأزياء",
    "مفروشات ومستعمل",
    "إعلانات متنوعة"
  ];

  String selected_depart = " اختر القسم الذي ترغب الاعلان فيه";

  // current value of the TextField.
  TextEditingController _ad_Title = new TextEditingController();
  TextEditingController _ad_Text = new TextEditingController();
  TextEditingController _ader_Name = new TextEditingController();
  TextEditingController _ader_Phone = new TextEditingController();
  TextEditingController _ader_Email = new TextEditingController();

  String errMessage = 'حدث خطأ أثناء الارسال.حاول مرة ثانية';

  Future<File> logo_file;
  String status = '';
  //for image
  String base64Image;
  File tmpFile;
  String MSG = 'لايوجد صورة للاعلان';

  Widget _showImage() {
    return FutureBuilder<File>(
      future: logo_file,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          tmpFile = snapshot.data;
          base64Image = base64Encode(snapshot.data.readAsBytesSync());
          return Image.file(
            snapshot.data,
            height: 100,
            width: 90,
            fit: BoxFit.fill,
          );
        } else if (null != snapshot.error) {
          return const Text(
            'لم يتم تحميل الصورة',
            style: TextStyle(
              fontFamily: 'Tajawal',
            ),
            textAlign: TextAlign.start,
          );
        } else {
          return const Text(
            'لايوجد صورة حالياً',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontFamily: 'Tajawal',
            ),
          );
        }
      },
    );
  }

  setStatus(String message) {
    setState(() {
      status = message;
    });
  }

//  _checkInternetConnectivity() async {
//    var connectivityResult = await (Connectivity().checkConnectivity());
//    if (connectivityResult == ConnectivityResult.none) {
//      // I am connected to a mobile network.
//      _showDialog(
//          'Internet access',
//          "You're connected over mobile data"
//      );
//    } else if (connectivityResult == ConnectivityResult.wifi) {
//    }
//
//  }

  Future _sendRequest() async {
    //  Getting value from Controller
    String title = _ad_Title.text;
    String text = _ad_Text.text;
    String ader_name = _ader_Name.text;
    String mobile = _ader_Phone.text;
    // String  email= _ader_Email.text;

    String ad_depart = selected_depart;

    //Check connectivity   WIFI  OR    NOBILE DATA or  not
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      // no  connecation.
      _showMessage(
          "لايوجد اتصال بالانترنت.يرجى التأكد من اتصالك بالانترنت قبل الارسال");
    } else {
      // التاكد من تعبئة حميع البيانات
      if (title == "" || text == "" || ader_name == "" || mobile == ""
          //  || selected_depart == " اختر القسم الذي ترغب الاعلان فيه"
          ) {
        _showMessage("يرجى ملء جميع الحقول المطلوبة");
      } else {
        //  ارسال البيانات
        // API URL
        var url = "http://mix-apps.a2hosted.com/add_request.php";

        setStatus('يتم إرسال الطلب .......');

        if (base64Image == null) {
          await http.post(url, body: {
            "ad_title": _ad_Title.text,
            "text": _ad_Text.text,
            "ader_name": _ader_Name.text,
            "mobile": _ader_Phone.text,
            "e_mail": _ader_Email.text,
            "ad_depart": selected_depart,
          }).then((result) {
            result.statusCode == 200 ? _showMessage(result.body) : errMessage;
          }).catchError((error) {
            setStatus(error);
          });
        } else {
          //setStatus('يتم إرسال الطلب مع صورة.......');
          String fileName = tmpFile.path.split('/').last;
          await http.post(url, body: {
            "ad_title": _ad_Title.text,
            "text": _ad_Text.text,
            "ader_name": _ader_Name.text,
            "mobile": _ader_Phone.text,
            "e_mail": _ader_Email.text,
            "ad_depart": selected_depart,
            "image": base64Image,
            "img_name": fileName,
          }).then((result) {
            result.statusCode == 200 ? _showMessage(result.body) : errMessage;
          }).catchError((error) {
            setStatus(error);
          });
        }
      }
    }
  }

  _showMessage(String msg) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            title: new Text(
              msg,
              style: TextStyle(
                fontFamily: 'Tajawal',
              ),
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
            ),
            actions: <Widget>[
              FlatButton(
                child: new Text(
                  "OK",
                  style: TextStyle(
                      color: actionbarcolor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  setStatus("");
                  _ad_Title.clear();
                  _ad_Text.clear();
                  _ader_Name.clear();
                  _ader_Phone.clear();
                  _ader_Email.clear();
                },
              ),
            ],
          );
        });
  }

  // Showing Alert Dialog with Response JSON.
//   _showAlert(String msg){
//    showDialog(
//        context: context,
//        builder: (BuildContext context) {
//          return AlertDialog(
//            titlePadding: EdgeInsets.all(5.0),
//           // backgroundColor: cardcolor,
//            shape: RoundedRectangleBorder(
//                borderRadius:
//                BorderRadius.circular(20.0)) ,
//
//             title: new Text(msg,
//               style: TextStyle(fontFamily: "Tajawal",fontWeight: FontWeight.bold),
//               textDirection: TextDirection.rtl,
//               textAlign: TextAlign.right,
//
//             ),
//
//             actions: <Widget>[
//               FlatButton(
//                 child: new Text("OK",
//                 style: TextStyle(color: actionbarcolor,fontWeight: FontWeight.bold,
//                   fontSize: 20.0,
//                 ),),
//                 onPressed: () {
//                   setStatus("");
//                   _ad_Title.clear();
//                   _ad_Text.clear();
//                   _ader_Name.clear();
//                   _ader_Phone.clear();
//                   _ader_Email.clear();
//                   selected_depart=" اختر القسم الذي ترغب الاعلان فيه";
//
//                   Navigator.of(context).pop();
//
//                   //                   Navigator.push(
////                     context,
////                     MaterialPageRoute(builder: (context) => AdsScreen()),
////                   );
//
//                 },
//               ),
//             ],
//           );
//        }
//    );
//  }

  @override
  void dispose() {
    // TODO: implement dispose
    // Clean up the controller when the widget is disposed.
    _ad_Title.dispose();
    _ad_Text.dispose();
    _ader_Name.dispose();
    _ader_Phone.dispose();
    _ader_Email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "طلب إضافة إعلان",
          style: TextStyle(
            fontSize: 24,
            fontFamily: "Tajawal",
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: new Image.asset(
              "images/home_page.png",
            ),
            tooltip: 'عودة للصفحة الرئيسية',
            padding: EdgeInsets.only(right: 15.0),
            iconSize: (35.0),
            onPressed: () {
              Navigator.push(
                context,
                new MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            },
          )
        ],
        centerTitle: true,
        backgroundColor: actionbarcolor,
      ),
      body: ListView(
        padding: EdgeInsets.all(8.0),
        children: <Widget>[
          //note   *   nessecry
          new Text(
            "العلامة * تعني ان الحقل مطلوب ",
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 16.0,
              fontFamily: "Tajawal",
              color: cardcolor,
              fontWeight: FontWeight.bold,
            ),
          ),

          //ader   name
          new TextField(
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                borderSide: BorderSide(width: 1, color: actionbarcolor),
              ),

              border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  const Radius.circular(20.0),
                ),
                // borderSide: new BorderSide(width: 2,color:actionbarcolor)
              ),
//               labelText: 'ادخل اسم صاحب الاعلان',
//               labelStyle:TextStyle(color: actionbarcolor,),
              hintText: 'ادخل اسم صاحب الاعلان',
              hintStyle:
                  TextStyle(fontFamily: 'Tajawal', color: actionbarcolor),
              contentPadding: EdgeInsets.only(left: 50.0),
              //prefixIcon: Icon(Icons.star,color: actionbarcolor,),
              suffixIcon: Icon(
                Icons.star,
                color: cardcolor,
              ),
            ),
            cursorColor: cardcolor,
            maxLength: 30,
            maxLines: 1,
            showCursor: true,
            keyboardType: TextInputType.text,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: actionbarcolor,
            ),
            controller: _ader_Name,
          ),
          //phone
          new TextField(
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                borderSide: BorderSide(width: 1, color: actionbarcolor),
              ),

              border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  const Radius.circular(20.0),
                ),
                // borderSide: new BorderSide(width: 2,color:actionbarcolor)
              ),
//               labelText: 'ادخل رقم هاتف للتواصل',
//
//               labelStyle:TextStyle(color: actionbarcolor,),
              hintText: 'ادخل رقم هاتف للتواصل',
              hintStyle:
                  TextStyle(fontFamily: 'Tajawal', color: actionbarcolor),

              contentPadding: EdgeInsets.only(left: 50.0),
              //prefixIcon: Icon(Icons.star,color: actionbarcolor,),
              suffixIcon: Icon(
                Icons.star,
                color: cardcolor,
              ),
            ),
            cursorColor: cardcolor,
            maxLength: 15,
            maxLines: 1,
            showCursor: true,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: actionbarcolor,
            ),
            controller: _ader_Phone,
          ),

          // email
          new TextField(
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                borderSide: BorderSide(width: 1, color: actionbarcolor),
              ),
              border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  const Radius.circular(20.0),
                ),
              ),
              hintText: 'ادخل ايميل إن وجد',
              hintStyle:
                  TextStyle(fontFamily: 'Tajawal', color: actionbarcolor),
              contentPadding: EdgeInsets.only(left: 50.0),
              suffixIcon: Icon(
                Icons.star,
                color: Colors.white,
              ),
            ),
            cursorColor: cardcolor,
            maxLength: 50,
            maxLines: 1,
            showCursor: true,
            keyboardType: TextInputType.emailAddress,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: actionbarcolor,
            ),
            controller: _ader_Email,
          ),

          //  ads   title
          new TextField(
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                borderSide: BorderSide(width: 1, color: actionbarcolor),
              ),

              border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  const Radius.circular(20.0),
                ),
                // borderSide: new BorderSide(width: 2,color:actionbarcolor)
              ),
              // labelText: 'ادخل عنوان الاعلان',
              //labelStyle:TextStyle(color: actionbarcolor,),

              hintText: 'ادخل عنوان الاعلان',
              hintStyle:
                  TextStyle(fontFamily: 'Tajawal', color: actionbarcolor),

              contentPadding: EdgeInsets.only(left: 50.0),
              //prefixIcon: Icon(Icons.star,color: actionbarcolor,),
              suffixIcon: Icon(
                Icons.star,
                color: cardcolor,
              ),
            ),
            cursorColor: cardcolor,
            maxLength: 30,
            maxLines: 1,
            showCursor: true,
            keyboardType: TextInputType.text,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: actionbarcolor,
            ),
            controller: _ad_Title,
          ),
          //ad_Text
          new TextField(
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                borderSide: BorderSide(width: 1, color: actionbarcolor),
              ),

              border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  const Radius.circular(20.0),
                ),
                // borderSide: new BorderSide(width: 2,color:actionbarcolor)
              ),
              // labelText: 'ادخل نص الاعلان',
              // labelStyle:TextStyle(color: actionbarcolor,),
              hintText: 'ادخل نص الاعلان',
              hintStyle:
                  TextStyle(fontFamily: 'Tajawal', color: actionbarcolor),
              contentPadding: EdgeInsets.only(left: 50.0),
              //prefixIcon: Icon(Icons.star,color: actionbarcolor,),
              suffixIcon: Icon(
                Icons.star,
                color: cardcolor,
              ),
            ),
            textDirection: TextDirection.rtl,
            cursorColor: cardcolor,
            maxLength: 500,
            maxLines: 3,
            showCursor: true,
            keyboardType: TextInputType.text,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: actionbarcolor,
            ),
            controller: _ad_Text,
          ),

          Row(
            // crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              DropdownButton<String>(
                items: _ads_depart.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item,
                        // textDirection: TextDirection.rtl,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: actionbarcolor, fontFamily: 'Tajawal')),
                  );
                }).toList(),
                style: TextStyle(color: cardcolor, fontSize: 18),
                isDense: true,
                onChanged: (String depart) {
                  setState(() {
                    selected_depart = depart;
                  });
                },
                value: selected_depart,
                isExpanded: false,
                underline: Container(
                  decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.pink))),
                ),
              ),
              Icon(
                Icons.star,
                color: Colors.white,
              )
            ],
          ),
          SizedBox(
            height: 15,
          ),

          // اضافة لوغو للاعلان
          Row(
            //crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              _showImage(),

//             logo != null? logo:new Text("لايوجد لوغو حاليا",
//             style:TextStyle(
//               fontFamily: 'Tajawal',
//               color: actionbarcolor,
//             ),) ,

              SizedBox(
                width: 15,
              ),

              Expanded(
                child: new RaisedButton(
                  onPressed: () {
                    setState(() {
                      logo_file =
                          ImagePicker.pickImage(source: ImageSource.gallery);
                    });
                  },

/////////////////////////////////
                  color: cardcolor,
                  child: new Text(
                    "تحميل لوغو لإعلانك إن وجد",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Tajawal'),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),

          //  send   btn
          Center(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 30.0, right: 30, top: 10.0, bottom: 10.0),
              child: RaisedButton(
                color: actionbarcolor,
                //padding: EdgeInsets.all(10.0),
                child: Text("إرسال الطلب",
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Tajawal',
                        fontWeight: FontWeight.bold)),
                textColor: Colors.white,
                splashColor: cardcolor,
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0),
                    side: BorderSide(color: Colors.white)),

                onPressed: () {
                  _sendRequest();
                },
              ),
            ),
          ),

          //status
          Text(
            status,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: cardcolor,
              fontWeight: FontWeight.bold,
              fontFamily: 'Tajawal',
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 50,
          ),
        ],
      ),
//      bottomNavigationBar: Container(
//        height: 50.0,
//        color: Colors.white,
//      ),
    );
  }
}
