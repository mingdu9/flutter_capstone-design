import 'package:capstone1/constant/globalKeys.dart';
import 'package:capstone1/homePage/profit/calculate.dart';
import 'package:capstone1/providers/user.dart';
import 'package:capstone1/providers/stock.dart';
import 'package:capstone1/searchPage/stockDetail/infoBox.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'lineChart.dart';

class Stock extends StatefulWidget {
  const Stock({Key? key, this.tab, this.ticker}) : super(key: key);
  final ticker;
  final tab;

  @override
  State<Stock> createState() => _StockState();
}

class _StockState extends State<Stock> {
  int selltotal = 0;
  int buytotal = 0;
  final _scrollController = ScrollController();
  final TextEditingController sellController = TextEditingController();
  final TextEditingController buyController = TextEditingController();
  String title = "";
  late TutorialCoachMark tutorialCoachMark;
  final GlobalKey _topKey = GlobalKey();

  var buyNode = FocusNode();
  var sellNode = FocusNode();

  _setTitle(){
    setState((){
      title = context.read<StockProvider>().stockInfo['name'];
    });
  }
  _initTitle(){
    setState((){
      title = '';
    });
  }

  getBuyTotal(value){
    if (value.isEmpty) {
      setState(() {
        buytotal = 0;
      });
    } else {
      setState(() {
        buytotal = context.read<StockProvider>().lastPrice['price'] * int.parse(value);
      });
    }
  }

  getSellTotal(text){
    if (text.isEmpty) {
      setState(() {
        selltotal = 0;
      });
    } else {
      setState(() {
        selltotal = context.read<StockProvider>().lastPrice['price'] * int.parse(text);
      });
    }
  }


  getData() async {
    await context.read<StockProvider>().setPriceList(widget.ticker);
    await context.read<UserProvider>().defineUser();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    createTutorial();
    if(mounted){
      getData();
    }
    _scrollController.addListener(() {
      if(_scrollController.hasClients && _scrollController.position.pixels > 0){
        _setTitle();
      }else{
        _initTitle();
      }
    });
  }

