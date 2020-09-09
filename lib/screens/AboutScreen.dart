// import 'dart:html';
import 'dart:ui';

import 'package:DriversMobile/handlers/translation.dart';
import 'package:excel/excel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../handlers/translation.dart';
import '../handlers/sharedPreference.dart';
import '../widgets/navigation_drawer.dart';

class AboutScreen extends StatelessWidget {
  static const RouteName = "/about-us/";
  String lang;
  UserData userdata;
  bool once = true;

  final List<String> phones = [
    "+251 917335555",
    "+251 933335566",
    "+251 906682990",
    "0577754444",
  ];

  @override
  Widget build(BuildContext context) {
    if (once) {
      once = false;
      this.userdata = UserData.getInstance();
      userdata.initialize();
      this.lang = userdata.Lang;
    }
    return Scaffold(
      drawer: NavigationDrawer(
        containerContext: context,
        key: UniqueKey(),
        userdata: this.userdata,
      ),
      appBar: AppBar(
        title: Text(
          Translation.translate(lang, "About Us") != null
              ? Translation.translate(lang, "About Us")
              : "About Us",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            child: Text(
              "Shambel Drivers Training Institute \n ሻምበል የአሽከርካሪዎች ማሰልጠኛ ተቋም ",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          Container(
            height: 150,
            // width: double.infinity,
            child: SingleChildScrollView(
              clipBehavior: Clip.hardEdge,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    flex: 1,
                    child: Image.asset("assets/images/logo.png"),
                  ),
                  Expanded(
                    flex: 1,
                    child: Image.asset("assets/images/logo.png"),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: CircleAvatar(
                child: Icon(
              Icons.description,
            )),
            title: Text(
                Translation.translate(this.lang, "Description") != null
                    ? Translation.translate(this.lang, "Description")
                    : " Description",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    fontFeatures: [
                      FontFeature.oldstyleFigures(),
                    ])),
          ),
          Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.symmetric(horizontal: 10,),
            child: Text(
              Translation.translate(this.lang,
                          "Shambel Drivers Training Institute \n A driver is one of the most influential person in framing a positive opinion of the vehicle. A driver also ensures safety and security of public at large and plays a vital role in economical running of the vehicle. and  . We thrive to create intelligent and expert drivers and to create traffic accident free world.\n Come and Visit Us you shall have a better knowledge.") !=
                      null
                  ? Translation.translate(this.lang,
                      "Shambel Drivers Training Institute \n A driver is one of the most influential person in framing a positive opinion of the vehicle. A driver also ensures safety and security of public at large and plays a vital role in economical running of the vehicle. and  . We thrive to create intelligent and expert drivers and to create traffic accident free world.\n Come and Visit Us you shall have a better knowledge.")
                  : "Shambel Drivers Training Institute \n A driver is one of the most influential person in framing a positive opinion of the vehicle. A driver also ensures safety and security of public at large and plays a vital role in economical running of the vehicle. and  . We thrive to create intelligent and expert drivers and to create traffic accident free world.\n Come and Visit Us you shall have a better knowledge.",
              textAlign: TextAlign.justify,
            ),
          ),
          ListTile(
            title: Text(
                Translation.translate(this.lang, "Address") != null
                    ? Translation.translate(this.lang, "Address")
                    : "Address",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                )),
            leading: CircleAvatar(
              child: Icon(Icons.add_location),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              Translation.translate(this.lang,
                          "Gebriel Area , o4 Kebele  , Assosa , Benishangul Gumz ,Ethiopia ") !=
                      null
                  ? Translation.translate(this.lang,
                      "Gebriel Area , o4 Kebele  , Assosa , Benishangul Gumz ,Ethiopia ")
                  : "Gebriel Area , o4 Kebele  , Assosa , Benishangul Gumz ,Ethiopia ",
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          ListTile(
            leading: CircleAvatar(
                child: Icon(
              Icons.phone,
            )),
            title: Text(
              Translation.translate(this.lang, "Phones") != null
                  ? Translation.translate(this.lang, "Phones")
                  : "Phones",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Column(
            children: [
              ...phones.map((phone) {
                return Container(
                  padding: EdgeInsets.all(10),
                  // margin: EdgeInsets.symmetric(vertical: 3),
                  width: double.infinity,
                  child: Text(
                      phone,
                      textAlign: TextAlign.center,
                    ),
                );
              }).toList(),
            ],
          ) ,

          ListTile(
            leading : CircleAvatar(
              child : Icon(
                Icons.code
              )
            ),
                title : Text(
              Translation.translate(this.lang , "App Developer" , ) != null ? Translation.translate(this.lang , "App Developer" , ) : "App Developer",
          )
          ),
          
          ListTile(
            leading : Image.asset("assets/images/samuael.jpg"),
            title: Text(
                Translation.translate(this.lang, "Samuael Adnew") != null ? Translation.translate(this.lang, "Samuael Adnew") : "Samuael Adnew" ,
              style: TextStyle(
                fontWeight : FontWeight.bold ,
              ),
            ) ,
            subtitle: Column(
              children: [
                Text(
                  (Translation.translate(this.lang , "Phone") != null ? Translation.translate(this.lang , "Phone") : "Phone") + " : " +
                    "0992078204",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontWeight: FontWeight.bold  ,
                    fontStyle: FontStyle.italic,
                  ),
                ) ,
                Text(
                  (Translation.translate(this.lang , "Email") != null ? Translation.translate(this.lang , "Email") : "Email") + " : " +
                      "samuaeladnew.zebir@gmail.com\n\t" + (Translation.translate(this.lang , "Or ") != null ? Translation.translate(this.lang , "Or ") : "Or") + "\n\t"
                  "samuaeladnew@gmail.com",
                  style: TextStyle(
                    fontWeight: FontWeight.bold  ,
                    fontStyle: FontStyle.italic,
                  ),
                ) ,

              ],
            ),
          )
        ],
      )),
    );
  }
}
