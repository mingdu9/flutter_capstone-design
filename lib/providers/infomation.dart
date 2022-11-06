import 'dart:convert';

import 'package:capstone1/constant/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

final firestore = FirebaseFirestore.instance;

class InfoProvider extends ChangeNotifier {
  var newsList = [];
  var noticeList = [];
  bool load = true;
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
    await firestore.collection('stocks').doc(ticker).collection('news').orderBy("date", descending: true).get()
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
    var url = Uri.parse('$URL/news/$ticker');
    final response = await http.get(url);
    if(response.statusCode == 200){
      var result = [];
      await firestore.collection('stocks').doc(ticker).collection('news').orderBy("date", descending: true).get()
          .then((value) => result.addAll(value.docs))
          .catchError((error, stackTrace) => print(error));
      newsList = result.map((e) => e.data()).toList();
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
    notifyListeners();
  }

}