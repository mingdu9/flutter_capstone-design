import 'package:flutter/material.dart';

import '../authPage/userPage.dart';
import 'package:capstone1/constant/globalKeys.dart';

class TutorialHome extends StatefulWidget {
  const TutorialHome({Key? key}) : super(key: key);

  @override
  State<TutorialHome> createState() => _TutorialHomeState();
}

class _TutorialHomeState extends State<TutorialHome> {
  @override
  Widget build(BuildContext context) {
    const titleStyle = TextStyle(
        fontSize: 27,
        fontWeight: FontWeight.bold,
        letterSpacing: -2.0
    );
    const textStyle = TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.w400,
        letterSpacing: -2.0
    );
    var mainStyle = BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 1,
          blurRadius: 7,
          offset: const Offset(4, 8),
        )
      ],
      borderRadius: BorderRadius.circular(8.0),
    );

    return ListView(
      physics: NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      padding: EdgeInsets.all(20),
      primary: false,
      children: [
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("안녕하세요 ,", style: titleStyle,),
              Text("가이드 님", style: titleStyle,)
            ]
        ),
        /*----------잔고--------*/
        Container(
          margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 8,
                offset: const Offset(4,8),
              )
            ],
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('잔고', style: titleStyle,),
              Divider(thickness: 1.0, color: Colors.grey.withOpacity(0.5), ),
              Align(
                  alignment: Alignment.centerRight,
                  child: Container(key: homeGlobals.balanceKey, child: Text("3,000,000 원", style: textStyle,)),
              )
            ],
          ),
        ),
        /*----------수익 분석--------*/
        Container(
          margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
          padding: EdgeInsets.all(20),
          decoration: mainStyle,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                key: homeGlobals.profitKey,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '수익 분석',
                      style: titleStyle,
                    ),
                    IconButton(
                        onPressed: (){},
                        icon: Icon(Icons.arrow_forward_ios)
                    )
                  ],
                ),
              ),
              Divider(
                thickness: 1.0,
                color: Colors.grey.withOpacity(0.7),
              ),
            Column(
              children: [
                /*------------------------종목1------------------------*/
                Column(
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text('OO하이닉스',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        letterSpacing: -1.2,
                                        fontSize: 17),
                                  ),
                                  Text('[전기전자, 제조업]',
                                    style: TextStyle(
                                        letterSpacing: -1.2,
                                        color: Colors.grey),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children:
                                    const[
                                      Icon(Icons.arrow_drop_up_rounded, color: Colors.redAccent),
                                      Text('2.41 %',
                                        style: TextStyle(
                                            fontSize: 23,
                                            color: Colors.redAccent),)
                                    ]
                                ),
                                Text('74,180원',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.redAccent
                                  ),)
                              ]
                          ),
                        ]
                    ), Divider(
                      thickness: 0.5, color: Colors.grey.withOpacity(0.7),
                    )
                  ],
                ),
              ],
            )
            ],
          ),
        ),
        /*----------수익 분석--------*/
        Container(
          margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
          padding: EdgeInsets.all(20),
          decoration: mainStyle,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  key: homeGlobals.holdingsKey,
                  child: Text(
                    '보유 종목',
                    style: titleStyle,
                  ),
                ),
                Divider(
                  thickness: 1.0,
                  color: Colors.grey.withOpacity(0.7),
                ),
                ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: const [
                                      Text('OO하이닉스',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            letterSpacing: -1.2,
                                            fontSize: 17
                                        ),),
                                      Text('[전기전자, 제조업]',
                                        style: TextStyle(
                                            letterSpacing: -1.2,
                                            color: Colors.grey
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '86,200원',
                                    style: TextStyle(
                                        fontSize: 23,
                                        color: Colors.redAccent
                                    ),),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children:
                                    const [
                                      Icon(Icons.arrow_drop_up_rounded,
                                          color: Colors.redAccent),
                                      Text('3.12 %',
                                        style: TextStyle(fontSize: 15,
                                            color: Colors.redAccent),)
                                    ]
                                  ),
                                ],
                              )
                            ],
                          ),
                          Divider(thickness: 0.5, color: Colors.grey.withOpacity(0.7),)
                        ],
                      );
                    })
              ]
          ),
        ),
      ],
    );
  }
}
