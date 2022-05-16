import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final auth = FirebaseAuth.instance;
const img = "https://img.freepik.com/free-vector/stock-market-analysis-illustration_23-2148588123.jpg?w=2000&t=st=1652689917~exp=1652690517~hmac=d71cab9ebb6317193a223533061c0a96bc9e5da03db8028aacbee53700bfd6b2";

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Text("환영합니다."),
            Image.network(img),
            Text("주식을 쉽게 시작하기 위한 스탁에듀입니다."),
          ],
        ),
      )
    );
  }
}
