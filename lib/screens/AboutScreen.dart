import 'package:DriversMobile/handlers/translation.dart';
import 'package:flutter/material.dart';
import '../handlers/translation.dart';
import '../handlers/sharedPreference.dart';

class AboutScreen extends StatelessWidget {
  String lang;
  UserData userdata;
  bool once = true;

  @override
  Widget build(BuildContext context) {
    if (once) {
      once = false;
      this.userdata = UserData.getInstance();
      userdata.initialize();
      this.lang = userdata.Lang;
    }
    return Scaffold(
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
        child : Column(
          children: <Widget>[
            
          ],
        )
      ),
    );
  }
}
