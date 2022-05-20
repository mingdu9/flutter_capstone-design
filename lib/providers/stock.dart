import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final firestore = FirebaseFirestore.instance;

class StorePrice extends ChangeNotifier{
  var stockInfo = {};
  var priceList = [];
  var stockList = [];
  var searchList = [];
  Map<String, dynamic> lastPrice = {};
  var newsList = [];
  var noticeList = [];

  getNewsByTicker(String ticker) async {
    var result = [];
    await firestore.collection('stocks').doc(ticker).collection('news').orderBy("date", descending: true).limit(10).get()
        .then((value) => result.addAll(value.docs))
        .catchError((error, stackTrace) => print(error));
    newsList = result.map((e) => e.data()).toList();
    notifyListeners();
  }

  getNoticeByTicker(String ticker) async {
    var result = [];
    await firestore.collection('stocks').doc(ticker).collection('notice').orderBy("date", descending: true).get()
        .then((value) => result.addAll(value.docs))
        .catchError((error, stackTrace) => print(error));
    noticeList = result.map((e) => e.data()).toList();
    notifyListeners();
  }

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

  searchByName(String name) async {
    var list = [];
    list.clear();
    await firestore.collection('stocks').get()
        .then((value) => value.docs.forEach((element) => list.add(element.data())))
        .catchError((error) => print(error));
    if(list.isNotEmpty && name.isNotEmpty){
      searchList.clear();
      for (var value1 in list.where((element) => element['name'].contains(name))){
        searchList.add(value1);
      }
    }
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