import "package:flutter/material.dart";
import '../libs.dart';

class CategoryScreen extends StatefulWidget {
  static const RouteName = "/categories";
  CategoryScreen({Key key}) : super(key: key);

  static CategoryScreen _instance;

  static CategoryScreen getInstance() {
    if (CategoryScreen._instance == null) {
      _instance = CategoryScreen();
    }
    return _instance;
  }

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
  bool once = true;

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

  @override
  Widget build(BuildContext context) {
    if (userdata == null) {
      userdata = UserData.getInstance();
      userdata.initialize();
    }
    if (once) {
      this.categories[0].populateGroups(databaseManager).then((value) {
        setState(() {
          this.categories[0].groups = value;
          if (this.categoryitems[0] != null) {
            this.categoryitems[0] =
                CategoryItem(category: this.categories[0], lang: userdata.Lang);
          } else {
            this.categoryitems.add(CategoryItem(
                category: this.categories[0], lang: userdata.Lang));
          }
        });
      });
      this.categories[1].populateGroups(databaseManager).then((value) {
        setState(() {
          this.categories[1].groups = value;
          if (this.categoryitems[1] != null) {
            this.categoryitems[1] =
                CategoryItem(category: this.categories[1], lang: userdata.Lang);
          } else {
            this.categoryitems.add(CategoryItem(
                category: this.categories[1], lang: userdata.Lang));
          }
        });
      });
      once = false;
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          Translation.translate(lang, "Select Category") != null
              ? Translation.translate(lang, "Select Category ")
              : "Select Category",
        ),
      ),
      drawer: NavigationDrawer(
        containerContext: context,
        key: UniqueKey(),
        // userdata: this.userdata,
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
        unselectedItemColor: Colors.black87,
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
