import 'package:capstone1/constant/globalKeys.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../main.dart';

class TutorialRank extends StatefulWidget {
  const TutorialRank({Key? key}) : super(key: key);

  @override
  State<TutorialRank> createState() => _TutorialRankState();
}

class _TutorialRankState extends State<TutorialRank> {

  final shadowedBox = BoxDecoration(
    color: Colors.white,
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        spreadRadius: 1,
        blurRadius: 7,
        offset: const Offset(4,8),
      )
    ],
    borderRadius: BorderRadius.circular(8.0),
  );

  final List<String> imgList = [
    'https://images.unsplash.com/photo-1554415707-6e8cfc93fe23?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2070&q=80',
    'https://images.unsplash.com/photo-1590283603385-17ffb3a7f29f?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2070&q=80',
    'https://images.unsplash.com/photo-1642543348745-03b1219733d9?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2070&q=80'
  ];
  final List<String> stringList = [
    '실패없이 투자하는 법',
    '당신이 손해보는 열 가지 이유',
    'PER? EPS? 알아야 할 주식 용어'
  ];

  @override
  Widget build(BuildContext context) {
    List<Widget> imageSliders = imgList.map((item) =>
        Container(
          child: Container(
            margin: EdgeInsets.all(5.0),
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(13.0)),
                child: Stack(
                  children: <Widget>[
                    Image.network(
                      item, fit: BoxFit.cover, width: 1000.0,
                      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress){
                        if (loadingProgress == null) return child;
                        return Shimmer.fromColors(
                            baseColor: Color(0xFFE0E0E0),
                            highlightColor: Color(0xFFF5F5F5),
                            child: Container(
                              width: 1000, height: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.white, borderRadius: BorderRadius.circular(13)
                              ),
                            ));
                      },
                    ),
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: const [
                                Color.fromARGB(200, 0, 0, 0),
                                Color.fromARGB(0, 0, 0, 0)
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                          child: Text(
                            stringList[imgList.indexOf(item)],
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                                letterSpacing: -1.1),
                          )),
                    ),
                  ],
                )),
          ),
        )).toList();

    return ListView(
      physics: NeverScrollableScrollPhysics(),
      children: [
        Container(
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.all(20),
          decoration: shadowedBox,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                key: homeGlobals.myRankKey,
                child: Text(
                  '내 순위',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 23, letterSpacing: -1.2),
                ),
              ),
              Divider(
                thickness: 1.0,
                color: Colors.grey.withOpacity(0.5),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 5),
                        child: Text(
                          '1. ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 23,
                              letterSpacing: -1.2),
                        ),
                      ),
                      Expanded(
                          child: Text(auth.currentUser!.displayName ?? ' ',
                            textAlign: TextAlign.start,
                            style: TextStyle(fontSize: 18, letterSpacing: -1.2),
                          )),
                      Text('2.41 %',
                          style: TextStyle(fontSize: 22, letterSpacing: -1.2))
                    ]),
              )
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Container(
                  key: homeGlobals.tipsKey,
                  child: Text(
                    '많이 본 뉴스',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        letterSpacing: -1.5),
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () => {},
              icon: Icon(
                Icons.refresh_rounded,
                color: Colors.black, size: 30,
              ),
              style: IconButton.styleFrom(
              ),
            ),
          ],
        ),
        Container(
          child: CarouselSlider(
            options: CarouselOptions(
              autoPlay: true,
              enlargeCenterPage: true,
              aspectRatio: 2.0,
            ),
            items: imageSliders,
          ),
        ),
        Container(
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.all(20),
          decoration: shadowedBox,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                key: homeGlobals.userRankKey,
                child: Text(
                  'top 10',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 30, letterSpacing: -1.2),
                ),
              ),
              Divider(
                thickness: 1.0,
              ),
              ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: 10,
                  itemBuilder: (c, i) {
                    var value = (8-i)*0.34;
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Container(
                              margin: EdgeInsets.only(right: 5),
                              child: Text(
                                '${i + 1}. ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 23, letterSpacing: -1.2),
                              ),
                            ),
                            Expanded(
                                child: Text(
                                  i == 0 ? '가이드' : '유저${i+1}',
                                  style: TextStyle(fontSize: 18, letterSpacing: -1.2),
                                )),
                            Text(
                            i == 0 ? '2.41%' : '${value.toStringAsFixed(2)} %',
                                style: TextStyle(fontSize: 22, letterSpacing: -1.2))
                          ]),
                        ),
                        Divider(indent: 3,)
                      ],
                    );
                  }),
            ],
          ),
        )
      ],
    );
  }
}
