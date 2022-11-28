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
    /*----------------잔고----------------*/
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
                  Text('잔고', style: tutorialTitle,),
                  Divider(color: Colors.white),
                  Text('가입 시 제공되는 자본금은 3,000,000원 입니다.\n스마트한 투자로 잔고를 불려보세요!', style: tutorialText,),
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
    /*----------------수익분석----------------*/
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
                          Text('수익 분석', style: tutorialTitle,),
                          Divider(color: Colors.white),
                          Text('거래로 발생한 손익에 대한 페이지로 이동할 수 있어요.\n현재 보유중인 종목들의 평가손익을 나타내고 있어요.',
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
    /*----------------보유종목----------------*/
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
                          Text('보유 종목', style: tutorialTitle,),
                          Divider(color: Colors.white),
                          Text('현재 보유중인 종목이 나열되어 있어요.'
                              '\n종목을 터치하면 종목의 세부페이지로 이동해요.',
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
                      children: [Text('다음으로', style: tutorialTitle,), Icon(Icons.arrow_forward_ios, color: Colors.white,)]
                    );
                  }
              )
            ]
        )
    );
    /*----------------종목 검색----------------*/
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
                          Text('종목 검색', style: tutorialTitle,),
                          Divider(color: Colors.white),
                          Text('원하는 종목을 이름으로 검색할 수 있어요'
                              '\n종목을 터치하면 종목의 세부페이지로 이동해요.',
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
    /*----------------용어----------------*/
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
                          Text('오늘의 용어', style: tutorialTitle,),
                          Divider(color: Colors.white),
                          Text('헷갈리는 경제/시사 용어들을 준비했어요!'
                              '\n이미 아는 단어라면 새로고침 하거나 해설을 볼 수 있어요.',
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
    /*----------------종목 순위----------------*/
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
                          Text('종목 순위', style: tutorialTitle,),
                          Divider(color: Colors.white),
                          Text('일일 거래량 순위를 가져왔어요.'
                              '\n해당 종목을 터치하면 종목 세부 페이지로 이동해요.',
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
                        children: [Text('다음으로', style: tutorialTitle, ),
                          Icon(Icons.arrow_forward_ios, color: Colors.white,)]
                    );
                  }
              )
            ]
        )
    );
    /*----------------내 순위----------------*/
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
                          Text('내 순위', style: tutorialTitle,),
                          Divider(color: Colors.white),
                          Text('실현손익률로 유저 랭킹을 가져왔어요.'
                              '\n내 순위를 간단하게 확인해볼 수 있어요.',
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
    /*----------------꿀팁----------------*/
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
                          Text('많이 본 뉴스', style: tutorialTitle,),
                          Divider(color: Colors.white),
                          Text('사람들이 많이 본 뉴스 5개를 가져왔어요.'
                              '\n투자에 도움이 될 수 있을거예요.',
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
    /*----------------유저 랭킹----------------*/
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
                          Text('유저 랭킹', style: tutorialTitle,),
                          Divider(color: Colors.white),
                          Text('실현손익률 유저 랭킹 top 10 이에요.',
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
