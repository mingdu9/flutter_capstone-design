import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final firestore = FirebaseFirestore.instance;
final stockRef = firestore.collection('stock');

class StockProvider extends ChangeNotifier{
  var stockInfo = {};
  var priceList = [];
  var stockRankList = [];
  var searchList = [];
  Map<String, dynamic> lastPrice = {};
  bool loading = true;

  getPriceByTicker(String ticker) async {
    loading = true;
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
    loading = false;
    notifyListeners();
  }

  getInfoByTicker(String ticker) async {
    var result;
    loading = true;
    await firestore.collection('stocks').doc(ticker).get()
        .then((value){result=value.data();})
        .catchError((e) => print(e));
    stockInfo['name'] = result['name'];
    stockInfo['index'] = result['index'];
    loading = false;
    notifyListeners();
  }

  searchByName(String name) async {
    var list = [];
    searchList.clear();
    list.clear();
    notifyListeners();
    try {
      await firestore.collection('stocks').get()
          .then((value) =>
          value.docs.forEach((element) => list.add(element.data())))
          .catchError((error) => print(error));
      if (list.isNotEmpty && name.isNotEmpty) {
        searchList.clear();
        for (var value1 in list.where((element) =>
            element['name'].contains(name))) {
          searchList.add(value1);
        }
      }
    }on NoSuchMethodError catch (_, e){
      print(name);
    }finally{
      notifyListeners();
    }
  }

  getStockRanking()async{
    var result = [];
    await firestore.collection('stocks').orderBy("volume", descending: true).limit(10).get()
        .then((value) => result.addAll(value.docs))
        .catchError((error, stackTrace) => print(error));
    stockRankList = result.map((e) => e.data()).toList();
    notifyListeners();
  }

  setPriceList(String ticker) async {
    await getPriceByTicker(ticker);
    getInfoByTicker(ticker);
    notifyListeners();
  }

}