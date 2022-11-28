import 'package:capstone1/homePage/profit/calculate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../constant/constants.dart';

// Firebase Authentication과 Firestore 데이터베이스를 사용하기 위한 인스턴스
final auth = FirebaseAuth.instance;
final firestore = FirebaseFirestore.instance;

class UserProvider extends ChangeNotifier {
  int balance = -1;   // 사용자 잔고
  var name = "";    // 사용자 이름
  num realizedProfit = 0;   // 실현 손익
  num realizedProfitRate = 0;   // 수익률
  num totalRealizedProfit = 0;    // 총 실현 손익
  num valuationProfit = 0;    // 평가 손익
  num valuationProfitRate = 0;  // 평가율
  num totalValuationProfit = 0;   // 총 평가 손익
  List<dynamic> tickers = [];   // 보유 종목의 ticker
  Set<dynamic> summaries = {};    // 보유 종목의 요약본
  List<dynamic> userRanks = [];   // 랭킹
  Map<String, dynamic> holdingInfo = {};    //보유 종목
  List<dynamic> history = [];   // 거래 내역

  /*---------flags---------*/
  bool loading = false;
  bool flag = true;


  getHistory() async {
    var list = [];
    history.clear();
    final historyRef = firestore.collection('users').doc(auth.currentUser!.uid).collection('history');
    await historyRef.orderBy('time', descending: true).get()
      .then((value) => list.addAll(value.docs))
      .onError((error, stackTrace) => history.clear());
    for(var element in list){
      var data = element.data();
      element = {
        'time': element.id.replaceAll('-', ' '),
        'value': data['value'],
      };
      element['name'] = await _getNameByTicker(data['ticker']);
      history.add(element);
    }
    notifyListeners();
  }

  dynamic _getNameByTicker(String ticker) async {
    String name = "";
    var result = {};
    await firestore.collection('stocks').doc(ticker).get().then((value) => result = value.data()!).catchError((error, stackTrace) => print(error));
    return result['name'];
  }

  /*------------------------------------------------------수익 계산------------------------------------------------------*/
  calculateTotalProfits() async {
    num valuationSum = 0, realizedSum = 0;
    for(String ticker in tickers){
      calculateValuationProfitByTicker(ticker);
      valuationSum += valuationProfit;
      calculateRealizedProfitByTicker(ticker);
      realizedSum += realizedProfit;
    }
    totalRealizedProfit = realizedSum;
    totalValuationProfit = valuationSum;
    notifyListeners();
  }

  calculateValuationProfitByTicker(String ticker) async {
    final userRef = firestore.collection('users').doc(auth.currentUser!.uid);
    num totalBuy = 0, averageBuy = 0;
    int currentPrice = 0;
    var result1 = {}, result2 = {};
    int? totalCount = holdingInfo['totalCount'];
    num _count = 0;
    List<dynamic> buyList = [];
    try{
      await userRef.collection('holdings').doc(ticker).get()
          .then((value) => result1.addAll(value.data() ?? {}));
      await userRef.collection('holdings').doc(ticker).collection('buy').get()
          .then((value) => buyList.addAll(value.docs));
      await firestore.collection('stocks').doc(ticker).collection('data')
          .orderBy('date', descending: true).limit(1).get()
          .then((value) => result2.addAll(value.docs.first.data()));
      totalCount = result1['totalCount'];
      currentPrice = result2['closingPrice'];
      buyList = buyList.map((e) => e.data()).toList();
      if(buyList.isNotEmpty && flag){
        for(var value in buyList){
          var price = value['price'];
          var count = value['count'];
          totalBuy += price * count;
          _count += count;
        }

        averageBuy = totalBuy / _count;
        valuationProfit = (currentPrice - averageBuy) * totalCount!;
        valuationProfitRate = (valuationProfit / totalBuy) * 100;
      }else {
        throw FirebaseException(plugin: 'list is empty', message: 'profit zero');
      }
    }on FirebaseException catch (error){
      valuationProfit = 0;
      valuationProfitRate = 0;
      print(error);
    }finally{
      notifyListeners();
    }
  }

