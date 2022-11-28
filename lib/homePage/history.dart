import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../providers/user.dart';
import 'profit/calculate.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
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
    fontSize: 25,
    fontWeight: FontWeight.bold,
    letterSpacing: -2.0,
  );
  final textStyle = TextStyle(
      fontSize: 25,
      fontWeight: FontWeight.w400,
      letterSpacing: -2.0
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<UserProvider>().getHistory();
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
        title: Text("거래 내역", style: TextStyle(color: Colors.black, fontWeight: FontWeight.values[4]),),

      ),
      body: ListView(
        physics: AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        padding: EdgeInsets.all(20),
        primary: false,
        children: [
          /*--------------------잔고 박스--------------------*/
          Container(
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.only(bottom: 20),
            decoration: shadowedBox,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('잔고', style: titleStyle,),
                Divider(thickness: 1.0, color: Colors.grey.withOpacity(0.5), ),
                Align(
                    alignment: Alignment.centerRight,
                    child: (context.watch<UserProvider>().balance >= 0 ?
                    Text("${addComma(context.watch<UserProvider>().balance)} 원",
                      style: textStyle,
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
          ),
          /*--------------------거래내역--------------------*/
          Container(
            decoration: shadowedBox,
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('거래 내역', style: titleStyle,),
                Divider(thickness: 1.0, color: Colors.grey.withOpacity(0.5), ),
                context.watch<UserProvider>().history.isNotEmpty ?
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: context.watch<UserProvider>().history.length,
                  itemBuilder: (context, index){
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${context.watch<UserProvider>().history[index]['time']}', style: TextStyle(
                                  color: Colors.black54
                                ),),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 5),
                                  child: Text('${context.watch<UserProvider>().history[index]['name']}', style: TextStyle(
                                    fontSize: 23, overflow: TextOverflow.fade,
                                  ),),
                                ),
                              ],
                            ),
                            Expanded(
                              child:  context.watch<UserProvider>().history[index]['value'] > 0 ?
                              Text('+${addComma(context.watch<UserProvider>().history[index]['value'])} 원', textAlign: TextAlign.end,
                                style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.redAccent
                                ),
                              ) :
                              Text('${addComma(context.watch<UserProvider>().history[index]['value'])} 원', textAlign: TextAlign.end,
                                style: TextStyle(
                                    fontSize: 22,
                                    color: Colors.blue
                                ),
                              ),
                            )
                          ],
                        ),
                        Divider(thickness: 0.5, color: Colors.grey.withOpacity(0.7),)
                      ],
                    );
                    },
                ) : Center(child: Text('거래 내역이 없어요', style: TextStyle(
                    fontSize: 20, letterSpacing: -1.2,
                    color: Colors.black87)),)
              ],
            ),
          )
        ],
      )
    );
  }
}
