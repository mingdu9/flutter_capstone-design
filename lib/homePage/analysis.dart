import 'package:flutter/material.dart';

class ReturnBox extends StatelessWidget {
  const ReturnBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var mainStyle = BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 1,
          blurRadius: 7,
          offset: const Offset(5,7),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('수익률', style: titleStyle,),
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: Text('{rate} %', style: TextStyle(
                    fontSize: 23
                ),),
              ),
            ],
          ),
          Divider(thickness: 1.0, color: Colors.grey.withOpacity(0.7), ),
          Analysis(name: '평가 손익',),
          Divider(thickness: 0.5, color: Colors.grey.withOpacity(0.7),),
          Analysis(name: '실현 손익'),
        ],
      ),
    );
  }
}

class Analysis extends StatelessWidget {
  const Analysis({Key? key, this.name}) : super(key: key);
  final name;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          style: TextButton.styleFrom(primary: Colors.black),
          onPressed: (){},
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('$name', style: TextStyle(
                  fontSize: 23, fontWeight: FontWeight.w500
                )),
                Text("{rate} %", style: TextStyle(
                  fontSize: 20
                ),),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
