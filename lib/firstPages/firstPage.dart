import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_animations/simple_animations.dart';

final auth = FirebaseAuth.instance;
final firestore = FirebaseFirestore.instance;

class StoreTabs extends ChangeNotifier{
  int tab = 0;

  setTab(int add){
    tab = add;
    notifyListeners();
  }
}

class RunPage extends StatefulWidget {
  const RunPage({Key? key,}) : super(key: key);

  @override
  State<RunPage> createState() => _RunPageState();
}

class _RunPageState extends State<RunPage> {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: size.height,
        padding: EdgeInsets.only(right: 18, left: 18, bottom: 20),
        alignment: Alignment.centerRight,
        child: FirstPage(),
      ),
    );
  }
}


class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Flexible(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              PlayAnimation<double>(
                  tween: Tween<double>(begin: 0.0, end: 1.0),
                  duration: Duration(milliseconds: 1300),
                  builder: (context, child, value){
                    return Text('안녕하세요.', textAlign: TextAlign.end, style: TextStyle(
                        letterSpacing: -1.2,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        foreground: Paint()..shader = LinearGradient(colors: <Color>[
                          Colors.blue.withOpacity(value), Color(0xffB484FF).withOpacity(value)
                        ]).createShader(Rect.fromLTWH(140.0, 0.0, 200.0, 0.0))
                    ),);
                  }
              ),
              Text('', style: TextStyle(fontSize: 15),),
              PlayAnimation<double>(
                  tween: Tween<double>(begin: 0.0, end: 1.0),
                  delay: Duration(milliseconds: 1300),
                  builder: (context, child, value){
                    return Column(
                      children: [
                        Text('본 앱은 주식 투자가', textAlign: TextAlign.end, style: TextStyle(
                            fontWeight: FontWeight.bold,
                            letterSpacing: -1.2,
                            fontSize: 25,
                            color: Colors.black.withOpacity(value)
                        ),),
                        Text('처음인 분들을 위한', textAlign: TextAlign.end, style: TextStyle(
                            fontWeight: FontWeight.bold,
                            letterSpacing: -1.2,
                            fontSize: 25,
                            color: Colors.black.withOpacity(value)
                        ),),
                      ],
                    );
                  }
              ),
              Text('', style: TextStyle(fontSize: 15),),
              PlayAnimation<double>(
                tween: Tween<double>(begin: 0.0, end: 1.0),
                delay: Duration(milliseconds: 1300*2),
                builder: (context, child, value) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('교육용 모의투자 ', style: TextStyle(
                          foreground: Paint()..shader = LinearGradient(colors: <Color>[
                            Colors.blue.withOpacity(value), Color(0xffB484FF).withOpacity(value)
                          ]).createShader(Rect.fromLTWH(90.0, 0.0, 200.0, 0.0)),
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          letterSpacing: -1.2
                      ),),
                      Text('앱입니다.', style: TextStyle(
                          color: Colors.black.withOpacity(value),
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          letterSpacing: -1.2
                      ))
                    ],
                  );
                },
              ),
            ],
          ),
        ),
        Flexible(
          flex: 3,
          child: PlayAnimation<double>(
              tween: Tween<double>(begin: 0.0, end: 0.7),
              delay: Duration(milliseconds: 1300*2+1000),
              builder: (context, child, value) {
                return Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                          begin: Alignment.centerLeft, end: Alignment.centerRight,
                          stops: const [0.0, 1.0],
                          colors: <Color>[
                            Colors.blue.withOpacity(value), Color(0xffB484FF).withOpacity(value)
                          ]
                      )
                  ),
                  child: ElevatedButton(
                    child: Icon(Icons.arrow_forward_ios, size: 30, color: Colors.white,),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      onPrimary: Colors.transparent,
                      elevation: 0,
                      splashFactory: NoSplash.splashFactory,
                      shape: CircleBorder(
                      )
                    ),
                    onPressed: () {
                      context.read<StoreTabs>().setTab(1);
                    },
                  ),
                );
              }) ,
        ),
      ],
    );
  }
}
