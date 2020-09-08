import '../widgets/CategoryItem.dart';
import 'package:excel/excel.dart';
import "package:flutter/material.dart";
import "../widgets/navigation_drawer.dart";
import '../handlers/sharedPreference.dart';
import '../db/dbsqflite.dart';
import '../handlers/translation.dart';

class CategoryScreen extends StatefulWidget {
  static const RouteName = "/categories";
  CategoryScreen({Key key}) : super(key: key);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  UserData userdata;
  bool motors = false;
  bool others = false;
  List<Category> categories;
  DatabaseManager databaseManager;
  String lang;
  int selectedIndex = 0;
  List<CategoryItem> categoryitems = [];

  @override
  void initState() {
    if (userdata == null) {
      userdata = UserData.getInstance();
      userdata.initialize();
    }
    databaseManager = DatabaseManager.getInstance();
    this.categories = DatabaseManager.categories;
    this.categories[0].populateGroups(databaseManager);
    this.categories[1].populateGroups(databaseManager);
    this.userdata = UserData.getInstance();
    this.userdata.GetLanguage().then((lang) {
      this.lang = lang;
    });

    this
        .categoryitems
        .add(CategoryItem(category: this.categories[0], lang: userdata.Lang));
    this
        .categoryitems
        .add(CategoryItem(category: this.categories[1], lang: userdata.Lang));
    super.initState();
  }

  Future<void> initialize() async {
    
  }

  @override
  Widget build(BuildContext context) {
    if (userdata == null) {
      userdata = UserData.getInstance();
      userdata.initialize();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
            Translation.translate(lang, "Categories ") != null
                ? Translation.translate(lang, "Categories ")
                : "Categories"),
      ),
      drawer: NavigationDrawer(
        containerContext: context,
        key: UniqueKey(),
        userdata: this.userdata,
      ),
      bottomNavigationBar: BottomNavigationBar(
        // onTap: selectedIndexSet,
        onTap: (int index) {
          setState(() {
            this.selectedIndex = index;
          });
          // print("selected Index is : $selectedIndex");
        },
        backgroundColor: Theme.of(context).primaryColor,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black87 ,
        currentIndex: selectedIndex,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Icon(
              Icons.motorcycle,
              // color: Colors.white,
            ),
            title: Text(Translation.translate(lang, "Motor cycle") != null
                ? Translation.translate(lang, "Motor cycle")
                : "Motor cycle"),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.local_car_wash,
            ),
            title: Text(Translation.translate(lang, "Other Vehicles") != null
                ? Translation.translate(lang, "Other Vehicles")
                : "Other Vehicles"),
          ),
        ],
      ),
      body: this.categoryitems[selectedIndex],
    );
  }
}
