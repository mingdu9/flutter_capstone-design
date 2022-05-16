import 'package:capstone1/providers/User.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'analysis.dart';
import 'holding.dart';

final auth = FirebaseAuth.instance;
final firestore = FirebaseFirestore.instance;


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  getData()async{
    await context.read<StoreUser>().defineUser();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    getData();
    const titleStyle = TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.bold,
      letterSpacing: -2.0
    );
    if(context.watch<StoreUser>().balance >= 0){
      return ListView(
        physics: AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        padding: EdgeInsets.all(20),
        primary: false,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("안녕하세요 ,", style: titleStyle,),
                    Text("${auth.currentUser!.displayName ?? 'null'} 님", style: titleStyle,)
                  ]
              ),
            ],
          ),
          BalanceBox(balance: context.watch<StoreUser>().balance,),
          ReturnBox(),
          HoldingsBox(),
        ],
      );
    } else{
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}

class BalanceBox extends StatefulWidget {
  const BalanceBox({Key? key, this.balance}) : super(key: key);
  final int? balance;

  @override
  State<BalanceBox> createState() => _BalanceBoxState();
}

class _BalanceBoxState extends State<BalanceBox> {

  @override
  Widget build(BuildContext context) {
    var mainStyle = BoxDecoration(
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

    return ChangeNotifierProvider(
      create: (c) => StoreUser(),
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
        padding: EdgeInsets.all(20),
        decoration: mainStyle,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('잔고', style: titleStyle,),
            Divider(thickness: 1.0, color: Colors.grey.withOpacity(0.5), ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                child: Text("${widget.balance} 원",),
                onPressed: (){},
                style: TextButton.styleFrom(
                  primary: Colors.black,
                  textStyle: textStyle
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