  void createTutorial(){
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      colorShadow: Colors.black54,
      textSkip: "CLOSE",
      textStyleSkip: TextStyle(fontSize: 19, color: Colors.white),

    );
  }
  void showTutorial(){
    tutorialCoachMark.show(context: context);
  }


  String addString(List<dynamic> list) {
    String result = '';
    for (var element in list) {
      result += element + '/';
    }
    return result.substring(0, result.length - 1);
  }

  sell(int count, BuildContext context) async {
    context.read<UserProvider>().getTickerInfo(widget.ticker);
    int price = context.read<StockProvider>().lastPrice['price'];
    int balance = context.read<UserProvider>().balance;
    String formatDate = DateFormat('yy.MM.dd-HH:mm:ss').format(DateTime.now());

    await context.read<UserProvider>().updateBalance(balance + price * count);
    await context.read<UserProvider>()
        .addHoldings(widget.ticker, 'sell', formatDate, price, count);
  }

  buy(int count, BuildContext context) async {
    await context.read<UserProvider>().getTickerInfo(widget.ticker);
    int price = context.read<StockProvider>().lastPrice['price'];
    int balance = context.read<UserProvider>().balance;
    String formatDate = DateFormat('yy.MM.dd-HH:mm:ss').format(DateTime.now());

    try{
      await context.read<UserProvider>().updateBalance(balance - price * count);
      await homeGlobals.scaffoldKey.currentContext!
          .read<UserProvider>()
          .addHoldings(widget.ticker, 'buy', formatDate, price, count);
    }on Exception catch (error){
      print(error);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        key: _topKey,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () => GoRouter.of(context).pop(),
        ),
        actions: [
          IconButton(
              onPressed: () {
                _scrollController.jumpTo(0);
                showTutorial();
              },
              icon: Icon(
                Icons.question_mark,
                color: Colors.black,
              ))
        ],
        title: Text(title,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.values[4]),),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 20,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    buytotal = 0;
                  });
                  buyController.clear();
                  showDialog(
                      context: context,
                      // context: myGlobals.scaffoldKey.currentContext!,
                      builder: (context) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          backgroundColor: Colors.white,
                          child: GestureDetector(
                            onTap: (){
                              if(buyNode.hasFocus){
                                buyNode.unfocus();
                              }
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      gradient: LinearGradient(
                                          colors: [
                                            Color(0xffff7d7d).withOpacity(0.1),
                                            Colors.white
                                          ],
                                          begin: Alignment(0.0, -2.0),
                                          end: Alignment(0.0, -0.5))),
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Text('매수',
                                          style: TextStyle(
                                            fontSize: 33,
                                            fontWeight: FontWeight.bold,
                                          )),
                                      Divider(height: 13),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  '현재가',
                                                  style: TextStyle(
                                                      fontSize: 23,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  '${addComma(context.watch<StockProvider>().lastPrice['price'])}원',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                  ),
                                                )
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  '잔고',
                                                  style: TextStyle(
                                                      fontSize: 23,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  '${addComma(context.watch<UserProvider>().balance)}원',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                  ),
                                                )
                                              ],
                                            ),
                                            Divider(height: 10),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  '개수',
                                                  style: TextStyle(
                                                      fontSize: 23,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Container(
                                                  padding:
                                                      EdgeInsets.only(bottom: 4),
                                                  width: MediaQuery.of(context).size.width * 0.3,
                                                  child: TextField(
                                                    focusNode: buyNode,
                                                    controller: buyController,
                                                    onChanged: (value){
                                                      getBuyTotal(value);
                                                    },
                                                    keyboardType:
                                                        TextInputType.number,
                                                    decoration: InputDecoration(
                                                        hintText: '최대 30주씩',
                                                        hintStyle: TextStyle(
                                                            fontSize: 17)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Divider(height: 10),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  '총 금액',
                                                  style: TextStyle(
                                                      fontSize: 23,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  '${addComma(buytotal)}원',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(right: 8),
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                foregroundColor: Color(0xffff7d7d), backgroundColor: Colors.white, textStyle:
                                                    TextStyle(fontSize: 18),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(13),
                                                    side: BorderSide(
                                                        color: Color(0xffff7d7d),
                                                        width: 2)),
                                              ),
                                              onPressed: () {
                                                if (int.parse(buyController.text)
                                                          * context.read<StockProvider>().lastPrice['price'] <=
                                                    context.read<UserProvider>().balance) {
                                                  buy(int.parse(buyController.text), homeGlobals.scaffoldKey.currentContext!);
                                                  Navigator.pop(context);
                                                } else {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                          const SnackBar(content: Text('매수 실패'))
                                                  );
                                                }
                                              },
                                              child: Text(
                                                '매수',
                                                style: TextStyle(
                                                    color: Color(0xffff7d7d)),
                                              ),
                                            ),
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              foregroundColor: Color(0xff7f7f7f), backgroundColor: Colors.white, textStyle: TextStyle(fontSize: 18),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(13),
                                                  side: BorderSide(
                                                      color: Color(0xff7f7f7f),
                                                      width: 2)),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              '취소',
                                              style: TextStyle(
                                                  color: Color(0xff7f7f7f)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      });
                },
                style: ElevatedButton.styleFrom(
                    elevation: 0, backgroundColor: const Color(0xffff7d7d),
                    padding:
                        const EdgeInsets.symmetric(vertical: 9, horizontal: 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    )),
                child: Text(
                  '매수',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    selltotal = 0;
                  });
                  sellController.clear();
                  // GoRouter.of(context).
                  context.read<UserProvider>().getTickerInfo(widget.ticker);
                  showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor: Colors.white,
                          child: GestureDetector(
                            onTap: (){
                              if(sellNode.hasFocus)
                                {
                                  sellNode.unfocus();
                                }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: LinearGradient(
                                      colors: [
                                        Color(0xff2892ff).withOpacity(0.1),
                                        Colors.white
                                      ],
                                      begin: Alignment(0.0, -2.0),
                                      end: Alignment(0.0, -0.5))),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Text('매도',
                                            style: TextStyle(
                                              fontSize: 33,
                                              fontWeight: FontWeight.bold,
                                            )),
                                        Divider(height: 13),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    '현재가',
                                                    style: TextStyle(
                                                        fontSize: 23,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    '${addComma(context.watch<StockProvider>().lastPrice['price'])}원',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    '보유 개수',
                                                    style: TextStyle(
                                                        fontSize: 23,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    '${context.watch<UserProvider>().holdingInfo['totalCount']??0}주',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Divider(height: 10),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    '개수',
                                                    style: TextStyle(
                                                        fontSize: 23,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        bottom: 4),
                                                    width: MediaQuery.of(context).size.width * 0.3,
                                                    child: TextField(
                                                      focusNode: sellNode,
                                                      controller: sellController,
                                                      onChanged: (text) {
                                                        getSellTotal(text);
                                                      },
                                                      keyboardType:
                                                          TextInputType.number,
                                                      decoration: InputDecoration(
                                                          hintText: '최대 30주씩',
                                                          hintStyle: TextStyle(
                                                              fontSize: 17)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Divider(height: 10),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    '총 금액',
                                                    style: TextStyle(
                                                        fontSize: 23,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    '${addComma(selltotal)}원',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(right: 8),
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  foregroundColor: Color(0xff2892ff), backgroundColor: Colors.white, textStyle:
                                                      TextStyle(fontSize: 18),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              13),
                                                      side: BorderSide(
                                                          color:
                                                              Color(0xff2892ff),
                                                          width: 2)),
                                                ),
                                                onPressed: () {
                                                  if (context.read<UserProvider>().holdingInfo['totalCount']! < 0 ||
                                                      context.read<UserProvider>().holdingInfo['totalCount']! < int.parse(sellController.text)
                                                  ) {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                            const SnackBar(content: Text('매도 실패')));
                                                  } else if (int.parse(sellController.text) <= 30) {
                                                    sell(int.parse(sellController.text), context);
                                                    Navigator.of(homeGlobals.scaffoldKey.currentContext ?? context).pop();
                                                  } else if(context.read<UserProvider>().holdingInfo['totalCount'] == null){
                                                    print('매도 null');
                                                  }
                                                },
                                                child: Text(
                                                  '매도',
                                                  style: TextStyle(
                                                      color: Color(0xff2892ff)),
                                                ),
                                              ),
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                foregroundColor: Color(0xff7f7f7f), backgroundColor: Colors.white, textStyle:
                                                    TextStyle(fontSize: 18),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(13),
                                                    side: BorderSide(
                                                        color: Color(0xff7f7f7f),
                                                        width: 2)),
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                '취소',
                                                style: TextStyle(
                                                    color: Color(0xff7f7f7f)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  padding:
                      const EdgeInsets.symmetric(vertical: 9, horizontal: 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),
                child: Text(
                  '매도',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // TODO BODY START
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            ( context.watch<StockProvider>().loading == true ?
              loadingWidget(MediaQuery.of(context).size.width) : Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    key: homeGlobals.nameKey,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        addString(
                            context.watch<StockProvider>().stockInfo['index']),
                        style:
                            TextStyle(fontSize: 17, color: Colors.black26),
                      ),
                      Text(
                        context.watch<StockProvider>().stockInfo['name'],
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 29,
                            letterSpacing: -1.2),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${addComma(context.watch<StockProvider>().lastPrice['price'])}원',
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.values[5],
                            color: context
                                        .watch<StockProvider>()
                                        .lastPrice['changeRate'] >
                                    0
                                ? Colors.red
                                : Colors.blueAccent),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: context
                                    .watch<StockProvider>()
                                    .lastPrice['changeRate'] >
                                0
                            ? [
                                Icon(Icons.arrow_drop_up_rounded,
                                    color: Colors.red),
                                Text(
                                  '${context.watch<StockProvider>().lastPrice['changeRate']} %',
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.red),
                                )
                              ]
                            : [
                                Icon(
                                  Icons.arrow_drop_down_rounded,
                                  color: Colors.blue,
                                ),
                                Text(
                                  '${context.watch<StockProvider>().lastPrice['changeRate']} %',
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.blue),
                                )
                              ],
                      ),
                    ],
                  )
                ],
              ),
            )),
            (context.watch<StockProvider>().loading == true ?
              Shimmer.fromColors(
                  baseColor: Color(0xFFEEEEEE),
                  highlightColor: Color(0xFFF5F5F5),
                  child: Container(
                    margin: EdgeInsets.only(top: 20, bottom: 20, left: 18, right: 18),
                    height: MediaQuery.of(context).size.height * 0.4, width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(13),
                      color: Color(0xFFE0E0E0),
                    ),
                  ))
                : Container(
              margin:
                  EdgeInsets.only(top: 20, bottom: 20, left: 18, right: 18),
              child: ChartContainer(key: homeGlobals.chartKey,),
              // child: Text('chart')
            )),
            NewsBox(ticker: widget.ticker),
            NoticeBox(ticker: widget.ticker),
          ],
        ),
      ),
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
  List<TargetFocus> _createTargets() {
    List<TargetFocus> targets = [];
    targets.add(
      TargetFocus(
        identify: 'stockName',
        keyTarget: homeGlobals.nameKey,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller){
              return Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('종목 정보', style: tutorialTitle,),
                    Divider(color: Colors.white,),
                    Text('종목의 이름과 업종, 오늘의 종가와 등락률을 알려줘요.', style: tutorialText),
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
                )
              );
            }
          )
        ]
      )
    );
    targets.add(
        TargetFocus(
            identify: 'chart',
            keyTarget: homeGlobals.chartKey,
            alignSkip: Alignment.topRight,
            contents: [
              TargetContent(
                  align: ContentAlign.bottom,
                  builder: (context, controller){
                    return Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('차트', style: tutorialTitle,),
                            Divider(color: Colors.white,),
                            Text('한 달간의 종가 라인 차트예요.\n라인을 누르면 날짜와 가격이 나와요.', textAlign: TextAlign.end,style: tutorialText),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  onPressed: () => controller.previous(),
                                  icon: Icon(Icons.arrow_back_ios, color: Colors.white,),
                                ),
                                IconButton(
                                  onPressed: (){
                                    Scrollable.ensureVisible(homeGlobals.newsKey.currentContext!);
                                    controller.next();
                                    },
                                  icon: Icon(Icons.arrow_forward_ios, color: Colors.white,),
                                ),
                              ],
                            )
                          ],
                        )
                    );
                  }
              )
            ]
        )
    );
    targets.add(
        TargetFocus(
            identify: 'news',
            keyTarget: homeGlobals.newsKey,
            alignSkip: Alignment.topRight,
            contents: [
              TargetContent(
                  align: ContentAlign.bottom,
                  builder: (context, controller){
                    return Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('뉴스', style: tutorialTitle,),
                            Divider(color: Colors.white,),
                            Text('종목 관련 최근 뉴스예요.\n업데이트 하려면 새로고침 버튼을 눌러주세요.', textAlign: TextAlign.end,style: tutorialText),
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
                            )
                          ],
                        )
                    );
                  }
              )
            ]
        )
    );
    targets.add(
        TargetFocus(
            identify: 'info',
            keyTarget: homeGlobals.infoKey,
            alignSkip: Alignment.topRight,
            contents: [
              TargetContent(
                  align: ContentAlign.top,
                  builder: (context, controller){
                    return Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('공시 정보', style: tutorialTitle,),
                            Divider(color: Colors.white,),
                            Text('종목 관련 공시 정보예요.\n업데이트 하려면 새로고침 버튼을 눌러주세요.', textAlign: TextAlign.end,style: tutorialText),
                            Divider(color: Colors.white,),
                            Text('\u{1F4A1}공시 정보\n증권을 발행한 회사에 사업내용, 경영실적 등 증권의 가치를 판단하는데 필요한 정보를 공개한 것이에요.',
                              style: TextStyle(
                                fontSize: 16, letterSpacing: -1.5, color: Colors.white,
                              )
                            ),
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
                            )
                          ],
                        )
                    );
                  }
              )
            ]
        )
    );
    return targets;
  }
}


Widget loadingWidget(num width) {
  var boxDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(13),
    color: Colors.white
  );
  return Shimmer.fromColors(
      baseColor: Color(0xFFE0E0E0),
      highlightColor: Color(0xFFF5F5F5),
      child: Padding(
        padding:  EdgeInsets.all(10.0),
        child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                    height: 17, width: width * 0.4, decoration: boxDecoration,
                  ),
                ),
                Container(
                  height: 29, width: width * 0.3, decoration: boxDecoration,
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                    height: 25, width: width * 0.3, decoration: boxDecoration,
                  ),
                ),
                Container(
                  height: 15, width: width * 0.2, decoration: boxDecoration,
                )
              ],
            )
          ],
        ),
      ));
}