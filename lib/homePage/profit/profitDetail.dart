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

  num getSUM(list){
    num sum = 0;
    List<num> numa = [];
    for(int i=0;i<list.length;i++){
      numa.add(list[i]['closingPrice']);
      sum += numa[i];
    }
    return sum;
  }

  var testRate = 0.0;
  var testPrice = 0;

  @override
  initState(){
    super.initState();
  }

  getTest(summaries){
    var closingSum = 0;
    for(var element in summaries){
      int price = element['closingPrice'];
      closingSum += price;
    }
    print("$testRate $testPrice");
    testRate = calculateRate(closingSum, INITBALANCE);
    testPrice = closingSum - INITBALANCE;
    if(testRate == -100 && testPrice == -INITBALANCE){
      testRate = 0;
      testPrice = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    var summaries = context.watch<StoreUser>().sumList;
    getTest(summaries);
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
                          Text('실현손익', style: titleStyle,),
                          Divider(height: 23, thickness: 1,),
                          Text('${context.watch<StoreUser>().profit.toStringAsFixed(2)}%', style: TextStyle(
                              fontSize: 20,
                              color: (context.watch<StoreUser>().profit >= 0 ? (
                                context.watch<StoreUser>().profit == 0 ? Colors.grey : Colors.redAccent
                              ): Colors.blueAccent)
                          )),
                          SizedBox(height: 5),
                          Text('${addComma(context.watch<StoreUser>().balance - INITBALANCE)}원', style: TextStyle(
                            fontSize: 15,
                            color: (context.watch<StoreUser>().profit >= 0 ? (
                                context.watch<StoreUser>().profit == 0 ? Colors.grey : Colors.redAccent): Colors.blueAccent),
                          ),)
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
                            Text('평가손익', style: titleStyle,),
                            Divider(height: 23, thickness: 1,),
                            Text('${testRate.toStringAsFixed(2)}%', style: TextStyle(
                                fontSize: 20,
                                color: (testRate >= 0 ? (
                                    testRate == 0 ? Colors.grey : Colors.redAccent
                                ): Colors.blueAccent)
                            )),
                            SizedBox(height: 5),
                            Text('${addComma(testPrice)}원', style: TextStyle(
                              fontSize: 15,
                              color: (testPrice >= 0 ? (
                                  testPrice == 0 ? Colors.grey : Colors.redAccent): Colors.blueAccent),
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
                Text("종목별 수익", style: titleStyle,),
                Divider(thickness: 1, height: 23,),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  primary: false,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  itemCount: (summaries.isEmpty ? 1 : summaries.length),
                  itemBuilder: (BuildContext context, int index) {
                    try{
                      final currentSummary = summaries.elementAt(index);
                      String rate = calculateRate(currentSummary['closingPrice'], context.watch<StoreUser>().holdings[index]['average']).toStringAsFixed(2);
                      num profit = calculateProfit(currentSummary['closingPrice'], context.watch<StoreUser>().holdings[index]['average'], context.watch<StoreUser>().holdings[index]['count']);
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${currentSummary['name']}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            letterSpacing: -1.2,
                                            fontSize: 17),
                                      ),
                                      Text(
                                        '${currentSummary['index']}',
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
                                    children: double.parse(rate) > 0
                                        ? [
                                      Icon(Icons.arrow_drop_up_rounded,
                                          color: Colors.redAccent),
                                      Text(
                                        '$rate %',
                                        style: TextStyle(
                                            fontSize: 23,
                                            color: Colors.redAccent),
                                      )
                                    ]
                                        : (double.parse(rate) == 0 ? [
                                      Text(
                                        '- $rate %',
                                        style: TextStyle(
                                            fontSize: 23,
                                            color: Colors.grey),
                                      )
                                    ]: [
                                      Icon(
                                        Icons.arrow_drop_down_rounded,
                                        color: Colors.blue,
                                      ),
                                      Text(
                                        '$rate %',
                                        style: TextStyle(
                                            fontSize: 23,
                                            color: Colors.blue),
                                      )
                                    ]),
                                  ),
                                  Text(
                                    '${addComma(profit.ceil())}원',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: double.parse(rate) > 0
                                            ? Colors.redAccent
                                            : ( double.parse(rate) == 0 ? Colors.black54 : Colors.blueAccent)),
                                  ),
                                ],
                              )
                            ],
                          ),
                          Divider(
                            thickness: 0.7,
                          )
                        ],
                      );
                    }catch(e){
                      return Center(
                        child: Text('없음', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black87),)
                      );
                    }
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
