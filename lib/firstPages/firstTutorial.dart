import 'package:capstone1/main.dart';
import 'package:faker/faker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:go_router/go_router.dart';

import '../homePage/home.dart';
import '../rankPage/ranking.dart';
import '../searchPage/search.dart';
import 'homeTutorial.dart';

final auth = FirebaseAuth.instance;
final fakerFa = Faker();

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (c) => StoreFirstRun(),
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.only(right: 18),
          alignment: Alignment.centerRight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                flex: 1,
                child: ListView(
                  children: [
                    PlayAnimation<double>(
                      tween: Tween<double>(begin: 0.0, end: 1.0),
                      duration: Duration(milliseconds: 1300),
                      builder: (context, child, value){
                        return Text('환영합니다.', textAlign: TextAlign.end, style: TextStyle(
                          letterSpacing: -1.2,
                          fontWeight: FontWeight.bold,
                          fontSize: 40,
                          foreground: Paint()..shader = LinearGradient(colors: <Color>[
                            Colors.blue.withOpacity(value), Color(0xffB484FF).withOpacity(value)
                          ]).createShader(Rect.fromLTWH(140.0, 0.0, 200.0, 0.0))
                        ),);
                      }
                    ),
                    Text('', style: TextStyle(fontSize: 13),),
                    PlayAnimation<double>(
                        tween: Tween<double>(begin: 0.0, end: 1.0),
                        duration: Duration(milliseconds: 1300),
                        builder: (context, child, value){
                          return Text('첫 설명을 시작할까요?', textAlign: TextAlign.end, style: TextStyle(
                              fontWeight: FontWeight.bold,
                              letterSpacing: -1.2,
                              fontSize: 25,
                              color: Colors.black.withOpacity(value)
                          ),);
                        }
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 3,
                child: PlayAnimation<double>(
                  tween: Tween<double>(begin: 0.0, end: 1.0),
                  builder: (context, child, value) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: (){
                            GoRouter.of(context).go('/tutorial');
                          },
                          child: Text('네!', style: TextStyle(
                              fontSize: 23, letterSpacing: -1.2,
                              decorationThickness: 0.8,
                              fontWeight: FontWeight.bold
                          ),
                          ),
                          style: TextButton.styleFrom(
                              primary: Colors.black.withOpacity(value),
                              alignment: Alignment.centerRight
                          ),
                        ),
                        TextButton(
                          onPressed: (){
                            GoRouter.of(context).go('/mainTab');
                          },
                          child: Text('괜찮아요', style: TextStyle(
                            fontSize: 17, letterSpacing: -1.2,
                            decoration: TextDecoration.underline,
                            decorationThickness: 0.8,
                          ),
                          ),
                          style: TextButton.styleFrom(
                              primary: Colors.black.withOpacity(value)
                          ),
                        ),
                      ],
                    );
                  }) ,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class StoreBool extends ChangeNotifier{
  bool isStarted = false;
  setIsStarted(){
    isStarted = !isStarted;
    notifyListeners();
  }
}

class TutorialRoot extends StatefulWidget {
  const TutorialRoot({Key? key}) : super(key: key);

  @override
  State<TutorialRoot> createState() => _TutorialRootState();
}

class _TutorialRootState extends State<TutorialRoot> with TickerProviderStateMixin {
  late TabController tabController;

  void _handleTabSelection(){
    setState(() {

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 4, vsync: this);
    tabController.addListener(_handleTabSelection);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: (){
          context.read<StoreBool>().setIsStarted();
        },
        child: Icon(Icons.description,
          color: context.watch<StoreBool>().isStarted == true ? Color(0xffB484FF) : Colors.black,
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('tutorial', style: TextStyle(color: Colors.black),),
      ),
      body: Builder(
        builder: (context) {
          return Stack(
            children: <Widget>[
              TabBarView(
                controller: tabController,
                children: const [
                  Home(),
                  Search(),
                  Ranking(),
                  TutorialSetting(),
                ],
              ),

              (tabController.index == 0) ?
                ( context.watch<StoreBool>().isStarted == true ? HomeTutorial() : Container() )
                  : Container(),
            ]
          );
        }
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        elevation: 10,
        child: TabBar(
          indicatorColor: Colors.transparent,
          controller: tabController,
          tabs: [
            Tab(
                icon: tabController.index == 0 ?
                Icon(Icons.house, color: Color(0xffB484FF)) :
                Icon(Icons.house_outlined, color: Colors.black)
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
  }
}


class TutorialSetting extends StatelessWidget {
  const TutorialSetting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logout() async {
      await auth.signOut();
    }

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
                      context.go('/login');
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
                      context.go('/mainTab/0');
                    },
                    child: Text('설명 끝내기'),
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
