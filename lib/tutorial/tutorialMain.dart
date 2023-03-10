import 'package:capstone1/constant/globalKeys.dart';
import 'package:capstone1/tutorial/tutorialHome.dart';
import 'package:capstone1/tutorial/tutorialRank.dart';
import 'package:capstone1/tutorial/tutorialSearch.dart';
import 'package:capstone1/tutorial/tutorialSetting.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class TutorialMain extends StatefulWidget {
  const TutorialMain({Key? key}) : super(key: key);

  @override
  State<TutorialMain> createState() => _TutorialMainState();
}

class _TutorialMainState extends State<TutorialMain>  with TickerProviderStateMixin  {
  late TabController tabController;
  late TutorialCoachMark tutorialCoachMark;

  void _handleTabSelection(){
    setState(() {

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    tabController = TabController(length: 4, vsync: this);
    tabController.addListener(_handleTabSelection);
    createTutorial();
    Future.delayed(Duration.zero, showTutorial);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: TabBarView(
          controller: tabController,
          children: [
            TutorialHome(),
            TutorialSearch(),
            TutorialRank(),
            Container(),
          ],
        ),
      ),
      bottomNavigationBar: Theme(data: ThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent
      ),
        child: BottomAppBar(
          elevation: 10,
          child: TabBar(
            controller: tabController,
            indicatorColor: Colors.transparent,
            tabs: [
              Tab(
                icon: tabController.index == 0 ?
                Icon(Icons.home, color: Color(0xffB484FF)) :
                Icon(Icons.home_outlined, color: Colors.black),
              ),
              Tab(
                key: homeGlobals.searchTabKey,
                  icon:  tabController.index == 1 ?
                  Icon(Icons.search, color: Color(0xffB484FF)) :
                  Icon(Icons.search, color: Colors.black)
              ),
              Tab(
                key: homeGlobals.rankingTabKey,
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
        ),),
    );
  }

  void showTutorial(){
    tutorialCoachMark.show(context: context);
  }
  void createTutorial(){
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      colorShadow: Colors.black54,
      textStyleSkip: TextStyle(fontSize: 19, color: Colors.white),
      onClickTarget: (target){
        if(target.identify == 'searchTab'){
          tabController.index = 1;
        }else if(target.identify == 'rankingTab'){
          tabController.index = 2;
        }
      },
      onFinish: (){
        GoRouter.of(context).go('/tutorial/end');
      },
      onSkip: (){
        GoRouter.of(context).go('/tutorial/end');
      }
    );
  }


  TextStyle tutorialTitle = TextStyle(
      color: Colors.white,
      fontSize: 24, letterSpacing: -1.5,
      fontWeight: FontWeight.bold
  );
  TextStyle tutorialText = TextStyle(
    color: Colors.white,
    fontSize: 20, letterSpacing: -1.5,
  );
  List<TargetFocus> _createTargets(){
    List<TargetFocus> targets = [];
    /*----------------??????----------------*/
    targets.add(
      TargetFocus(
        identify: "balance",
        keyTarget: homeGlobals.balanceKey,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller){
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(padding: EdgeInsets.only(bottom: 4), child: Text('\u{1F4B0}', style: TextStyle(fontSize: 24),),),
                  Text('??????', style: tutorialTitle,),
                  Divider(color: Colors.white),
                  Text('?????? ??? ???????????? ???????????? 3,000,000??? ?????????.\n???????????? ????????? ????????? ???????????????!', style: tutorialText,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () => controller.next(),
                        icon: Icon(Icons.arrow_forward_ios, color: Colors.white,),
                      ),
                    ],
                  ),
                ],
              );
            }
          )
        ]
      )
    );
    /*----------------????????????----------------*/
    targets.add(
        TargetFocus(
            identify: "profit",
            keyTarget: homeGlobals.profitKey,
            alignSkip: Alignment.topRight,
            contents: [
              TargetContent(
                  align: ContentAlign.bottom,
                  builder: (context, controller){
                    return Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(padding: EdgeInsets.only(bottom: 4), child: Text('\u{1F4DD}', style: TextStyle(fontSize: 24),),),
                          Text('?????? ??????', style: tutorialTitle,),
                          Divider(color: Colors.white),
                          Text('????????? ????????? ????????? ?????? ???????????? ????????? ??? ?????????.\n?????? ???????????? ???????????? ??????????????? ???????????? ?????????.',
                            style: tutorialText,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () => controller.previous(),
                                icon: Icon(Icons.arrow_back_ios, color: Colors.white,),
                              ),
                              IconButton(
                                onPressed: () => controller.next(),
                                icon: Icon(Icons.arrow_forward_ios, color: Colors.white,),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
              ),
            ]
        )
    );
    /*----------------????????????----------------*/
    targets.add(
        TargetFocus(
            identify: "holdings",
            keyTarget: homeGlobals.holdingsKey,
            alignSkip: Alignment.topRight,
            contents: [
              TargetContent(
                  align: ContentAlign.top,
                  builder: (context, controller){
                    return Container(
                      margin: EdgeInsets.only(bottom: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(padding: EdgeInsets.only(bottom: 4), child: Text('\u{1F4CD}', style: TextStyle(fontSize: 24),),),
                          Text('?????? ??????', style: tutorialTitle,),
                          Divider(color: Colors.white),
                          Text('?????? ???????????? ????????? ???????????? ?????????.'
                              '\n????????? ???????????? ????????? ?????????????????? ????????????.',
                            style: tutorialText,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () => controller.previous(),
                                icon: Icon(Icons.arrow_back_ios, color: Colors.white,),
                              ),
                              IconButton(
                                onPressed: () => controller.next(),
                                icon: Icon(Icons.arrow_forward_ios, color: Colors.white,),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
              )
            ]
        )
    );
    /*----------------search tab----------------*/
    targets.add(
        TargetFocus(
            identify: "searchTab",
            keyTarget: homeGlobals.searchTabKey,
            alignSkip: Alignment.topRight,
            contents: [
              TargetContent(
                  align: ContentAlign.top,
                  builder: (context, controller){
                    return Row(
                      children: [Text('????????????', style: tutorialTitle,), Icon(Icons.arrow_forward_ios, color: Colors.white,)]
                    );
                  }
              )
            ]
        )
    );
    /*----------------?????? ??????----------------*/
    targets.add(
        TargetFocus(
            identify: "magnify",
            keyTarget: homeGlobals.magnifyKey,
            alignSkip: Alignment.topRight,
            contents: [
              TargetContent(
                  align: ContentAlign.bottom,
                  builder: (context, controller){
                    return Container(
                      margin: EdgeInsets.only(bottom: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(padding: EdgeInsets.only(bottom: 4), child: Text('\u{1F50D}', style: TextStyle(fontSize: 24),),),
                          Text('?????? ??????', style: tutorialTitle,),
                          Divider(color: Colors.white),
                          Text('????????? ????????? ???????????? ????????? ??? ?????????'
                              '\n????????? ???????????? ????????? ?????????????????? ????????????.',
                            style: tutorialText,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () => controller.previous(),
                                icon: Icon(Icons.arrow_back_ios, color: Colors.white,),
                              ),
                              IconButton(
                                onPressed: () => controller.next(),
                                icon: Icon(Icons.arrow_forward_ios, color: Colors.white,),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
              )
            ]
        )
    );
    /*----------------??????----------------*/
    targets.add(
        TargetFocus(
            identify: "term",
            keyTarget: homeGlobals.termKey,
            alignSkip: Alignment.topRight,
            contents: [
              TargetContent(
                  align: ContentAlign.bottom,
                  builder: (context, controller){
                    return Container(
                      margin: EdgeInsets.only(top: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(padding: EdgeInsets.only(bottom: 4), child: Text('\u{1F4D4}', style: TextStyle(fontSize: 24),),),
                          Text('????????? ??????', style: tutorialTitle,),
                          Divider(color: Colors.white),
                          Text('???????????? ??????/?????? ???????????? ???????????????!'
                              '\n?????? ?????? ???????????? ???????????? ????????? ????????? ??? ??? ?????????.',
                            style: tutorialText,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () => controller.previous(),
                                icon: Icon(Icons.arrow_back_ios, color: Colors.white,),
                              ),
                              IconButton(
                                onPressed: () => controller.next(),
                                icon: Icon(Icons.arrow_forward_ios, color: Colors.white,),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
              )
            ]
        )
    );
    /*----------------?????? ??????----------------*/
    targets.add(
        TargetFocus(
            identify: "stockRank",
            keyTarget: homeGlobals.stockRankKey,
            alignSkip: Alignment.topRight,
            contents: [
              TargetContent(
                  align: ContentAlign.bottom,
                  builder: (context, controller){
                    return Container(
                      margin: EdgeInsets.only(top: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(padding: EdgeInsets.only(bottom: 4), child: Text('\u{1F4CC}', style: TextStyle(fontSize: 24),),),
                          Text('?????? ??????', style: tutorialTitle,),
                          Divider(color: Colors.white),
                          Text('?????? ????????? ????????? ???????????????.'
                              '\n?????? ????????? ???????????? ?????? ?????? ???????????? ????????????.',
                            style: tutorialText,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () => controller.previous(),
                                icon: Icon(Icons.arrow_back_ios, color: Colors.white,),
                              ),
                              IconButton(
                                onPressed: () => controller.next(),
                                icon: Icon(Icons.arrow_forward_ios, color: Colors.white,),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
              )
            ]
        )
    );
    /*----------------ranking tab----------------*/
    targets.add(
        TargetFocus(
            identify: "rankingTab",
            keyTarget: homeGlobals.rankingTabKey,
            alignSkip: Alignment.topRight,
            contents: [
              TargetContent(
                  align: ContentAlign.top,
                  builder: (context, controller){
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                        children: [Text('????????????', style: tutorialTitle, ),
                          Icon(Icons.arrow_forward_ios, color: Colors.white,)]
                    );
                  }
              )
            ]
        )
    );
    /*----------------??? ??????----------------*/
    targets.add(
        TargetFocus(
            identify: "myRank",
            keyTarget: homeGlobals.myRankKey,
            alignSkip: Alignment.topRight,
            contents: [
              TargetContent(
                  align: ContentAlign.bottom,
                  builder: (context, controller){
                    return Container(
                      margin: EdgeInsets.only(top: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(padding: EdgeInsets.only(bottom: 4), child: Text('\u{1F31F}', style: TextStyle(fontSize: 24),),),
                          Text('??? ??????', style: tutorialTitle,),
                          Divider(color: Colors.white),
                          Text('?????????????????? ?????? ????????? ???????????????.'
                              '\n??? ????????? ???????????? ???????????? ??? ?????????.',
                            style: tutorialText,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () => controller.previous(),
                                icon: Icon(Icons.arrow_back_ios, color: Colors.white,),
                              ),
                              IconButton(
                                onPressed: () => controller.next(),
                                icon: Icon(Icons.arrow_forward_ios, color: Colors.white,),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
              )
            ]
        )
    );
    /*----------------??????----------------*/
    targets.add(
        TargetFocus(
            identify: "tips",
            keyTarget: homeGlobals.tipsKey,
            alignSkip: Alignment.topRight,
            contents: [
              TargetContent(
                  align: ContentAlign.bottom,
                  builder: (context, controller){
                    return Container(
                      margin: EdgeInsets.only(top: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(padding: EdgeInsets.only(bottom: 4), child: Text('\u{26A1}', style: TextStyle(fontSize: 24),),),
                          Text('?????? ??? ??????', style: tutorialTitle,),
                          Divider(color: Colors.white),
                          Text('???????????? ?????? ??? ?????? 5?????? ???????????????.'
                              '\n????????? ????????? ??? ??? ???????????????.',
                            style: tutorialText,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () => controller.previous(),
                                icon: Icon(Icons.arrow_back_ios, color: Colors.white,),
                              ),
                              IconButton(
                                onPressed: () => controller.next(),
                                icon: Icon(Icons.arrow_forward_ios, color: Colors.white,),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
              )
            ]
        )
    );
    /*----------------?????? ??????----------------*/
    targets.add(
        TargetFocus(
            identify: "userRank",
            keyTarget: homeGlobals.userRankKey,
            alignSkip: Alignment.topRight,
            contents: [
              TargetContent(
                  align: ContentAlign.top,
                  builder: (context, controller){
                    return Container(
                      margin: EdgeInsets.only(top: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(padding: EdgeInsets.only(bottom: 4), child: Text('\u{1F451}', style: TextStyle(fontSize: 24),),),
                          Text('?????? ??????', style: tutorialTitle,),
                          Divider(color: Colors.white),
                          Text('??????????????? ?????? ?????? top 10 ?????????.',
                            style: tutorialText,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () => controller.previous(),
                                icon: Icon(Icons.arrow_back_ios, color: Colors.white,),
                              ),
                              IconButton(
                                onPressed: () => controller.next(),
                                icon: Icon(Icons.arrow_forward_ios, color: Colors.white,),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
              )
            ]
        )
    );
    return targets;
  }
}
