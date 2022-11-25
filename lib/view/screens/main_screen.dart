import 'package:app/view/screens/aboutscreen/about.dart';
import 'package:app/view/screens/mainscreen/areacontrol_screen.dart';
import 'package:app/view/screens/mainscreen/limitedresources_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:app/model/article.dart';
import 'package:app/model/rule.dart';
import 'package:app/model/volunteer.dart';
import 'package:app/services/setup_locator.dart';
import 'package:app/view/screens/mainscreen/articles_screen.dart';
import 'package:app/view/screens/mainscreen/volunteer_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'mainscreen/home_screen.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  int _index;
  GlobalKey _bottomNavigationKey;
  @override
  void initState() {
    super.initState();
    _index = 2;
    _bottomNavigationKey = new GlobalKey();
    _tabController = new TabController(
      length: 5,
      vsync: this,
      initialIndex: _index,
    );
    _tabController.addListener(() {
      // changeBarIndex(_tabController.index);

      setState(() {
        _index = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<List<Rule>>.value(
          value: locators.databaseService.rulesStream,
        ),
        StreamProvider<List<Volunteer>>.value(
          value: locators.databaseService.volunteersStream,
          catchError: (context, error) => null,
        ),
        StreamProvider<List<ArchivedArticle>>.value(
          value: locators.databaseService.archiveArticlesStream,
          catchError: (context, error) => null,
        ),
        StreamProvider<List<RecommendationArticle>>.value(
          value: locators.databaseService.recommendationArticlesStream,
          catchError: (context, error) => null,
        ),
        StreamProvider<List<ProceduralArticle>>.value(
          value: locators.databaseService.proceduralArticlesStream,
          catchError: (context, error) => null,
        ),
        StreamProvider<LatLng>.value(value: locators.mapService.homepoint),
      ],
      builder: (context, child) => Scaffold(
        body: Stack(
          children: [
            IndexedStack(
              children: [
                LimitedResourcesScreen(),
                AreaControlScreen(),
                HomeScreen(Colors.deepPurple),
                VolunteerScreen(Colors.deepOrange[300]),
                ArticlesScreen(Colors.deepOrange[900]),
              ],
              index: _index,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CurvedNavigationBar(
                  animationDuration: Duration(milliseconds: 200),
                  animationCurve: Curves.easeInOutQuart,
                  height: 75,
                  key: _bottomNavigationKey,
                  index: _index,
                  buttonBackgroundColor: Color(0xFF4F89F7),
                  backgroundColor: Colors.transparent,
                  color: const Color(0xFF6695F0),
                  items: <Widget>[
                    Icon(
                      Icons.shopping_cart,
                      size: 35,
                      color: Colors.white,
                    ),
                    Icon(
                      Icons.map,
                      size: 35,
                      color: Colors.white,
                    ),
                    Icon(
                      Icons.home,
                      size: 35,
                      color: Colors.white,
                    ),
                    Icon(
                      Icons.accessibility_new,
                      size: 35,
                      color: Colors.white,
                    ),
                    Icon(
                      Icons.assignment,
                      size: 35,
                      color: Colors.white,
                    ),
                  ],
                  onTap: (index) {
                    //Handle button tap
                    setState(() {
                      _index = index;
                    });
                  },
                ),
              ],
            ),
            Container(
                margin: EdgeInsets.only(top: 30),
                child: IconButton(
                  icon: Icon(Icons.info_outline),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (cntx) => AboutScreen()));
                  },
                  iconSize: 30,
                ))
          ],
        ),
      ),
    );
  }

  void changeBarIndex(int index) {
    final CurvedNavigationBarState navBarState =
        _bottomNavigationKey.currentState;
    navBarState.setPage(index);
  }
}
