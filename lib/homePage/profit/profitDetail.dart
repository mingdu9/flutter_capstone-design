import 'package:capstone1/constant/constants.dart';
import 'package:capstone1/homePage/profit/calculate.dart';
import 'package:capstone1/providers/user.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';


class ProfitDetail extends StatefulWidget {
  const ProfitDetail({Key? key, }) : super(key: key);

  @override
  State<ProfitDetail> createState() => _ProfitDetailState();
}

class _ProfitDetailState extends State<ProfitDetail> {
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
  final titleStyle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    letterSpacing: -2.0,
  );

  @override
  initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black,),
          onPressed: (){GoRouter.of(context).pop();},
        ),
        backgroundColor: Colors.transparent, elevation: 0,
        title: Text("수익 분석", style: TextStyle(color: Colors.black, fontWeight: FontWeight.values[4]),),
        actions: [
          IconButton(onPressed: () => print('tutorial'), icon: Icon(Icons.question_mark, color: Colors.black,))
        ],
      ),
      body: ListView(
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        padding: EdgeInsets.only(top: 20, bottom: 20),
        primary: false,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                    decoration: shadowedBox,
                    margin: EdgeInsets.only(left: 20, right: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('총 실현손익', style: titleStyle,),
                          Divider(height: 23, thickness: 1,),
                          Text('${addComma(context.watch<UserProvider>().totalRealizedProfit)}원',
                            style: TextStyle(
                              fontSize: 20, color: (context.watch<UserProvider>().realizedProfit >= 0 ?
                                (context.watch<UserProvider>().realizedProfit == 0 ? Colors.grey : Colors.redAccent)
                                  : Colors.blueAccent),
                            ),
                          )
                        ],
                      ),
                    )
                )
              ),
              Expanded(
                  child: Container(
                      decoration: shadowedBox,
                      margin: EdgeInsets.only(left: 10, right: 20),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('총 평가손익', style: titleStyle,),
                            Divider(height: 23, thickness: 1,),
                            Text('${addComma(context.watch<UserProvider>().totalValuationProfit)}원', style: TextStyle(
                              fontSize: 20,
                              color: (context.watch<UserProvider>().valuationProfit >= 0 ? (
                                  context.watch<UserProvider>().valuationProfit == 0 ? Colors.grey : Colors.redAccent): Colors.blueAccent),
                            ),),
                          ],
                        ),
                      )
                  )
              ),
            ],
          ),
          Container(
            decoration: shadowedBox,
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("종목별", style: titleStyle,),
                Divider(thickness: 1, height: 23,),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  primary: false,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  itemCount: context.watch<UserProvider>().tickers.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: (){

                      },
                      child: Column(
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('${context.read<UserProvider>().summaries.elementAt(index)['name']}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              letterSpacing: -1.2,
                                              fontSize: 17),
                                        ),
                                        Text('${context.watch<UserProvider>().summaries.elementAt(index)['index']}',
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
                                          children: context.watch<UserProvider>().valuationProfitRate > 0 ?
                                          [
                                            Icon(Icons.arrow_drop_up_rounded, color: Colors.redAccent),
                                            Text('${context.watch<UserProvider>().valuationProfitRate} %',
                                              style: TextStyle(
                                                  fontSize: 23,
                                                  color: Colors.redAccent),)
                                          ] : context.watch<UserProvider>().valuationProfitRate == 0 ? [
                                            Text('- ${context.watch<UserProvider>().valuationProfitRate} %',
                                              style: TextStyle(
                                                  fontSize: 23,
                                                  color: Colors.grey),)
                                          ]: [
                                            Icon(Icons.arrow_drop_down_rounded, color: Colors.blue,),
                                            Text('${context.watch<UserProvider>().valuationProfitRate} %',
                                              style: TextStyle(
                                                  fontSize: 23,
                                                  color: Colors.blue),)
                                          ]
                                      ),
                                      Text('${addComma(context.watch<UserProvider>().valuationProfitRate.ceil())}원',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: context.watch<UserProvider>().valuationProfitRate > 0
                                                ? Colors.redAccent
                                                : ( context.watch<UserProvider>().valuationProfitRate == 0 ? Colors.black54 : Colors.blueAccent)),
                                      ),                ]),

                              ]
                          ), Divider(
                            thickness: 0.5, color: Colors.grey.withOpacity(0.7),
                          )
                        ],
                      ),
                    );
                  },
                )
              ],
            ),
          )
        ],
      )
    );
  }
}
