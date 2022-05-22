import 'package:capstone1/homePage/loadingShimmer.dart';
import 'package:capstone1/homePage/profit/calculate.dart';
import 'package:capstone1/providers/user.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final firestore = FirebaseFirestore.instance;

class HoldingsBox extends StatefulWidget {
  const HoldingsBox({Key? key}) : super(key: key);

  @override
  State<HoldingsBox> createState() => _HoldingsBoxState();
}

class _HoldingsBoxState extends State<HoldingsBox> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var summaries = context.watch<StoreUser>().sumList;
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
    const titleStyle = TextStyle(
      fontSize: 27,
      fontWeight: FontWeight.bold,
      letterSpacing: -2.0,
    );

    return Container(
      margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
      padding: EdgeInsets.all(20),
      decoration: mainStyle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '보유 종목',
            style: titleStyle,
          ),
          Divider(
            thickness: 1.0,
            color: Colors.grey.withOpacity(0.7),
          ),
          context.watch<StoreUser>().loading == true ?
            LoadingShimmer() : (context.watch<StoreUser>().tickers.isEmpty ?
          Center(
            child: Text('없음', style: TextStyle(
                fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black87),
            ),) : ( ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: context.read<StoreUser>().tickers.length,
              itemBuilder: (context, index) {
                final currentSum = summaries.elementAt(index);
                return GestureDetector(
                  onTap: (){
                    GoRouter.of(context).go('/mainTab/0/stockDetail/${currentSum['ticker']}');
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
                                  Text('${currentSum['name']}', style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: -1.2,
                                      fontSize: 17
                                  ),),
                                  Text('${currentSum['index']}', style: TextStyle(
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
                              Text('${addComma(currentSum['closingPrice'])}원', style: TextStyle(
                                  fontSize: 23,
                                  color: currentSum['fluctuation'] > 0 ? Colors.redAccent : Colors.blueAccent
                              ),),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: currentSum['fluctuation'] > 0 ?
                                [
                                  Icon(Icons.arrow_drop_up_rounded, color: Colors.redAccent),
                                  Text('${currentSum['fluctuation']} %',
                                    style: TextStyle(fontSize: 15, color: Colors.redAccent),)
                                ] : [
                                  Icon(
                                    Icons.arrow_drop_down_rounded, color: Colors.blue,),
                                  Text('${currentSum['fluctuation']} %',
                                    style: TextStyle(fontSize: 15, color: Colors.blue),)
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                      Divider(thickness: 0.5, color: Colors.grey.withOpacity(0.7),)
                    ],
                  ),
                );
              }))),
        ]
      ),
    );
  }
}
