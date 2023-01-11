// import 'dart:html';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../libs.dart';

class AboutScreen extends StatelessWidget {
  static const RouteName = "/about-us/";
  String lang;
  UserData userdata;
  bool once = true;

  final List<String> phones = [
    "+251 917335555",
    "+251 933335566",
    "+251 906682990",
    "+251-577754444",
  ];
  final List<String> phonesHawassa = [
    "+251909531439",
    "+251938008050",
    "0942429898",
  ];
  final List<String> imageNames = [
    "assets/images/onewTwo.jpeg",
    "assets/images/photo5967444311891096430.jpg",
    "assets/images/photo5967444311891096429.jpg",
    // "assets/images/logo.png" ,
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
        // userdata: this.userdata,
      ),
      appBar: AppBar(
        elevation: 0,
        title: Text(
          Translation.translate(lang, "About Us"),
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Theme.of(context).primaryColor,
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    borderRadius:
                        BorderRadius.only(topLeft: Radius.elliptical(200, 50))),
                padding: EdgeInsets.all(10),
                child: Text(
                  "Shambel Dam Drivers Training Institute \nሻምበል የአሽከርካሪዎች ማሰልጠኛ ተቋም ",
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
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.elliptical(120, 50))),
                child: SingleChildScrollView(
                  clipBehavior: Clip.hardEdge,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        height: 160,
                        width: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Image.asset(
                          "assets/images/logo.png",
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Container(
              //   width: double.infinity,
              //   height: 300,
              //   decoration: BoxDecoration(
              //       color: Theme.of(context).canvasColor,
              //       borderRadius:
              //           BorderRadius.only(topLeft: Radius.elliptical(200, 50))),
              //   child: new ListView.builder(
              //     itemCount: imageNames.length,
              //     itemBuilder: (BuildContext context, int index) {
              //       return InkWell(
              //         // onTap: ()=>changeTheme(context  , index),
              //         child: Container(
              //           // height: 120,
              //           margin: EdgeInsets.symmetric(horizontal: 5),
              //           width: 200,
              //           child: Image.asset("${imageNames[index]}"),
              //         ),
              //       );
              //     },
              //     scrollDirection: Axis.horizontal,
              //   ),
              // ),

              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.elliptical(120, 50),
                  ),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                      child: Icon(
                    Icons.description,
                  )),
                  title: Text(Translation.translate(this.lang, "Description"),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Theme.of(context).textTheme.bodyMedium.color,
                          fontFeatures: [
                            FontFeature.oldstyleFigures(),
                          ])),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: Text(
                  Translation.translate(
                      this.lang,
                      // "Saddle Dam Drivers Training Institute \nWe thrive to create intelligent and expert drivers and to create traffic accident free world.\n Come and Visit Us you shall have a better knowledge." ) !=
                      "Shambel Drivers Training Institute \nWe thrive to create intelligent and expert drivers and to create traffic accident free surrounding.\n Come and Visit Us you shall have a better knowledge."),
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyMedium.color,
                  ),
                ),
              ),
              Container(
                color: Theme.of(context).primaryColor,
                child: SizedBox(),
              ),

              ListTile(
                title: Text(Translation.translate(this.lang, "Address"),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyMedium.color,
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
                      "Gebriel Area , o4 kebele  , Assosa , Benishangul Gumz ,Ethiopia"),
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
                  Translation.translate(this.lang, "Phones"),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyMedium.color,
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
              ),

              ListTile(
                  leading: CircleAvatar(child: Icon(Icons.code)),
                  title: Text(
                    Translation.translate(
                      this.lang,
                      "Email",
                    ),
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium.color,
                    ),
                  )),
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "shambel1987@gmial.com",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),

              ListTile(
                  leading: CircleAvatar(child: Icon(Icons.code)),
                  title: Text(
                    Translation.translate(
                      this.lang,
                      "App Developer",
                    ),
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium.color,
                    ),
                  )),

              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: ListTile(
                      // leading : Image.asset("assets/images/samuael.jpg"),
                      title: Text(
                        Translation.translate(this.lang, "Samuael Adnew"),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.bodyMedium.color,
                        ),
                      ),
                      subtitle: Column(
                        children: [
                          Text(
                            Translation.translate(this.lang, "Phone") +
                                " : " +
                                "0992078204",
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              color:
                                  Theme.of(context).textTheme.bodyMedium.color,
                            ),
                          ),
                          Text(
                            Translation.translate(this.lang, "Email") +
                                " : " +
                                "samuaeladnew.zebir@gmail.com\n\t" +
                                Translation.translate(this.lang, "Or ") +
                                "\n\t"
                                    "samuaeladnew@gmail.com",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              color:
                                  Theme.of(context).textTheme.bodyMedium.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
