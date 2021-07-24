import 'package:flutter/rendering.dart';
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
    // populating list of groups in the list of categories.
    // this.categories[0].populateGroups(databaseManager);
    // this.categories[1].populateGroups(databaseManager);
    // this.categories[2].populateGroups(databaseManager);

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
    // setting the last and the new Category Reference so that list of groups and
    // gradeResults will be populated depending on that.
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
    // user data Provider holding the data of users.
    userdataProvider = Provider.of<UserDataProvider>(context, listen: false);
    if (once) {
      print("runnign...");
      context.read<GroupProvider>().fetchGroups();
      once = false;
    }
    // context.watch<SelectedCategoryProvider>().selectedIndex;
    this.selectedIndex =
        context.watch<SelectedCategoryProvider>().selectedIndex;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
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
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Icon(
              Icons.image,
              // color: Colors.white,
            ),
            title: Text(
              Translation.translate(lang, "Icons") != null
                  ? Translation.translate(lang, "Icons")
                  : "Icons",
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 1,
                  color: Theme.of(context).primaryColor,
                ),
                Container(
                  // height: 100,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.elliptical(50, 40))),
                  // width: MediaQuery.of(context).size.width * 0.9,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              this.selectedIndex = 0;
                              context
                                  .read<SelectedCategoryProvider>()
                                  .setIndex(0);
                            });
                          },
                          child: Card(
                            elevation: context
                                        .watch<SelectedCategoryProvider>()
                                        .selectedIndex ==
                                    0
                                ? 10
                                : 0,
                            child: CategorySmallItem(
                                category: this.categories[0],
                                background: context
                                            .watch<SelectedCategoryProvider>()
                                            .selectedIndex ==
                                        0
                                    ? Colors.white
                                    : Theme.of(context).primaryColor,
                                color: context
                                            .watch<SelectedCategoryProvider>()
                                            .selectedIndex ==
                                        0
                                    ? Theme.of(context).primaryColor
                                    : Colors.white),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              this.selectedIndex = 1;
                              context
                                  .read<SelectedCategoryProvider>()
                                  .setIndex(1);
                            });
                          },
                          child: Card(
                            elevation: this.selectedIndex == 1 ? 10 : 0,
                            child: CategorySmallItem(
                                category: this.categories[1],
                                background: context
                                            .watch<SelectedCategoryProvider>()
                                            .selectedIndex ==
                                        1
                                    ? Colors.white
                                    : Theme.of(context).primaryColor,
                                color: context
                                            .watch<SelectedCategoryProvider>()
                                            .selectedIndex ==
                                        1
                                    ? Theme.of(context).primaryColor
                                    : Colors.white),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              this.selectedIndex = 2;
                              context
                                  .read<SelectedCategoryProvider>()
                                  .setIndex(2);
                            });
                          },
                          child: Card(
                            elevation: context
                                        .watch<SelectedCategoryProvider>()
                                        .selectedIndex ==
                                    2
                                ? 10
                                : 0,
                            child: CategorySmallItem(
                                category: this.categories[2],
                                background: context
                                            .watch<SelectedCategoryProvider>()
                                            .selectedIndex ==
                                        2
                                    ? Colors.white
                                    : Theme.of(context).primaryColor,
                                color: context
                                            .watch<SelectedCategoryProvider>()
                                            .selectedIndex ==
                                        2
                                    ? Theme.of(context).primaryColor
                                    : Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: this.categoryitems[
                context.watch<SelectedCategoryProvider>().selectedIndex],
          ),
        ],
      ),
    );
  }
}
