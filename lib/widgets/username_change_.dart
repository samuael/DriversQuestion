import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import '../libs.dart';

class ChangeUsername extends StatefulWidget {
  const ChangeUsername({Key key}) : super(key: key);

  @override
  State createState() {
    return ChangeUsernameState();
  }
}

class ChangeUsernameState extends State<ChangeUsername> {
  String usernameText = "";
  TextEditingController usernameController = new TextEditingController();
  UserDataProvider userdataProvider;

  /// representing whether the color of username can be Warning(red) or Success(green)
  Color usernameTextColor = Colors.red;

  void changeUsername() {
    setState(() {
      this.usernameText = usernameController.text;
      if (this.usernameText.length <= 2) {
        this.usernameText =
            "Invalid Character Length \n Character Length Has to be greater than 2";
        this.usernameTextColor = Colors.red;
      } else {
        this.userdataProvider.setUsername(this.usernameText);
        /*
      * *
      * *
      */
        this.usernameText = "Username Changed Succesfully ";
        this.usernameTextColor = Colors.green;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    userdataProvider = Provider.of<UserDataProvider>(context, listen: true);
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.elliptical(200, 50),
          ),
        ),
        child: Column(
          children: <Widget>[
            Text(
              Translation.translate(
                  this.userdataProvider.language, usernameText),
              style: TextStyle(
                color: usernameTextColor,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
            Container(
              height: 40,
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 10),
              constraints: const BoxConstraints(
                maxWidth: 500,
              ),
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: CupertinoTextField(
                // autofocus: true,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                controller: usernameController,
                // keyboardType: TextInputType.passwords,
                maxLines: 1,
                placeholder: Translation.translate(
                    context.watch<UserDataProvider>().language, ' Username '),
              ),
            ),
            ElevatedButton(
              // textColor: Colors.white,
              // padding: EdgeInsets.all(5),
              // color: Theme.of(context).primaryColor,
              // splashColor: Colors.white24,
              onPressed: changeUsername,
              child: Text(
                Translation.translate(
                    context.watch<UserDataProvider>().language, "Submit"),
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
