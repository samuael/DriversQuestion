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
              "Saddle Dam Drivers Training Institute \n ሳድል ዳም የአሽከርካሪዎች ማሰልጠኛ ተቋም ",
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

          Container(
            width: double.infinity,
            height: 300,
            child: new ListView.builder(
              itemCount: imageNames.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  // onTap: ()=>changeTheme(context  , index),
                  child: Container(
                    // height: 120,
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    width: 200,
                    child: Image.asset("${imageNames[index]}"),
                  ),
                );
              },
              scrollDirection: Axis.horizontal,
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
                    color: Theme.of(context).textTheme.body1.color,
                    fontFeatures: [
                      FontFeature.oldstyleFigures(),
                    ])),
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
                          "Saddle Dam Drivers Training Institute \nWe thrive to create intelligent and expert drivers and to create traffic accident free world.\n Come and Visit Us you shall have a better knowledge.") !=
                      null
                  ? Translation.translate(this.lang,
                      "Saddle Dam Drivers Training Institute \nWe thrive to create intelligent and expert drivers and to create traffic accident free world.\n Come and Visit Us you shall have a better knowledge.")
                  : "Saddle Dam Drivers Training Institute \nWe thrive to create intelligent and expert drivers and to create traffic accident free world.\n Come and Visit Us you shall have a better knowledge.",
              textAlign: TextAlign.justify,
              style: TextStyle(
                color: Theme.of(context).textTheme.body1.color,
              ),
            ),
          ),
          // ListTile(
          //   title: Text(
          //       Translation.translate(this.lang, "Address") != null
          //           ? Translation.translate(this.lang, "Address")
          //           : "Address",
          //       style: TextStyle(
          //         fontSize: 18,
          //         fontWeight: FontWeight.bold,
          //         color:Theme.of(context).textTheme.body1.color,
          //       )),
          //   leading: CircleAvatar(
          //     child: Icon(Icons.add_location),
          //   ),
          // ),
          // Container(
          //   padding: EdgeInsets.all(10),
          //   margin: EdgeInsets.symmetric(horizontal: 10),
          //   child: Text(
          //     Translation.translate(this.lang,
          //                 "Gebriel Area , o4 Kebele  , Assosa , Benishangul Gumz ,Ethiopia ") !=
          //             null
          //         ? Translation.translate(this.lang,
          //             "Gebriel Area , o4 Kebele  , Assosa , Benishangul Gumz ,Ethiopia ")
          //         : "Gebriel Area , o4 Kebele  , Assosa , Benishangul Gumz ,Ethiopia ",
          //     textAlign: TextAlign.justify,
          //     style: TextStyle(
          //       fontStyle: FontStyle.italic,
          //     ),
          //   ),
          // ),
          // ListTile(
          //   leading: CircleAvatar(
          //       child: Icon(
          //     Icons.phone,
          //   )),
          //   title: Text(
          //     Translation.translate(this.lang, "Phones") != null
          //         ? Translation.translate(this.lang, "Phones")
          //         : "Phones",
          //     style: TextStyle(
          //       fontWeight: FontWeight.bold,
          //       color:Theme.of(context).textTheme.body1.color,
          //     ),
          //   ),
          // ),
          // Column(
          //   children: [
          //     ...phones.map((phone) {
          //       return Container(
          //         padding: EdgeInsets.all(10),
          //         // margin: EdgeInsets.symmetric(vertical: 3),
          //         width: double.infinity,
          //         child: Text(
          //             phone,
          //             textAlign: TextAlign.center,
          //           ),
          //       );
          //     }).toList(),
          //   ],
          // ) ,

          Container(
            color: Theme.of(context).primaryColor,
            child: SizedBox(),
          ),

          ListTile(
            title: Text(
                Translation.translate(this.lang, "Address") != null
                    ? Translation.translate(this.lang, "Address")
                    : "Address",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.body1.color,
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
                          "Hawasa : Ethiopia  , Atotet : Wolde Amanuael Road infront of Hayole School") !=
                      null
                  ? Translation.translate(this.lang,
                      "Hawasa : Ethiopia  , Atotet : Wolde Amanuael Road infront of Hayole School")
                  : "Hawasa : Ethiopia  , Atotet : Wolde Amanuael Road infront of Hayole School",
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
                color: Theme.of(context).textTheme.body1.color,
              ),
            ),
          ),
          Column(
            children: [
              ...phonesHawassa.map((phone) {
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
                        ) !=
                        null
                    ? Translation.translate(
                        this.lang,
                        "Email",
                      )
                    : "Email",
                style: TextStyle(
                  color: Theme.of(context).textTheme.body1.color,
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
                        ) !=
                        null
                    ? Translation.translate(
                        this.lang,
                        "App Developer",
                      )
                    : "App Developer",
                style: TextStyle(
                  color: Theme.of(context).textTheme.body1.color,
                ),
              )),

          Row(
            children: [
              Expanded(
                flex: 2,
                child: ListTile(
                  // leading : Image.asset("assets/images/samuael.jpg"),
                  title: Text(
                    Translation.translate(this.lang, "Samuael Adnew") != null
                        ? Translation.translate(this.lang, "Samuael Adnew")
                        : "Samuael Adnew",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.body1.color,
                    ),
                  ),
                  subtitle: Column(
                    children: [
                      Text(
                        (Translation.translate(this.lang, "Phone") != null
                                ? Translation.translate(this.lang, "Phone")
                                : "Phone") +
                            " : " +
                            "0992078204",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          color: Theme.of(context).textTheme.body1.color,
                        ),
                      ),
                      Text(
                        (Translation.translate(this.lang, "Email") != null
                                ? Translation.translate(this.lang, "Email")
                                : "Email") +
                            " : " +
                            "samuaeladnew.zebir@gmail.com\n\t" +
                            (Translation.translate(this.lang, "Or ") != null
                                ? Translation.translate(this.lang, "Or ")
                                : "Or") +
                            "\n\t"
                                "samuaeladnew@gmail.com",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          color: Theme.of(context).textTheme.body1.color,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      )),
    );
  }
}
