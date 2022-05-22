import 'package:capstone1/providers/stock.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TermBox extends StatefulWidget {
  const TermBox({Key? key}) : super(key: key);

  @override
  State<TermBox> createState() => _TermBoxState();
}

class _TermBoxState extends State<TermBox> {
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

  String removeDetail(String name){
    List<String> result = [];
    if(name.contains("(")){
      result = name.split("(");
      return result[0];
    }else {
      return name;
    }
  }


  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: shadowedBox,
      margin: EdgeInsets.only(top: 20, bottom: 10),
      padding: EdgeInsets.only(top: 13, bottom: 20, left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('오늘의 용어', style: titleStyle,),
              IconButton(
                  onPressed: (){
                    context.read<StorePrice>().getNewTerm();
                    },
                  icon: Icon(Icons.refresh_rounded)
              )
            ],
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('[${context.watch<StorePrice>().term['topic']}]', style: TextStyle(
                    color: Colors.grey
                  ),),
                  Text(removeDetail(context.watch<StorePrice>().term['term']), style: TextStyle(
                    fontSize: 20, overflow: TextOverflow.fade
                  ),),
                ],
              ),
              IconButton(
                  onPressed: (){
                    showDialog(
                        context: context,
                        builder: (context){
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: ListView(
                                physics: AlwaysScrollableScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                children: [
                                  Text('[${context.watch<StorePrice>().term['topic']}]', style: TextStyle(
                                      color: Colors.grey
                                  ),),
                                  Text(context.watch<StorePrice>().term['term'], style: TextStyle(
                                      fontSize: 20, overflow: TextOverflow.fade, fontWeight: FontWeight.bold
                                  ),),
                                  Divider(thickness: 1.2, height: 20,),
                                  RichText(
                                    text: TextSpan(
                                        text: context.watch<StorePrice>().term['ex'],
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 16
                                        )
                                    ),
                                  ),
                                  Divider(thickness: 1.2, height: 20,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text('알고 있었나요?', style: TextStyle(fontSize: 18),),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                              onPressed: (){
                                                Navigator.pop(context);
                                                print("Yes");
                                                },
                                              child: Text('네'),
                                              style: TextButton.styleFrom(
                                                  primary: Colors.black,
                                                  padding: EdgeInsets.all(3)
                                              ),
                                          ),
                                          TextButton(
                                              onPressed: (){
                                                print("NO");
                                                Navigator.pop(context);
                                                },
                                              child: Text('아니요'),
                                              style: TextButton.styleFrom(
                                                primary: Colors.black,
                                                padding: EdgeInsets.all(3)
                                              ),
                                          ),
                                        ]
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                  },
                  icon: Icon(Icons.arrow_forward_ios)
              )
            ],
          ),
        ],
      ),
    );
  }
}
