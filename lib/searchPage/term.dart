import 'package:capstone1/providers/stock.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../providers/infomation.dart';


Widget shimmerBox(Size size){
  final shimmerBox = BoxDecoration(
      borderRadius: BorderRadius.circular(13),
      color: Colors.white
  );
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Shimmer.fromColors(
        baseColor: Color(0xFFE0E0E0),
        highlightColor: Color(0xFFF5F5F5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 14, width: size.width * 0.2,
              decoration: shimmerBox
            ),
            Padding(padding: EdgeInsets.all(3)),
            Container(
                height: 14, width: size.width * 0.4,
                decoration: shimmerBox
            ),
          ],
        ),
      ),
      IconButton(
          onPressed: (){ },
          icon: Icon(Icons.arrow_forward_ios)
      )
    ],
  );
}


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
              Text('????????? ??????', style: titleStyle,),
              IconButton(
                  onPressed: (){
                    context.read<InfoProvider>().getNewTerm();
                    },
                  icon: Icon(Icons.refresh_rounded)
              )
            ],
          ),
          Divider(),
          (context.watch<InfoProvider>().term.isEmpty?
          shimmerBox(MediaQuery.of(context).size) :
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
                child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:
            [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('[${context.watch<InfoProvider>().term['topic']}]',
                      style: TextStyle(
                          color: Colors.grey
                    ),),
                    Text(removeDetail(context.watch<InfoProvider>().term['term']),
                      style: TextStyle(
                          fontSize: 20,
                          overflow: TextOverflow.fade
                      ),
                    ),
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
                                    Text('[${context.watch<InfoProvider>().term['topic']}]', style: TextStyle(
                                        color: Colors.grey
                                    ),),
                                    Text(context.watch<InfoProvider>().term['term'], style: TextStyle(
                                        fontSize: 20, overflow: TextOverflow.fade, fontWeight: FontWeight.bold
                                    ),),
                                    Divider(thickness: 1.2, height: 20,),
                                    RichText(
                                      text: TextSpan(
                                          text: context.watch<InfoProvider>().term['ex'],
                                          style: TextStyle(
                                              color: Colors.black, fontSize: 16, height: 1.5
                                          )
                                      ),
                                    ),
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
              )),
        ],
      ),
    );
  }
}
