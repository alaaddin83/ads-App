import 'package:adsapp/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),

      home: SplashScreen(),
      routes: <String, WidgetBuilder>{
        '/homescreen': (BuildContext context) => new HomeScreen(),
        //'resturantPage': (BuildContext context) => new ResturantPage(),
      },

      //        localizationsDelegates: [
//          GlobalMaterialLocalizations.delegate,
//          GlobalWidgetsLocalizations.delegate,
//        ],
//        supportedLocales: [
//          Locale("ar"), // OR Locale('ar', 'AE') OR Other RTL locales
//        ],
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SplashScreen();
  }
}

class _SplashScreen extends State<SplashScreen> {
//  static Color actionbarcolor = Color.fromRGBO(145, 37, 113, 1);
//  static Color cardcolor = Color.fromRGBO(212, 66, 92, 1);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    const duration = Duration(seconds: 3);

    new Timer(duration, () {
      // Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed('/homescreen');
//      Navigator.push(
//        context,
//        MaterialPageRoute(builder: (context) => HomeScreen()),
//      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      body: Center(
        child: Container(
//        width: MediaQuery.of(context).size.width,
//        height: MediaQuery.of(context).size.height,
// height: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/background.png"),
                  fit: BoxFit.cover)),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(padding: EdgeInsets.only(top: 50)),

              new Image(
                image: new AssetImage("images/logo.png"),
              ),

//              Padding(padding: EdgeInsets.only(bottom: 15, top: 40)),

//           LinearProgressIndicator(valueColor:
//           new AlwaysStoppedAnimation<Color>(cardcolor),
//             backgroundColor: Colors.white,),

//              CircularProgressIndicator(
//                valueColor: new AlwaysStoppedAnimation<Color>(cardcolor),
//                backgroundColor: Colors.white,
//              ),
              Padding(padding: EdgeInsets.only(top: 100)),
//              Text("By",
//                textAlign: TextAlign.end,
//                style: TextStyle(
//                    color: Colors.black,
//                    fontSize: 30,
//                    fontStyle: FontStyle.normal,
//                    fontFamily: "SourceSansPro"),
//              ),
              Expanded(
                child: Image(
                  image: new AssetImage(
                    "images/my_logo.png",
                  ),
                  height: 200,
                  width: 300,
                ),
              ),
              Padding(padding: EdgeInsets.only(bottom: 30)),
            ],
          ),
        ),
      ),
    );

    // return SplashScreen();
  }
}
