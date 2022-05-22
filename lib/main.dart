import 'package:capstone1/firstPages/firstTutorial.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:is_first_run/is_first_run.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
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
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (c) => StoreTabs()),
          ChangeNotifierProvider(create: (c) => StoreUser()),
          ChangeNotifierProvider(create: (c) => StorePrice()),
        ],
        child: MaterialApp.router(
            routeInformationParser: router.routeInformationParser,
            routerDelegate: router.routerDelegate,
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

class _MyAppState extends State<MyApp> {

  bool? _isFirstRun;

  void _checkFirstRun() async {
    bool ifr = await IsFirstRun.isFirstRun();
    setState(() {
      _isFirstRun = ifr;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkFirstRun();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _isFirstRun == false ? TabContainer(tab: '0',) : WelcomePage(),
    );
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
    // TODO: implement initState
    super.initState();
    context.read<StorePrice>().getNewTerm();
    tabController = TabController(length: 4, vsync: this);
    tabController.addListener(_handleTabSelection);
    tabController.index = int.parse(widget.tab);
  }

  @override
  Widget build(BuildContext context) {
    if (auth.currentUser != null) {
      return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   title: Text('capstone', style: TextStyle(color: Colors.black),),
      // ),
      body: SafeArea(
        child: TabBarView(
          controller: tabController,
          children: const [
            Home(),
            Search(),
            Ranking(),
            Setting(),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 10,
        child: TabBar(
          indicatorColor: Colors.transparent,
          controller: tabController,
          tabs: [
            Tab(
                icon: tabController.index == 0 ?
                Icon(Icons.home, color: Color(0xffB484FF)) :
                Icon(Icons.home_outlined, color: Colors.black)
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
                  color: tabController.index == 3 ? Color(0xffB484FF) : Colors.black,)
            ),
          ],
        ),
      ),
    );
    } else {
      return Login();
    }
  }
}


class Setting extends StatelessWidget {
  const Setting({Key? key}) : super(key: key);

  logout() async {
    await auth.signOut();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('설정', style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            letterSpacing: -1.2
          ),),
          Divider(thickness: 1.0, color: Colors.grey.withOpacity(0.5), ),
          Padding(
            padding: const EdgeInsets.only(left: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: (){
                      logout();
                      GoRouter.of(context).go('/login');
                    },
                    child: Text('로그아웃'),
                  style: TextButton.styleFrom(
                    textStyle: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -1.2
                    ),
                    primary: Colors.black
                  ),
                ),
                Divider(thickness: 0.6, color: Colors.grey.withOpacity(0.5), ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: (){
                    context.go('/welcome');
                  },
                  child: Text('첫 설명 다시보기'),
                  style: TextButton.styleFrom(
                      textStyle: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -1.2
                      ),
                      primary: Colors.black
                  ),
                ),
                Divider(thickness: 0.6, color: Colors.grey.withOpacity(0.5), ),
              ],
            ),
          ),
        ],
      )
    );
  }
}


