import 'package:capstone1/homePage/profit/calculate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../constant/constants.dart';

final auth = FirebaseAuth.instance;
final firestore = FirebaseFirestore.instance;

class UserProvider extends ChangeNotifier {
  int balance = -1;
  num realizedProfit = 0;
  num realizedProfitRate = 0;
  num totalRealizedProfit = 0;
  num valuationProfit = 0;
  num valuationProfitRate = 0;
  num totalValuationProfit = 0;
  List<dynamic> holdings = [];
  List<dynamic> tickers = [];
  Set<dynamic> summaries = {};
  List<dynamic> userRanks = [];
  Map<String, dynamic> holdingInfo = {};

  /*---------flags---------*/
  bool loading = false;
  bool flag = true;


  // updateCount(int count, int index, int price, String ticker) (deleted)

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
    num totalBuy = 0;
    int currentPrice = 0;
    var result1 = {}, result2 = {};
    int? totalCount = holdingInfo['totalCount'];
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
      print(totalCount);
      currentPrice = result2['closingPrice'] * totalCount;
      buyList = buyList.map((e) => e.data()).toList();
      if(buyList.isNotEmpty && flag){
        for(var value in buyList){
          var price = value['price'];
          var count = value['count'];
          totalBuy += price * count;
        }
        valuationProfit = (currentPrice - totalBuy) * totalCount!;
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
        }
        for(var value in sellList){
          var price = value['price'];
          var count = value['count'];
          totalSell += price * count;
        }
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

  // get balance & realized profit + holdings' ticker & stocks' summaries
  defineUser() async {
    var result = {};
    loading = true;
    // find user document from uid
    await firestore.collection('users').doc(auth.currentUser!.uid).get()
        .then((value) => result.addAll(value.data()!))
        .onError((error, stackTrace) => print(error));
    balance = result['balance'];
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

  updateCount(int count, int index, int price, String ticker)async{
    if(holdings[index]['count']+count <= 0){
      tickers.remove(ticker);
      holdings.removeAt(index);
    }else {
      var sum = holdings[index]['average'] * holdings[index]['count'];
      holdings[index]['count'] = (price < 0 ? holdings[index]['count'] - count
          : holdings[index]['count'] + count);
      holdings[index]['average'] = (sum + price * count) / holdings[index]['count'];
    }

    //update firestore
    await firestore.collection('users').doc(auth.currentUser!.email).update({
      'holdings': holdings,
    }).then((value) => print('update count'))
        .onError((error, stackTrace) => print(stackTrace));
    print('count updated holdings: $holdings');
    print('count updated tickers: $tickers');
    //defineUser();
    notifyListeners();
  }


  addHolding(int price, int count, String ticker) async {
    Map<String, Object> addItem = {
      'ticker': ticker,
      'count': count,
      'average' : price,
    };
    holdings.add(addItem);
    await firestore.collection('users').doc(auth.currentUser!.uid).update({
      'holdings': holdings,
    });
    //defineUser();
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
      addHistory(ticker, time, -(price*count));
    }else{
      await userRef.collection('holdings').doc(ticker).set({
        'totalCount': (holdingInfo['totalCount'] ?? 0 - count) <= 0 ? 0 :  holdingInfo['totalCount']! - count,
        'totalValue': (holdingInfo['totalValue'] ?? 0 - price*count) <= 0 ? 0 : holdingInfo['totalValue']! - price*count
      });
      addHistory(ticker, time, price*count);
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
  addHistory(String ticker, String time,int value) async {
    final userRef = firestore.collection('users').doc(auth.currentUser!.uid);
    await userRef.collection('history').doc(time).set({
      'ticker': ticker,
      'value': value,
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