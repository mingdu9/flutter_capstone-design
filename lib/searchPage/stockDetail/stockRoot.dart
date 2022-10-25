import 'package:capstone1/homePage/profit/calculate.dart';
import 'package:capstone1/providers/user.dart';
import 'package:capstone1/providers/stock.dart';
import 'package:capstone1/searchPage/stockDetail/infoBox.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
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
  int index = 0;
  final _scrollController = ScrollController();
  final TextEditingController sellController = TextEditingController();
  final TextEditingController buyController = TextEditingController();
  String title = "";

  _setTitle(){
    setState((){
      title = context.read<StorePrice>().stockInfo['name'];
    });
  }
  _initTitle(){
    setState((){
      title = '';
    });
  }

  findHoldingNum(List<dynamic> holdings, ticker) {
    print('holdings: $holdings');
    setState(() {
      if (holdings.isNotEmpty) {
        for (int i = 0; i <= holdings.length - 1; i++) {
          if (holdings[i]['ticker'] == ticker) {
            index = i;
            return;
          }
        }
        index = -1;
      } else {
        index = -1;
      }
      print('index: $index');
    });
  }

  getData() async {
    await context.read<StorePrice>().setPriceList(widget.ticker);
    await context.read<StoreUser>().defineUser();
    print('index: $index');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('stock detail ticker : ${widget.ticker}');
    getData();
    _scrollController.addListener(() {
      if(_scrollController.hasClients && _scrollController.position.pixels > 0){
        _setTitle();
      }else{
        _initTitle();
      }
    });
  }

  String addString(List<dynamic> list) {
    String result = '';
    for (var element in list) {
      result += element + '/';
    }
    return result.substring(0, result.length - 1);
  }

  sell(int count) async {
    int price = context.read<StorePrice>().lastPrice['price'];
    int balance = context.read<StoreUser>().balance;
    await context.read<StoreUser>().updateBalance(balance + price * count);
    await context.read<StoreUser>().updateCount(
        -count,
        index,
        price,
        widget.ticker);
  }

  buy(int count) async {
    int price = context.read<StorePrice>().lastPrice['price'];
    int balance = context.read<StoreUser>().balance;
    int sum = count * price;
    await context.read<StoreUser>().updateBalance(balance - sum);
    if (index < 0) {
      await context.read<StoreUser>().addHolding(price, count, widget.ticker);
      index++;
    } else {
      await context.read<StoreUser>().updateCount(
          count,
          index,
          price,
          widget.ticker);
    }
  }

  @override
  Widget build(BuildContext context) {
    findHoldingNum(context.read<StoreUser>().holdings, widget.ticker);
    return Scaffold(
      appBar: AppBar(
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
                // print('show tutorial');
                GoRouter.of(context).go('/stockTutorial/${widget.ticker}');
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
                      builder: (context) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          backgroundColor: Colors.white,
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
                                                '${addComma(context.watch<StorePrice>().lastPrice['price'])}원',
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
                                                '${addComma(context.watch<StoreUser>().balance)}원',
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
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.3,
                                                child: TextField(
                                                  controller: buyController,
                                                  onChanged: (value) {
                                                    if (value.isEmpty) {
                                                      setState(() {
                                                        buytotal = 0;
                                                      });
                                                    } else {
                                                      setState(() {
                                                        buytotal = context
                                                                    .read<StorePrice>()
                                                                    .lastPrice['price'] * int.parse(value);
                                                      });
                                                    }
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
                                            child: Text(
                                              '매수',
                                              style: TextStyle(
                                                  color: Color(0xffff7d7d)),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              textStyle:
                                                  TextStyle(fontSize: 18),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(13),
                                                  side: BorderSide(
                                                      color: Color(0xffff7d7d),
                                                      width: 2)),
                                              onPrimary: Color(0xffff7d7d),
                                              primary: Colors.white,
                                            ),
                                            onPressed: () {
                                              if (int.parse(buyController.text)
                                                        * context.read<StorePrice>().lastPrice['price'] <=
                                                  context.read<StoreUser>().balance) {
                                                buy(int.parse(buyController.text));
                                                findHoldingNum(context.read<StoreUser>().holdings, widget.ticker);
                                                Navigator.pop(context);
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                        const SnackBar(
                                                            content:
                                                                Text('매수 실패')));
                                              }
                                            },
                                          ),
                                        ),
                                        ElevatedButton(
                                          child: Text(
                                            '취소',
                                            style: TextStyle(
                                                color: Color(0xff7f7f7f)),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            textStyle: TextStyle(fontSize: 18),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(13),
                                                side: BorderSide(
                                                    color: Color(0xff7f7f7f),
                                                    width: 2)),
                                            onPrimary: Color(0xff7f7f7f),
                                            primary: Colors.white,
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      });
                },
                child: Text(
                  '매수',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    padding:
                        const EdgeInsets.symmetric(vertical: 9, horizontal: 30),
                    primary: const Color(0xffff7d7d),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    )),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    selltotal = 0;
                  });
                  sellController.clear();
                  // GoRouter.of(context).
                  showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor: Colors.white,
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
                                                  '${addComma(context.watch<StorePrice>().lastPrice['price'])}원',
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
                                                  '${context.watch<StoreUser>().holdings.isEmpty ? '0' : context.watch<StoreUser>().holdings[index]['count']}주',
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
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.3,
                                                  child: TextField(
                                                    controller: sellController,
                                                    onChanged: (text) {
                                                      if (text.isEmpty) {
                                                        setState(() {
                                                          selltotal = 0;
                                                        });
                                                      } else {
                                                        setState(() {
                                                          selltotal = context
                                                                      .read<
                                                                          StorePrice>()
                                                                      .lastPrice[
                                                                  'price'] *
                                                              int.parse(text);
                                                        });
                                                      }
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
                                              child: Text(
                                                '매도',
                                                style: TextStyle(
                                                    color: Color(0xff2892ff)),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                textStyle:
                                                    TextStyle(fontSize: 18),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            13),
                                                    side: BorderSide(
                                                        color:
                                                            Color(0xff2892ff),
                                                        width: 2)),
                                                onPrimary: Color(0xff2892ff),
                                                primary: Colors.white,
                                              ),
                                              onPressed: () {
                                                if (index < 0) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                          const SnackBar(content: Text('매도 실패')));
                                                } else if (int.parse(sellController.text) >=
                                                        context.read<StoreUser>().holdings[index]['count'] ||
                                                    int.parse(sellController.text) <= 30) {
                                                  sell(int.parse(sellController.text));
                                                  Navigator.pop(context);
                                                } else {
                                                  print(context.read<StoreUser>().holdings[index]['count']);
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                          const SnackBar(content: Text('매도 실패')));
                                                }
                                              },
                                            ),
                                          ),
                                          ElevatedButton(
                                            child: Text(
                                              '취소',
                                              style: TextStyle(
                                                  color: Color(0xff7f7f7f)),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              textStyle:
                                                  TextStyle(fontSize: 18),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(13),
                                                  side: BorderSide(
                                                      color: Color(0xff7f7f7f),
                                                      width: 2)),
                                              onPrimary: Color(0xff7f7f7f),
                                              primary: Colors.white,
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
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
                child: Text(
                  '매도',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  padding:
                      const EdgeInsets.symmetric(vertical: 9, horizontal: 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: ListView(
              controller: _scrollController,
              children: [
                ( context.watch<StorePrice>().load == true ?
                  loadingWidget(MediaQuery.of(context).size.width) : Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            addString(
                                context.watch<StorePrice>().stockInfo['index']),
                            style:
                                TextStyle(fontSize: 17, color: Colors.black26),
                          ),
                          Text(
                            context.watch<StorePrice>().stockInfo['name'],
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
                            '${addComma(context.watch<StorePrice>().lastPrice['price'])}원',
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.values[5],
                                color: context
                                            .watch<StorePrice>()
                                            .lastPrice['changeRate'] >
                                        0
                                    ? Colors.red
                                    : Colors.blueAccent),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: context
                                        .watch<StorePrice>()
                                        .lastPrice['changeRate'] >
                                    0
                                ? [
                                    Icon(Icons.arrow_drop_up_rounded,
                                        color: Colors.red),
                                    Text(
                                      '${context.watch<StorePrice>().lastPrice['changeRate']} %',
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
                                      '${context.watch<StorePrice>().lastPrice['changeRate']} %',
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
                (context.watch<StorePrice>().load == true ?
                  Shimmer.fromColors(
                      child: Container(
                        margin: EdgeInsets.only(top: 20, bottom: 20, left: 18, right: 18),
                        height: MediaQuery.of(context).size.height * 0.4, width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(13),
                          color: Color(0xFFE0E0E0),
                        ),
                      ),
                      baseColor: Color(0xFFEEEEEE),
                      highlightColor: Color(0xFFF5F5F5))
                    : Container(
                  margin:
                      EdgeInsets.only(top: 20, bottom: 20, left: 18, right: 18),
                  child: ChartContainer(),
                  // child: Text('chart')
                )),
                NewsBox(ticker: widget.ticker),
                NoticeBox(ticker: widget.ticker),
              ],
            ),
    );
  }
}


Widget loadingWidget(num width) {
  var boxDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(13),
    color: Colors.white
  );
  return Shimmer.fromColors(
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
      ),
      baseColor: Color(0xFFE0E0E0),
      highlightColor: Color(0xFFF5F5F5));
}