  calculateRealizedProfitByTicker(String ticker) async {
    final userRef = firestore.collection('users').doc(auth.currentUser!.uid);
    num totalBuy = 0, totalSell = 0;
    num _countBuy = 0, _countSell = 0;
    num averageBuy = 0, averageSell = 0;
    int totalCount = 0;
    var result = {};
    List<dynamic> buyList = [];
    List<dynamic> sellList = [];
    try{
      await userRef.collection('holdings').doc(ticker).get()
          .then((value) => result.addAll(value.data() ?? {}));
      await userRef.collection('holdings').doc(ticker).collection('buy').get()
        .then((value) => buyList.addAll(value.docs));
      await userRef.collection('holdings').doc(ticker).collection('sell').get()
          .then((value) => sellList.addAll(value.docs));
      totalCount = result['totalCount'];
      print(totalCount);
      buyList = buyList.map((e) => e.data()).toList();
      sellList = sellList.map((e) => e.data()).toList();
      if(buyList.isNotEmpty && sellList.isNotEmpty && flag){
        for(var value in buyList){
          var price = value['price'];
          var count = value['count'];
          totalBuy += price * count;
          _countBuy += count;
        }
        for(var value in sellList){
          var price = value['price'];
          var count = value['count'];
          totalSell += price * count;
          _countSell += count;
        }
        averageBuy = totalBuy / _countBuy;
        averageSell = totalSell / _countSell;

        realizedProfit = (totalSell - totalBuy) * totalCount;
        realizedProfitRate = (realizedProfit / totalBuy) * 100;
      } else {
        throw FirebaseException(plugin: 'list is empty', message: 'profit zero');
      }
    } on FirebaseException catch (error) {
      realizedProfit = 0;
      realizedProfitRate = 0;
      print(error);
    } finally{
      notifyListeners();
    }
  }
  /*-----------------------------------------------------수익 계산---------------------------------------------*/

  // get balance & realized profit + holdings' ticker & stocks' summaries
  defineUser() async {
    var result = {};
    loading = true;
    // find user document from uid
    await firestore.collection('users').doc(auth.currentUser!.uid).get()
        .then((value) => result.addAll(value.data()!))
        .onError((error, stackTrace) => print(error));
    balance = result['balance'];
    name = result['name'];
    realizedProfit = result['realizedProfit'];
    await getHoldingTicker();
    await getStockSummaryByTickers(tickers);
    loading = false;
    notifyListeners();
  }

  // get holding stocks' summaries from stocks collection
  getStockSummaryByTickers(List<dynamic> tickers) async {
    List<dynamic> sum = [];
    try {
      if (tickers.isNotEmpty && flag) {
        for (var ticker in tickers) {
          var sumResult = {};
          await firestore.collection('stocks').doc(ticker).collection('data')
              .orderBy('date', descending: true).limit(1).get()
              .then((value) => sumResult.addAll(value.docs.first.data()));
          await firestore.collection('stocks').doc(ticker).get()
              .then((value)=>sumResult.addAll(value.data()!));
          sum.add(sumResult);
        }
        summaries.clear();
        summaries.addAll(sum);
      }
    }on FirebaseException catch (e){
      print(e);
    }
    notifyListeners();
  }

  updateBalance(int number) async {
    balance = number;
    // realizedProfit = double.parse(calculateRate(balance, INITBALANCE).toStringAsFixed(2));
    await firestore.collection('users').doc(auth.currentUser!.uid).update({
      'balance': number,
      // 'realizedProfit' : realizedProfit,
    }).then((value) => print('update balance')).onError((error, stackTrace) => print(stackTrace));
    // defineUser();
    notifyListeners();
  }

  /*--------------------------------------------------------------------------------------*/
  // get holdings' tickers from holdings collection
  getHoldingTicker() async {
    List<dynamic> result = [];
    tickers.clear();
    final userRef = firestore.collection('users').doc(auth.currentUser!.uid);
    await userRef.collection('holdings').where('totalCount', isGreaterThan: 0)
        .get().then((value)=>result.addAll(value.docs))
        .onError((error, stackTrace){
          tickers.clear();
        });
    tickers = result.map((e) => e.id).toList();
    print('getHoldingTicker() : $tickers');
    notifyListeners();
  }

