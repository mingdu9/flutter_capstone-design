
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
            padding: EdgeInsets.only(top: height * 0.06, ),
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
            padding: EdgeInsets.only(top: height * 0.06,),
            child: Column(
              children: [
                Text("오늘의 용어", style: TextStyle(
                    fontSize: 32, letterSpacing: -1.2,
                    fontWeight: FontWeight.bold
                )),
                SizedBox(height: 8,),
                Text(
                  "자주 만나는 경제 용어들의\n해설을 제공해요", textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 23,
                      letterSpacing: -1.2,
                      fontWeight: FontWeight.values[3]),
                ),
              ],
            ),
          ),
          Image.asset(
            "images/phonewithstock3.png",
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
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(right: 18, left: 18, ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(top: height * 0.06,),
            child: Column(
              children: [
                Text("종목 뉴스 ・ 공시 정보", style: TextStyle(
                    fontSize: 32, letterSpacing: -1.2,
                    fontWeight: FontWeight.bold
                )),
                SizedBox(height: 8,),
                Text(
                  "실제 종목 뉴스와\n공시 정보를 제공해요", textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 23,
                      letterSpacing: -1.2,
                      fontWeight: FontWeight.values[3]),
                ),
              ],
            ),
          ),
          Image.asset(
            "images/phonewithstock4.png",
            fit: BoxFit.fill,
          ),
        ],
      ),
    );
  }
}

class FourthTab extends StatelessWidget {
  const FourthTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(right: 18, left: 18, ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(top: height * 0.06, ),
            child: Column(
              children: [
                Text("종가기반 주식거래", style: TextStyle(
                    fontSize: 32, letterSpacing: -1.2,
                    fontWeight: FontWeight.bold
                )),
                SizedBox(height: 8,),
                Text(
                  "한눈에 들어오는 화면으로\n더 간단한 거래 경험을 제공해요", textAlign: TextAlign.center,
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

class LastTab extends StatelessWidget {
  const LastTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(right: 18, left: 18, top: height * 0.15),
      child: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Text( "시작해볼까요?", style: TextStyle(
                fontSize: 30, letterSpacing: -1.2,
                fontWeight: FontWeight.values[8],)
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 13),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 7,
                    offset: const Offset(9, 5),
                  )
                ],
              ),
              width: width * 0.45, height: width * 0.45,
              child: GestureDetector(
                onTap: () {
                  GoRouter.of(context).replace('/');
                }, // Image tapped
                child: Image.asset(
                  'images/main.png',
                  width: width * 0.2, height: width * 0.2,
                ),
              )
            ),
          ]
        )
      )
    );
  }
}


