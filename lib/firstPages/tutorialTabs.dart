
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FirstTab extends StatelessWidget {
  const FirstTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(right: 18, left: 18, ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(left: width * 0.11, top: height * 0.03, right: width * 0.11, bottom: height * 0.03),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "스탁에듀",
                      style: TextStyle(
                        fontSize: 30,
                        letterSpacing: -1.2,
                        fontWeight: FontWeight.values[8],
                      ),
                    ),
                    Text(
                      "로",
                      style: TextStyle(
                        fontSize: 30,
                        letterSpacing: -1.2,
                        fontWeight: FontWeight.values[3],
                      ),
                    ),
                  ],
                ),
                Text(
                  "주식을 시작해보세요.",
                  style: TextStyle(
                      fontSize: 30,
                      letterSpacing: -1.2,
                      fontWeight: FontWeight.values[3]),
                ),
              ],
            ),
          ),
          Image.asset(
            "images/phonewithstock1.png",
            fit: BoxFit.fitHeight,
          ),
        ],
      ),
    );
  }
}

class SecondTab extends StatelessWidget {
  const SecondTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(right: 18, left: 18, ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(left: width * 0.11, top: height * 0.029, right: width * 0.11, bottom: height * 0.03),
            child: Column(
              children: [
                Text("종가기반 주식거래", style: TextStyle(
                    fontSize: 32, letterSpacing: -1.2,
                    fontWeight: FontWeight.bold
                )),
                SizedBox(height: 8,),
                Text(
                  "한눈에 들어오는 화면으로\n거래 경험을 제공해요", textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 23,
                      letterSpacing: -1.2,
                      fontWeight: FontWeight.values[3]),
                ),
              ],
            ),
          ),
          Image.asset(
            "images/phonewithstock2.png",
            fit: BoxFit.fill,
          ),
        ],
      ),
    );
  }
}

class ThirdTab extends StatelessWidget {
  const ThirdTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(right: 18, left: 18, ),
      child: Center(
        child: GestureDetector(
          child: Text("시작하기"),
          onTap: (){GoRouter.of(context).go('/login');},
        ),
      ),
    );
  }
}


