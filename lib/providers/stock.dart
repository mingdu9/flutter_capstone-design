import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constant/constants.dart';

// Firebase Authentication과 Firestore 데이터베이스를 사용하기 위한 인스턴스
final firestore = FirebaseFirestore.instance;
final stockRef = firestore.collection('stock');

class StockProvider extends ChangeNotifier{
  var stockInfo = {};   // 주식 종목의 정보
  var priceList = [];   // 주식 종가 List
  var stockRankList = [];   // 주식 거래량 랭킹
  var searchList = [];    // 주식 검색 결과
  Map<String, dynamic> lastPrice = {};    // 가장 마지막 종가 데이터
  var seenNewsList = [];    // 많이 본 뉴스
  bool loading = true;    // flag

  // ticker 종목의 종가 및 가장 마지막 종가값 저장
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

  // ticker 종목의 정보 저장
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

  // 이름으로 종목 검색
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

  // 종목의 거래량 랭킹 저장
  getStockRanking()async{
    var result = [];
    await firestore.collection('stocks').orderBy("volume", descending: true).limit(10).get()
        .then((value) => result.addAll(value.docs))
        .catchError((error, stackTrace) => print(error));
    stockRankList = result.map((e) => e.data()).toList();
    notifyListeners();
  }

  // 라인 차트에 값을 넣기 위한 메소드 모음
  setPriceList(String ticker) async {
    await getPriceByTicker(ticker);
    getInfoByTicker(ticker);
    notifyListeners();
  }

  // 많이 본 뉴스 저장
  getNewsList() async {
    var result = [];
    await firestore.collection('news').get().then((value) => result.addAll(value.docs)).catchError((error, stackTrace) => print(error));
    seenNewsList = result.map((e) => e.data()).toList();
    notifyListeners();
  }

  // 서버로 많이 본 뉴스 업데이트 요청
  updateNewsList() async {
    var url = Uri.parse('$URL/seen');
    final response = await http.get(url);
    if(response.statusCode == 200){
      var result = [];
      await firestore.collection('news').get()
          .then((value) => result.addAll(value.docs))
          .catchError((error, stackTrace) => print(error));
      seenNewsList = result.map((e) => e.data()).toList();
    }else{
      print('error with : ${response.statusCode}');
    }
    notifyListeners();
  }
}