import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:capstone1/homePage/loadingShimmer.dart';
import 'package:capstone1/homePage/profit/calculate.dart';
import 'package:capstone1/providers/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class ReturnBox extends StatefulWidget {
  const ReturnBox({Key? key}) : super(key: key);

  @override
  State<ReturnBox> createState() => _ReturnBoxState();
}

class _ReturnBoxState extends State<ReturnBox> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '수익 분석',
                style: titleStyle,
              ),
              IconButton(
                  onPressed: (){GoRouter.of(context).push('/profitDetail');},
                  icon: Icon(Icons.arrow_forward_ios)
              )
            ],
          ),
          Divider(
            thickness: 1.0,
            color: Colors.grey.withOpacity(0.7),
          ),
          ( context.watch<UserProvider>().loading == true ?
              LoadingShimmer() : (context.watch<UserProvider>().tickers.isEmpty ? Center(
                  child: Text('없음', style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),)
              : ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: context.watch<UserProvider>().tickers.length >= 3 ? 3 : context.watch<UserProvider>().tickers.length,
                  itemBuilder: (context, index) {
                      return HoldingReturn(index: index,);
                  }))
          )
        ],
      ),
    );
  }
}

class HoldingReturn extends StatefulWidget {
  const HoldingReturn({Key? key, this.index}) : super(key: key);
  final index;

  @override
  State<HoldingReturn> createState() => _HoldingReturnState();
}

class _HoldingReturnState extends State<HoldingReturn> with AfterLayoutMixin<HoldingReturn> {

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) async {
    // TODO: implement afterFirstLayout
      getData();
  }

  getData() async {
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await context.read<UserProvider>().getHoldingTicker();
      await context.read<UserProvider>().getStockSummaryByTickers(
        context.read<UserProvider>().tickers
      );
      if(mounted){
        context.read<UserProvider>().calculateValuationProfitByTicker(
            context.read<UserProvider>().tickers[widget.index]);
      }
    });

  }

  @override
  Widget build(BuildContext context) {
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
                  children: [
                    Text('${context.read<UserProvider>().summaries.elementAt(widget.index)['name']}',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          letterSpacing: -1.2,
                          fontSize: 17),
                    ),
                    Text('${context.watch<UserProvider>().summaries.elementAt(widget.index)['index']}',
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
                    Text('${context.watch<UserProvider>().valuationProfitRate.toStringAsFixed(2)} %',
                      style: TextStyle(
                          fontSize: 23,
                          color: Colors.redAccent),)
                  ] : context.watch<UserProvider>().valuationProfitRate == 0 ? [
                    Text('- ${context.watch<UserProvider>().valuationProfitRate.toStringAsFixed(2)} %',
                      style: TextStyle(
                          fontSize: 23,
                          color: Colors.grey),)
                  ]: [
                    Icon(Icons.arrow_drop_down_rounded, color: Colors.blue,),
                    Text('${context.watch<UserProvider>().valuationProfitRate.toStringAsFixed(2)} %',
                      style: TextStyle(
                          fontSize: 23,
                          color: Colors.blue),)
                  ]
                ),
            Text('${addComma(context.watch<UserProvider>().valuationProfit.ceil())}원',
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
    );
  }
}
