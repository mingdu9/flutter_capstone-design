import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:capstone1/constant/globalKeys.dart';
import 'package:capstone1/homePage/loadingShimmer.dart';
import 'package:capstone1/homePage/profit/calculate.dart';
import 'package:capstone1/providers/stock.dart';
import 'package:capstone1/providers/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final firestore = FirebaseFirestore.instance;

class HoldingsBox extends StatefulWidget {
  const HoldingsBox({Key? key}) : super(key: key);

  @override
  State<HoldingsBox> createState() => _HoldingsBoxState();
}

class _HoldingsBoxState extends State<HoldingsBox>{
  BoxDecoration mainStyle = BoxDecoration(
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

  TextStyle titleStyle = TextStyle(
    fontSize: 27,
    fontWeight: FontWeight.bold,
    letterSpacing: -2.0,
  );

    @override
    Widget build(BuildContext context) {
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
              context.watch<UserProvider>().loading == true ?
              LoadingShimmer() : (context.watch<UserProvider>().tickers.isEmpty ?
              Center(
                child: Text('없음', style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
                ),) : (ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: context.watch<UserProvider>().tickers.length,
                  itemBuilder: (context, index) {
                    return Holding(index: index);
                  })
              )),
            ]
        ),
      );
    }
  }

  class Holding extends StatefulWidget {
    const Holding({Key? key, this.index}) : super(key: key);
    final index;

    @override
    State<Holding> createState() => _HoldingState();
  }

  class _HoldingState extends State<Holding> with AfterLayoutMixin<Holding>{

    @override
    FutureOr<void> afterFirstLayout(BuildContext context) async {
      // TODO: implement afterFirstLayout
      if(mounted) await getData(homeGlobals.scaffoldKey.currentContext!);
  }

    getData(BuildContext mainContext) async {
      SchedulerBinding.instance.addPostFrameCallback((_) async {
        await mainContext.read<UserProvider>().getHoldingTicker();
        await mainContext.read<UserProvider>().getStockSummaryByTickers(
            mainContext.read<UserProvider>().tickers
        );
      });
    }

    @override
    Widget build(BuildContext context) {
      return GestureDetector(
        onTap: () {
          GoRouter.of(context).push('/stockDetail/${context.read<UserProvider>().tickers[widget.index]}');
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
                        Text('${context.read<UserProvider>().summaries.elementAt(widget.index)['name']}',
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              letterSpacing: -1.2,
                              fontSize: 17
                          ),),
                        Text('${context.watch<UserProvider>().summaries.elementAt(widget.index)['index']}',
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
                      '${addComma(context.watch<UserProvider>().summaries.elementAt(widget.index)['closingPrice'])}원',
                      style: TextStyle(
                          fontSize: 23,
                          color: context.watch<UserProvider>().summaries.elementAt(widget.index)['fluctuation'] > 0
                              ? Colors.redAccent
                              : Colors.blueAccent
                      ),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: context.watch<UserProvider>().summaries.elementAt(widget.index)['fluctuation'] > 0 ?
                      [
                        Icon(Icons.arrow_drop_up_rounded,
                            color: Colors.redAccent),
                        Text('${context.watch<UserProvider>().summaries.elementAt(widget.index)['fluctuation']} %',
                          style: TextStyle(fontSize: 15,
                              color: Colors.redAccent),)
                      ] : [
                        Icon(
                          Icons.arrow_drop_down_rounded,
                          color: Colors.blue,),
                        Text('${context.watch<UserProvider>().summaries.elementAt(widget.index)['fluctuation']} %',
                          style: TextStyle(
                              fontSize: 15, color: Colors.blue),)
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
    }
}

