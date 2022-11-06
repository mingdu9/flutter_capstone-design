import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../constant/constants.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final FirebaseFirestore firestore = FirebaseFirestore.instance;

class AuthProvider extends ChangeNotifier {
  late User _user;
  String _lastFirebaseResponse = "";

  CollectionReference users = firestore.collection('users');

  getUser(){
    return _user;
  }

  setUser(User user){
    _user = user;
    notifyListeners();
  }

  setLastFirebaseResponse(String msg){
    _lastFirebaseResponse = msg;
  }

  getLastFirebaseResponse(){
    String returnStr = _lastFirebaseResponse;
    _lastFirebaseResponse = "";
    return returnStr;
  }

  Future<bool> signup(email, pw, name) async{
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email,
          password: pw
      );
      if(userCredential.user != null) {
        userCredential.user?.updateDisplayName(name);
        users.doc(userCredential.user?.uid).set({
          'name': name,
          'balance': INITBALANCE,
          'tickers': [],
          'realizedProfit': 0,
        }).then((_) => print('added'))
            .catchError((e) => print('error: $e'));
        userCredential.user?.sendEmailVerification();
      }
      return true;
    } on FirebaseAuthException catch (e) {
      setLastFirebaseResponse(e.code);
      return false;
    }
  }

  Future<bool> login(email, password) async {
    bool check = true;
    try{
      UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
      setUser(userCredential.user!);
      return check;
    }on FirebaseAuthException catch(e){
      setLastFirebaseResponse(e.code);
      return !check;
    }
  }

  logout() async {
    await auth.signOut();
  }

  withdraw(String uid) async {
    try {
      await users.doc(uid).delete().then((value) => print('deleted'));
      await auth.currentUser!.delete()
          .then((value) => print('deleted'));
      auth.signOut();
    } on Exception catch (e) {
      print(e);
    }
  }

  sendPWResetEmail(String? email) async {
    await auth.setLanguageCode('ko');
    auth.sendPasswordResetEmail(email: email??"");
  }

  sendPasswordResetEmailByKor() async {
    await auth.setLanguageCode("ko");
    auth.sendPasswordResetEmail(email: getUser().email);
  }
}