  // modify db tickers array
  setHoldingTicker(List<dynamic> ticker) async {
    await firestore.collection('users').doc(auth.currentUser!.uid).update({
      'tickers': ticker,
    });
  }

  // on pressed buy or sell button, add holdings include date/time, modify total count&value
  addHoldings(String ticker, String deal, String time,int price, int count) async {
    flag = false;
    Timestamp timestamp = Timestamp.now();
    String day = time.split('-').first;
    final userRef = firestore.collection('users').doc(auth.currentUser!.uid);
    // add history to holdings collection
    var todayData = {};
    int todayCount = 0;
    await userRef.collection('holdings').doc(ticker).collection(deal).doc(day)
        .get().then((value){
          todayData.addAll(value.data()!);
          todayCount = todayData['count'];
        })
        .onError((error, stackTrace) async {
          await userRef.collection('holdings').doc(ticker)
              .collection(deal).doc(day).set({
            'price': price,
            'count': 0,
          });
        });
    todayCount = todayData['count'] ?? 0;
    await userRef.collection('holdings').doc(ticker).collection(deal).doc(day).update({
      'count': todayCount + count,
    });
    // modify total data
    if(deal == 'buy'){
      await userRef.collection('holdings').doc(ticker).set({
        'totalCount': (holdingInfo['totalCount'] ?? 0) + count,
        'totalValue': (holdingInfo['totalValue'] ?? 0) + price*count
      });
      print(time);
      addHistory(ticker, time, -(price*count), timestamp);
    }else{
      await userRef.collection('holdings').doc(ticker).set({
        'totalCount': (holdingInfo['totalCount'] ?? 0 - count) <= 0 ? 0 :  holdingInfo['totalCount']! - count,
        'totalValue': (holdingInfo['totalValue'] ?? 0 - price*count) <= 0 ? 0 : holdingInfo['totalValue']! - price*count
      });
      print(time);
      addHistory(ticker, time, price*count, timestamp);
    }
    // update ticker info provider
    await getTickerInfo(ticker);
    print(holdingInfo['totalCount']);

    // modify holding ticker list
    await getHoldingTicker();
    if(holdingInfo['totalCount'] > 0 && !tickers.contains(ticker)){
      tickers.add(ticker);
      print(tickers);
    }else if(holdingInfo['totalCount'] <= 0 && tickers.contains(ticker)){
      tickers.remove(ticker);
      print(tickers);
    }
    await setHoldingTicker(tickers);
    flag = true;
    notifyListeners();
  }

  // get ticker infomation including ticker, total count, total price*count
  getTickerInfo(String ticker) async {
    var result = {};
    final userRef = firestore.collection('users')
        .doc(auth.currentUser!.uid);
    await userRef.collection('holdings').doc(ticker)
          .get()
          .then((value) => result.addAll(value.data()!))
          .onError((error, stackTrace) async {
            print(error);
        await userRef.collection('holdings').doc(ticker).set({
          'totalCount': 0,
          'totalValue': 0
        });
        holdingInfo['ticker'] = int.parse(ticker);
        holdingInfo['totalCount'] = result['totalCount'];
        holdingInfo['totalValue'] = result['totalValue'];
      });
    holdingInfo['ticker'] = int.parse(ticker);
    holdingInfo['totalCount'] = result['totalCount'];
    holdingInfo['totalValue'] = result['totalValue'];
    notifyListeners();
  }

  // add history
  addHistory(String ticker, String time, int value, Timestamp timestamp) async {
    final userRef = firestore.collection('users').doc(auth.currentUser!.uid);
    await userRef.collection('history').doc(time).set({
      'ticker': ticker,
      'value': value,
      'time': timestamp,
    });
  }

  // get user's realized profit rank
  getRank() async {
    loading= true;
    List<dynamic> list = [];
    await firestore.collection('users').orderBy('realizedProfit', descending: true).get()
        .then((value) => list.addAll(value.docs))
        .onError((error, stackTrace) => print(error));
    userRanks = list.map((e) => e.data()).toList();
    print(userRanks);
    loading = false;
    notifyListeners();
  }
}