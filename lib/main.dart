import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:capstone1/constant/globalKeys.dart';
import 'package:capstone1/providers/infomation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:capstone1/settingPage/setting.dart';
import 'package:capstone1/providers/authentication.dart';
import 'providers/user.dart';
import 'providers/stock.dart';
import 'authPage/userPage.dart';
import 'firebase_options.dart';

import 'firstPages/firstPage.dart';
import 'rankPage/ranking.dart';
import 'homePage/home.dart';
import 'router.dart';
import 'searchPage/search.dart';

final auth = FirebaseAuth.instance;

void main() async {
  //firebase setting code
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual, overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (c) => TabProvider()),
          ChangeNotifierProvider(create: (c) => UserProvider()),
          ChangeNotifierProvider(create: (c) => StockProvider()),
          ChangeNotifierProvider(create: (c) => AuthProvider()),
          ChangeNotifierProvider(create: (c) => InfoProvider()),
        ],
        child: MaterialApp.router(
          routerConfig: router,
          debugShowCheckedModeBanner: false,
        ),
      )
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with AfterLayoutMixin<MyApp>{

  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool seen = (prefs.getBool('seen') ?? false);

    if (seen) {
      GoRouter.of(context).replace('/');
    } else {
      await prefs.setBool('seen', true);
      GoRouter.of(context).replace('/welcome');
    }
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) => checkFirstSeen();

  @override
  Widget build(BuildContext context) {
    if(auth.currentUser == null){
      return Scaffold(
          body: SafeArea(child: Login())
      );
    }else{
      if(auth.currentUser!.emailVerified){
        return TabContainer(tab: '0',);
      }else{
        return Scaffold(
            body: SafeArea(child: Login())
        );
      }
    }
  }
}

class TabContainer extends StatefulWidget {
  const TabContainer({Key? key, this.tab}) : super(key: key);
  final tab;

  @override
  State<TabContainer> createState() => _TabContainerState();
}

class _TabContainerState extends State<TabContainer> with TickerProviderStateMixin {

  late TabController tabController;

  void _handleTabSelection(){
    setState(() {
    });
  }

  @override
  void initState() {
    // TODO
    super.initState();
    context.read<InfoProvider>().getNewTerm();
    tabController = TabController(length: 4, vsync: this);
    tabController.addListener(_handleTabSelection);
    tabController.index = int.parse(widget.tab);
  }

  @override
  Widget build(BuildContext context) {
    if (auth.currentUser != null) {
      return Scaffold(
        key: myGlobals.scaffoldKey,
          body: SafeArea(
            child:
            TabBarView(
              controller: tabController,
              children: const [
                Home(),
                Search(),
                Ranking(),
                Setting(),
              ],
            ),
          ),
          bottomNavigationBar: Theme( data: ThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
            child: BottomAppBar(
              elevation: 10,
              child: TabBar(
                indicatorColor: Colors.transparent,
                controller: tabController,
                tabs: [
                  Tab(
                    icon: tabController.index == 0 ?
                    Icon(Icons.home, color: Color(0xffB484FF)) :
                    Icon(Icons.home_outlined, color: Colors.black),
                  ),
                  Tab(
                    icon:  tabController.index == 1 ?
                    Icon(Icons.search, color: Color(0xffB484FF)) :
                    Icon(Icons.search, color: Colors.black)
                  ),
                  Tab(
                    icon: tabController.index == 2 ?
                    Icon(Icons.star, color: Color(0xffB484FF)) :
                    Icon(Icons.star_outline, color: Colors.black)
              ),
                  Tab(
                    icon: Icon(Icons.more_horiz,
                      color: tabController.index == 3 ? Color(0xffB484FF) : Colors.black,
                    )
                  ),
                ],
              ),
            ),
          )
      );
    } else {
      return Scaffold(
        body: Login(),
      );
    }
  }
}

