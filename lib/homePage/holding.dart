import 'package:capstone1/Models/User.dart';
import 'package:capstone1/Models/stock.dart';
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

  getData()async{
    await context.read<StoreUser>().defineUser();
  }

  getSumByTicker(ticker) async {
    var info = {};
    await firestore.collection('stocks').doc(ticker).collection('data')
        .orderBy('date', descending: true).limit(1).get()
        .then((value) => info.addAll(value.docs.first.data()))
        .catchError((e) => print(e));
    await firestore.collection('stocks').doc(ticker).get()
        .then((value) {info.addAll(value.data()!);
    }).catchError((e) => print(e));
    return info;
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
          Text('보유 종목', style: titleStyle,),
          Divider(thickness: 1.0, color: Colors.grey.withOpacity(0.7), ),
          context.watch<StoreUser>().tickers.isEmpty ? Center(child: Text('없음', style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Colors.black87
          ),),) :
          // (tickers.isEmpty ? Center(child: Text('없음', style: TextStyle(
          //     fontSize: 17,
          //     fontWeight: FontWeight.bold,
          //     color: Colors.black87
          // ),),) :
          Column(
            children: context.watch<StoreUser>().holdings.map((element){
              var summary = getSumByTicker(element['ticker']);
              return FutureBuilder(
                  future: summary,
                  builder: (BuildContext context, AsyncSnapshot snapshot){
                    if(snapshot.hasData){
                      return GestureDetector(
                          onTap: (){
                            GoRouter.of(context).go('/mainTab/0/stockDetail/${element['ticker']}');
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
                                          Text('${snapshot.data['name']}', style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              letterSpacing: -1.2,
                                              fontSize: 17
                                          ),),
                                          Text('${snapshot.data['index']}', style: TextStyle(
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
                                      Text('${snapshot.data['closingPrice']}원', style: TextStyle(
                                          fontSize: 23,
                                          color: snapshot.data['fluctuation'] > 0 ? Colors.red : Colors
                                              .blueAccent
                                      ),),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: snapshot.data['fluctuation'] > 0 ?
                                        [
                                          Icon(Icons.arrow_drop_up_rounded, color: Colors.red),
                                          Text('${snapshot.data['fluctuation']} %',
                                            style: TextStyle(fontSize: 15, color: Colors.red),)
                                        ] :
                                        [
                                          Icon(
                                            Icons.arrow_drop_down_rounded, color: Colors.blue,),
                                          Text('${snapshot.data['fluctuation']} %',
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
                    }else if(snapshot.hasError){
                      return Center(child: Text('${snapshot.error}'));
                    }else{
                      return Center(
                          child: CircularProgressIndicator()
                      );
                    }
                  }
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}