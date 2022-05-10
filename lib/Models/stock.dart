import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final firestore = FirebaseFirestore.instance;

class StorePrice extends ChangeNotifier{
  var stockInfo = {};
  var priceList = [];
  var stockList = [];
  var searchList = [];
  Map<String, dynamic> lastPrice = {};

  getPriceByTicker(String ticker) async {
    var result = [];
    await firestore.collection('stocks').doc(ticker).collection('data').get()
        .then((QuerySnapshot ds) {
          result.addAll(ds.docs);
        })
        .catchError((e) => print(e));
    priceList = result.map((e) => e.data()).toList();
    lastPrice = {
      'price': priceList[priceList.length-1]['closingPrice'],
      'changeRate': priceList[priceList.length-1]['fluctuation'],
    };
    notifyListeners();
  }

  getInfoByTicker(String ticker) async {
    var result;
    await firestore.collection('stocks').doc(ticker).get()
        .then((value){result=value.data();})
        .catchError((e) => print(e));
    // print(result.data());
    stockInfo['name'] = result['name'];
    stockInfo['index'] = result['index'];
    notifyListeners();
  }

  getInfoByName(String name) async {
    searchList.clear();
    await firestore.collection('stocks').where('name', isEqualTo: name).get()
        .then((value) => value.docs.forEach((element) => searchList.add(element.data())))
        .catchError((error, stackTrace) => print(error));
    notifyListeners();
  }

  getStockRanking()async{
    var result = [];
    await firestore.collection('stocks').orderBy("volume", descending: true).limit(10).get()
        .then((value) => result.addAll(value.docs))
        .catchError((error, stackTrace) => print(error));
    stockList = result.map((e) => e.data()).toList();
    notifyListeners();
  }

  setPriceList(String ticker) async {
    await getPriceByTicker(ticker);
    getInfoByTicker(ticker);
    notifyListeners();
  }
}