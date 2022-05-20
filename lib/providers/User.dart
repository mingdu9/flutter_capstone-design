import 'package:capstone1/constant/constants.dart';
import 'package:capstone1/homePage/calculate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final auth = FirebaseAuth.instance;
final firestore = FirebaseFirestore.instance;

class StoreUser extends ChangeNotifier {
  int balance = 0;
  num profit = 0;
  List<dynamic> holdings = [];
  Set<String> tickers = {};
  Set<dynamic> sumList = {};

  defineUser() async {
    var result = {};
    List<String> list = [];
    List<dynamic> sum = [];
    // find user document from email
    await firestore.collection('users').doc(auth.currentUser!.email).get()
        .then((value) => result.addAll(value.data()!))
        .onError((error, stackTrace) => print(error));
    balance = result['balance'];
    profit = result['profit'];
    holdings = result['holdings'];
    if(holdings.isEmpty){
      tickers.clear();
    }else{
      // get tickers from holdings
      for (var element in holdings) {
        list.add(element['ticker']);
      }
      tickers.addAll(list.toSet());
      // get holdings summary
      for (var element in holdings){
        var sumResult = {};
        await firestore.collection('stocks').doc(element['ticker']).collection('data')
            .orderBy('date', descending: true).limit(1).get()
            .then((value) => sumResult.addAll(value.docs.first.data()))
            .catchError((error) => print(error));
        await firestore.collection('stocks').doc(element['ticker']).get()
            .then((value) {
              sumResult.addAll(value.data()!);
        }).catchError((error) => print(error));
        sum.add(sumResult);
      }
      sumList.clear();
      sumList.addAll(sum);
    }
    notifyListeners();
  }

  updateBalance(int number) async {
    balance = number;
    profit = double.parse(calculateRate(balance, INITBALANCE).toStringAsFixed(2));
   await firestore.collection('users').doc(auth.currentUser!.email).update({
     'balance': number,
     'profit' : profit,
   }).then((value) => print('update balance'))
    .onError((error, stackTrace) => print('error occurs'));
   defineUser();
   print('updated Balance: $balance');
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
    await firestore.collection('users').doc(auth.currentUser!.email).update({
      'holdings': holdings,
    });
    //defineUser();
    notifyListeners();
  }


}