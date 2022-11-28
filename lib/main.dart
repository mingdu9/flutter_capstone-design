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

import 'rankPage/ranking.dart';
import 'homePage/home.dart';
import 'router.dart';
import 'searchPage/search.dart';

// Firebase Authentication을 사용하기 위한 final 인스턴스
final auth = FirebaseAuth.instance;

void main() async {
  //firebase 설정 코드
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual, overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // router로는 GoRouter 패키지, 상태관리는 Provider 패키지
  runApp(
      MultiProvider(
        providers: [
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

// 최상위 계층 위젯
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with AfterLayoutMixin<MyApp> {

  // 첫 실행인지 확인
  Future checkFirstSeen() async {
    // 기기 로컬 저장소를 사용하여 첫 실행 여부 저장
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool seen = (prefs.getBool('seen') ?? false);
    if (seen) {
      GoRouter.of(context).replace('/');
    } else {
      await prefs.setBool('seen', true);
      GoRouter.of(context).replace('/welcome');
    }
  }

  // 레이아웃이 그려진 후 첫 실행 확인
  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    checkFirstSeen();
  }


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      // 로그인 되어있다면 홈화면 반환, 그렇지 않다면 로그인 화면 반환
      stream: auth.authStateChanges(),
      initialData: auth.currentUser,
      builder: (context, shapshot){
        if(!shapshot.hasData){
          return Scaffold(
            body: SafeArea(
              child: Login(),
            ),
          );
        }
        return TabContainer(tab: 0,);
      },
    );
  }
}


// 홈 화면을 제어하는 하단 네비게이터 바
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
    tabController.index = widget.tab;
  }

  @override
  Widget build(BuildContext context) {
    if (auth.currentUser != null) {
      return Scaffold(
        key: homeGlobals.scaffoldKey,
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
          bottomNavigationBar: Theme(data: ThemeData(
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

