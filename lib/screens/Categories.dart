import "package:flutter/material.dart";
import 'package:provider/provider.dart';
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
  bool icons = false;
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
    this
        .categoryitems
        .add(CategoryItem(category: this.categories[2], lang: userdata.Lang));
    super.initState();
  }

  UserDataProvider userdataProvider;
  @override
  Widget build(BuildContext context) {
    if (userdata == null) {
      userdata = UserData.getInstance();
      userdata.initialize();
    }
    userdataProvider = Provider.of<UserDataProvider>(context, listen: false);
    if (once) {
      context.read<GroupProvider>().fetchGroups();
      once = false;
    }
    this.selectedIndex =
        context.watch<SelectedCategoryProvider>().selectedIndex;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          Translation.translate(lang, "Select Category"),
        ),
      ),
      drawer: NavigationDrawer(
        containerContext: context,
        key: UniqueKey(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int index) {
          setState(() {
            this.selectedIndex = index;
            context.read<SelectedCategoryProvider>().setIndex(index);
          });
        },
        backgroundColor: Theme.of(context).primaryColor,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black87,
        currentIndex: context.watch<SelectedCategoryProvider>().selectedIndex,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Icon(
              Icons.motorcycle,
            ),
            label: Translation.translate(lang, "Motor cycle"),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.local_car_wash,
            ),
            label: Translation.translate(lang, "Other Vehicles"),
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Icon(
              Icons.image,
            ),
            label: Translation.translate(lang, "Icons"),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 1,
                  height: MediaQuery.of(context).size.height * 0.03,
                  color: Theme.of(context).primaryColor,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  height: MediaQuery.of(context).size.height * 0.03,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.elliptical(10, 10),
                          topRight: Radius.elliptical(10, 10))),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
              ],
            ),
            this.categoryitems[
                context.watch<SelectedCategoryProvider>().selectedIndex],
          ],
        ),
      ),
    );
  }
}
