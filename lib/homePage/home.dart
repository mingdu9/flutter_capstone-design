import 'package:capstone1/providers/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shimmer/shimmer.dart';

import 'analysis.dart';
import 'holding.dart';
import 'profit/calculate.dart';

final auth = FirebaseAuth.instance;
final firestore = FirebaseFirestore.instance;


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  getData()async{
    await context.read<UserProvider>().defineUser();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    //getData();
    const titleStyle = TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.bold,
      letterSpacing: -2.0
    );
      return ListView(
        physics: AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        padding: EdgeInsets.all(20),
        primary: false,
        children: [
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("안녕하세요 ,", style: titleStyle,),
                Text("${auth.currentUser!.displayName ?? 'null'} 님", style: titleStyle,)
              ]
          ),
          BalanceBox(),
          ReturnBox(),
          HoldingsBox(),
        ],
      );
    }
  }


class BalanceBox extends StatefulWidget {
  const BalanceBox({Key? key}) : super(key: key);

  @override
  State<BalanceBox> createState() => _BalanceBoxState();
}

class _BalanceBoxState extends State<BalanceBox> {

  @override
  Widget build(BuildContext context) {
    const titleStyle = TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        letterSpacing: -2.0,
        color: Colors.black
    );
    const textStyle = TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.w400,
        letterSpacing: -2.0
    );

    return Container(
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
            child: (context.watch<UserProvider>().balance >= 0 ? TextButton(
              onPressed: (){},
              style: TextButton.styleFrom(
                  foregroundColor: Colors.black, textStyle: textStyle
              ),
              child: Text("${addComma(context.watch<UserProvider>().balance)} 원",),
            ) : Shimmer.fromColors(
                baseColor: Color(0xFFE0E0E0),
                highlightColor: Color(0xFFF5F5F5),
                child: Padding(
                  padding: const EdgeInsets.all(13.6),
                  child: Container(
                    width : MediaQuery.of(context).size.width * 0.3, height: 25,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(13),
                      color: Colors.white,
                    ),
                  ),
                ))
            )
          )
        ],
      ),
    );
  }
}

