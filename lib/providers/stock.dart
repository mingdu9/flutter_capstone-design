import 'dart:convert';

import 'package:capstone1/constant/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

final firestore = FirebaseFirestore.instance;

class StorePrice extends ChangeNotifier{
  var stockInfo = {};
  var priceList = [];
  var stockList = [];
  var searchList = [];
  Map<String, dynamic> lastPrice = {};
  var newsList = [];
  var noticeList = [];
  bool load = true;
  bool newsLoad = false;

  int index = 1;
  var term = {};

  getNewTerm() async {
    var url = Uri.parse('$URL/term');
    final response = await http.get(url);
    if(response.statusCode == 200) {
      term = jsonDecode(utf8.decode(response.bodyBytes));
    }else {
      print('error with : ${response.statusCode}');
    }
    notifyListeners();
  }

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

  updateNews(String ticker) async {
    newsLoad = true;
    var url = Uri.parse('$URL/news/$ticker');
    final response = await http.get(url);
    if(response.statusCode == 200){
      getNewsByTicker(ticker);
    }else{
      print('error with : ${response.statusCode}');
    }
    notifyListeners();
  }

  updateNotice(String ticker) async {
    var url = Uri.parse('$URL/notice/$ticker');
    final response = await http.get(url);
    if(response.statusCode == 200){
      getNoticeByTicker(ticker);
    }else{
      print('error with : ${response.statusCode}');
    }
  }

  getPriceByTicker(String ticker) async {
    load = true;
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
    load = false;
    notifyListeners();
  }

  getInfoByTicker(String ticker) async {
    var result;
    load = true;
    await firestore.collection('stocks').doc(ticker).get()
        .then((value){result=value.data();})
        .catchError((e) => print(e));
    // print(result.data());
    stockInfo['name'] = result['name'];
    stockInfo['index'] = result['index'];
    load = false;
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

  getSUM(List<String> tickers) async {

  }
}